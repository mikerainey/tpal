INSTALL_FOLDER=.

ifeq (, $(shell which jemalloc-config))
JEMALLOC =
else
JEMALLOCLD = $(shell jemalloc-config --libdir)
JEMALLOC = -L$(JEMALLOCLD) -ljemalloc
endif

INCLUDE_FILES=$(wildcard $(CMDLINE_PATH)/*.hpp) $(wildcard $(MCSL_PATH)/*.hpp) $(wildcard ../include/*.hpp)  $(wildcard ./*.hpp)

INCLUDE_PREFIX=-I $(CMDLINE_PATH) -I $(MCSL_PATH) -DMCSL_LINUX -DTPALRTS_LINUX -I ../include/ $(HWLOC_INCLUDE_PREFIX) -I $(PAPI_PREFIX)/include -Wno-write-strings -Wno-format-zero-length

LINKER_PREFIX=-pthread $(HWLOC_LIBRARY_PREFIX) -lrt -L $(PAPI_PREFIX)/lib -lpapi -ldl

OPT_BASE_PREFIX=-O3 -m64 -march=x86-64 -fno-asynchronous-unwind-tables -fomit-frame-pointer -DNDEBUG
OPT_PREFIX=--std=c++17 $(OPT_BASE_PREFIX) $(INCLUDE_PREFIX) $(LINKER_PREFIX)
STA_PREFIX=-DTPALRTS_STATS $(OPT_PREFIX)
LOG_PREFIX=-DTPALRTS_LOGGING $(STA_PREFIX)
DBG_PREFIX=--std=c++17 -m64 -O0 -g3 -DTPALRTS_STATS -DTPALRTS_LOGGING $(INCLUDE_PREFIX) $(LINKER_PREFIX) -Wno-cpp
CILK_PREFIX=-fcilkplus -DUSE_CILK_PLUS $(CILK_EXTRAS_PREFIX)
OPT_CILK_PREFIX=$(OPT_PREFIX) $(CILK_PREFIX)
DBG_CILK_PREFIX=$(DBG_PREFIX) $(CILK_PREFIX)

%.opt: %.cpp $(INCLUDE_FILES)
	$(CPP) $(OPT_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.sta: %.cpp $(INCLUDE_FILES)
	$(CPP) $(STA_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.log: %.cpp $(INCLUDE_FILES)
	$(CPP) $(LOG_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.opt_cilk: %.cpp $(INCLUDE_FILES)
	$(CPP) $(OPT_CILK_PREFIX)  $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.dbg: %.cpp $(INCLUDE_FILES)
	$(CPP) $(DBG_PREFIX) $(basename $<)_manual.s -o $@ $<

%.dbg_cilk: %.cpp $(INCLUDE_FILES)
	$(CPP) $(DBG_CILK_PREFIX) $(basename $<)_manual.s -o $@ $<

spmv_manual.s: spmv_manual_orig.s
	cpp spmv_manual_orig.s > spmv_manual.s

%.s: %.c $(INCLUDE_FILES)
	$(CC) $(OPT_BASE_PREFIX) -S -o $@ $<

BENCHMARKS=\
	incr_array \
	plus_reduce_array \
	spmv \
	mandelbrot \
	kmeans \
	floyd_warshall \
	knapsack \
	mergesort

all2:
install2:

all: \
	$(BENCHMARKS:%=%.opt) $(BENCHMARKS:%=%.opt_cilk) \
	$(BENCHMARKS:%=%.sta)

install:
	cp *.opt *.opt_cilk *.sta $(INSTALL_FOLDER)
	cp run $(INSTALL_FOLDER)
	cp knapsack-036.input $(INSTALL_FOLDER)

clean: 
	rm -f spmv_manual2.s *.opt *.dbg *.dbg_cilk *.opt_cilk *.sta *.log *.ii *~ *.o *.i vgcore.*

clean_results:
	rm -rf ../nix/*.txt ../nix/*.tex ../nix/*.pdf ../nix/_results
