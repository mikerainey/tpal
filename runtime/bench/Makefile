ifeq (, $(shell which jemalloc-config))
JEMALLOC =
else
JEMALLOCLD = $(shell jemalloc-config --libdir)
JEMALLOC = -L$(JEMALLOCLD) -ljemalloc
endif

INCLUDE_FILES=$(wildcard $(CMDLINE_PATH)/*.hpp) $(wildcard $(MCSL_PATH)/*.hpp) $(wildcard ../include/*.hpp)  $(wildcard ./*.hpp)

INCLUDE_PREFIX=-I $(CMDLINE_PATH) -I $(MCSL_PATH) -DMCSL_LINUX -I ../include/ $(HWLOC_INCLUDE_PREFIX) -I $(PAPI_PREFIX)/include

LINKER_PREFIX=-pthread $(HWLOC_LIBRARY_PREFIX) -lrt -L $(PAPI_PREFIX)/lib -lpapi -ldl

OPT_BASE_PREFIX=-O2 -m64 -march=native -fno-asynchronous-unwind-tables -fno-omit-frame-pointer -DNDEBUG # -DNDEBUG # later: find out why uncommenting dndebug causes spmv to crash
OPT_PREFIX=--std=c++17 $(OPT_BASE_PREFIX) $(INCLUDE_PREFIX) $(LINKER_PREFIX)
STA_PREFIX=-DSPAWNBENCH_STATS $(OPT_PREFIX)
LOG_PREFIX=-DSPAWNBENCH_LOGGING $(STA_PREFIX)
DBG_PREFIX=--std=c++17 -m64 -O0 -g3 -DSPAWNBENCH_STATS -DSPAWNBENCH_LOGGING $(INCLUDE_PREFIX) $(LINKER_PREFIX) -Wno-cpp

%.opt: %.cpp $(INCLUDE_FILES)
	$(CPP) $(OPT_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.sta: %.cpp $(INCLUDE_FILES)
	$(CPP) $(STA_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.log: %.cpp $(INCLUDE_FILES)
	$(CPP) $(LOG_PREFIX) $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.opt_cilk: %.cpp $(INCLUDE_FILES)
	$(CPP) $(OPT_PREFIX) -fcilkplus -DUSE_CILK_PLUS $(basename $<)_manual.s -o $@ $< $(JEMALLOC) 

%.dbg: %.cpp $(INCLUDE_FILES)
	$(CPP) $(DBG_PREFIX) -DSPAWNBENCH_STATS $(basename $<)_manual.s -o $@ $<

%.dbg_cilk: %.cpp $(INCLUDE_FILES)
	$(CPP) $(DBG_PREFIX) -fcilkplus -DUSE_CILK_PLUS $(basename $<)_manual.s -o $@ $<

spmv_manual.s: spmv_manual_orig.s
	cpp spmv_manual_orig.s > spmv_manual.s

%.s: %.c $(INCLUDE_FILES)
	$(CC) $(OPT_BASE_PREFIX) -S -o $@ $<

clean: 
	rm -f spmv_manual2.s *.opt *.dbg *.dbg_cilk *.opt_cilk *.sta *.log *.ii *~ *.o *.i vgcore.*
