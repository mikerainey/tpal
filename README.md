Getting Started Guide
=====================

**Hardware dependencies** The experiments require a machine with
multiple x86-64 cores and well-provisioned RAM. Of our test machines,
the one with the minimum amount of RAM has 74GB, but this amount is
likely more than is needed.

**Software dependencies** Our build scripts depend on the [nix package
manager](https://nixos.org/nix/download.html).

Installation
------------

~~~~
$ nix-build
~~~~

Experimental workflow
---------------------

~~~~
$ ./result/bench work_efficiency linux_work_efficiency linux_vs_cilk
~~~~

Step-by-Step Instructions
=========================


Format of the csv results files
-------------------------------

Definitions:

- H: frequency of the heartbeat timer interrupt, e.g., H=20us or H=100us
- P: nb cores, e.g., 1, 15
- INT-PingThread: the heartbeat mechanism that uses one thread to trigger the heartbeat interrupts on the worker threads
- INT-Papi: the heartbeat mechanism that uses papi performance counters to trigger the heartbeat interrupts on the worker threads
- INT-Pthread: defunct configuration

### Work efficiency

For all benchmarks in this category, number of cores P=1.

Work efficiency results are stored across five csv files. The first
one is named `results_work_efficiency.csv`, and its columns are as
such:

1. name of benchmark program
2. name of benchmark input
3. exectime (s) of the serial baseline program
4. exectime (s) of the single-core execution of the heartbeat program, with the heartbeat mechanism disabled

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.070, 0.070
...
~~~~~~~~~

The second and third files are named
`results_interrupt_work_efficiency_linux_ping_thread.csv` and
`results_interrupt_work_efficiency_nautilus_ping_thread.csv`, and
their columns are as such:

1.  name of benchmark program
2.  name of benchmark input
3.  exectime (s) of the serial baseline program
4.  exectime (s) of the serial baseline program (INT-PingThread) with H=20us
5.  exectime (s) of the serial baseline program (INT-PingThread) with H=100us
6.  exectime (s) of the heartbeat program (INT-PingThread) with H=20us
7.  nb promotions per second of the heartbeat program (INT-PingThread) with H=20us
8.  nb heartbeats per second of the heartbeat program (INT-PingThread) with H=20us
9.  exectime (s) of the heartbeat program (INT-PingThread) with H=100us
10. nb promotions per second of the heartbeat program (INT-PingThread) with H=100us
11. nb heartbeats per second of the heartbeat program (INT-PingThread) with H=100us

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.070, 0.077, 0.072, 0.079, 99800.000000, 50462.500000, 0.074, 20273.972603, 10164.383562
...
~~~~~~~~~

The fourth file is named
`results_interrupt_work_efficiency_linux_other.csv`, and its columns
are as such:

1.  name of benchmark program
2.  name of benchmark input
3.  exectime (s) of the serial baseline program
4.  exectime (s) of the serial baseline program (INT-Papi) with H=20us
5.  exectime (s) of the serial baseline program (INT-Papi) with H=100us
6.  exectime (s) of the heartbeat program (INT-Papi) with H=20us
7.  nb promotions per second of the heartbeat program (INT-Papi) with H=20us
8.  nb heartbeats per second of the heartbeat program (INT-Papi) with H=20us
9.  exectime (s) of the heartbeat program (INT-Papi) with H=100us
10. nb promotions per second of the heartbeat program (INT-Papi) with H=100us
11. nb heartbeats per second of the heartbeat program (INT-Papi) with H=100us

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.070, 0.085, 0.074, 103772.727273, 52204.545455, 0.075, 23733.333333, 11893.333333
...
~~~~~~~~~

### Heartbeat vs Cilk

For all benchmarks in this category, number of cores P=15.

The file for this experiment is named
`results_linux_vs_cilk_proc_P_kappa_usec_H.csv`, for various settings of H,
and its format is as such:

1.  name of benchmark program
2.  name of benchmark input
3.  exectime (s) of the Cilk program
4.  exectime (s) of the heartbeat program (INT-PingThread)
5.  utilization (%) of the Cilk program
6.  utilization (%) of the heartbeat program (INT-PingThread)
7.  nb promotions of the Cilk program
8.  nb promotions of the heartbeat program (INT-PingThread)

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.093, 0.067, 0.933633, 0.990667, 4380.666667, 8643.333333
...
~~~~~~~~~

### Scaling

For all benchmarks in this category, number of cores P=15.

The files for this experiment are named
`results_parallel_heartbeat_linux_ping_thread_kappa_usec_H.csv` and
`results_parallel_heartbeat_nautilus_ping_thread_kappa_usec_H.csv`,
and their format is as such:

1. name of benchmark program
2. name of benchmark input
3. exectime (s) of the serial baseline program
4. exectime (s) of the heartbeat program (INT-PingThread)
5. utilization of the heartbeat program (INT-PingThread)
6. nb promotions per second of the heartbeat program (INT-PingThread)
7. nb heartbeats per second of the heartbeat program (INT-PingThread)

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.070, 0.023, 0.987523, 814347.826087, 481913.043478
...
~~~~~~~~~

The file for this experiment is named
`results_parallel_heartbeat_linux_other_kappa_usec_H.csv`, and its
format is as such:

1.  name of benchmark program
2.  name of benchmark input
3.  exectime (s) of the serial baseline program
4.  exectime (s) of the heartbeat program (INT-Papi)
5.  utilization of the heartbeat program (INT-Papi)
6. nb promotions per second of the heartbeat program (INT-Papi)
7. nb heartbeats per second of the heartbeat program (INT-Papi)

~~~~~~~~~
plus-reduce-array, $100 \cdot 10^6$ 64-bit doubles, 0.115, 0.090, 0.991314, 395665.427509, 217498.141264
...
~~~~~~~~~
