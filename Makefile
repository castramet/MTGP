# @file  Makefile
# @brief Makefile
#
# @author Mutsuo Saito (Hiroshima University)
# @author Makoto Matsumoto (Hiroshima University)
#
# Copyright (C) 2009 Mutsuo Saito, Makoto Matsumoto and
# Hiroshima University. All rights reserved.
#
# The new BSD License is applied to this software.
# see LICENSE.txt
#

WARN = -Wmissing-prototypes -Wall #-Winline
#WARN = -Wmissing-prototypes -Wall -W
OPTI = -O3 -finline-functions -fomit-frame-pointer -DNDEBUG \
-fno-strict-aliasing
#--param inline-unit-growth=500 --param large-function-growth=900 #for gcc 4
#DEBUG = -DDEBUG -g -O0
#STD =
#STD = -std=c89 -pedantic
#STD = -std=c99 -pedantic
STD = -std=c99
CC = gcc
NVCC = nvcc
CUTILINC = -I$(HOME)/NVIDIA_CUDA_SDK/common/inc
CUTILLIB = -L$(HOME)/NVIDIA_CUDA_SDK/lib -lcutil
CUDALINK = -lcuda
CPP = g++
CPPFLAGS = -Wall -Wextra -O3 -msse3
CCFLAGS = $(OPTI) $(WARN) $(STD) $(DEBUG)
# ==========================================================
# comment out or EDIT following lines to get max performance
# ==========================================================
# --------------------
# for gcc 4
# --------------------
#CCFLAGS += --param inline-unit-growth=500 \
#--param large-function-growth=900
# --------------------
# for icl
# --------------------
#CC = icl /Wcheck /O3 /QxB /Qprefetch
# --------------------
# for icc
# --------------------
#CC = icc
#OPTI = -O3 -finline-functions -fomit-frame-pointer -DNDEBUG \
#-fno-strict-aliasing
#CCFLAGS = $(OPTI) $(WARN) $(STD)
# -----------------
# for PowerPC
# -----------------
#CCFLAGS += -arch ppc
# -----------------
# for Pentium M
# -----------------
#CCFLAGS += -march=prescott
# -----------------
# for Athlon 64
# -----------------
#CCFLAGS += -march=athlon64
OBJS = mtgp32-fast.o mtgp64-fast.o mtgp32-param-fast.o mtgp64-param-fast.o

all:test64-ref test64-fast test32-ref test32-fast ${OBJS}

test64-ref: mtgp64-ref.h mtgp64-ref.c mtgp64-param-ref.o
	${CC} ${CCFLAGS} -DMAIN=1 -o $@ mtgp64-ref.c mtgp64-param-ref.o

test64-fast: mtgp64-fast.h mtgp64-fast.c mtgp64-param-fast.o
	${CC} ${CCFLAGS} -DMAIN=1 -o $@ mtgp64-fast.c mtgp64-param-fast.o

test32-ref: mtgp32-ref.h mtgp32-ref.c mtgp32-param-ref.o
	${CC} ${CCFLAGS} -DMAIN=1 -o $@ mtgp32-ref.c mtgp32-param-ref.o

test32-fast: mtgp32-fast.h mtgp32-fast.c mtgp32-param-fast.o
	${CC} ${CCFLAGS} -DMAIN=1 -o $@ mtgp32-fast.c mtgp32-param-fast.o

test32-cuda: mtgp32-cuda.cu mtgp32-fast.h mtgp32-param-fast.o mtgp32-fast.o
	${NVCC} -o $@ mtgp32-cuda.cu mtgp32-param-fast.o mtgp32-fast.o \
	 ${CUTILINC} ${CUTILLIB} ${CUDALINK}

test32-cuda-tex: mtgp32-cuda-tex.cu mtgp32-fast.h mtgp32-param-fast.o \
	mtgp32-fast.o
	${NVCC} -o $@ mtgp32-cuda-tex.cu mtgp32-param-fast.o mtgp32-fast.o \
	 ${CUTILINC} ${CUTILLIB} ${CUDALINK}

test32-cuda256-tex: mtgp32-cuda256-tex.cu mtgp32-fast.h mtgp32-param-fast.o \
	mtgp32-fast.o
	${NVCC} -o $@ mtgp32-cuda256-tex.cu mtgp32-param-fast.o mtgp32-fast.o \
	 ${CUTILINC} ${CUTILLIB} ${C	UDALINK}

test64-cuda: mtgp64-cuda.cu mtgp64-fast.h mtgp64-param-fast.o mtgp64-fast.o
	${NVCC} -o $@ mtgp64-cuda.cu mtgp64-param-fast.o mtgp64-fast.o \
	 ${CUTILINC} ${CUTILLIB} ${CUDALINK}

test64-cuda-tex: mtgp64-cuda-tex.cu mtgp64-fast.h mtgp64-param-fast.o \
	mtgp64-fast.o
	${NVCC} -o $@ mtgp64-cuda-tex.cu mtgp64-param-fast.o mtgp64-fast.o \
	 ${CUTILINC} ${CUTILLIB} ${CUDALINK}

.c.o:
	${CC} ${CCFLAGS} -c $<

clean:
	rm -f *.o *~
