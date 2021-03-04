Getting Started Guide
=====================

To get started, we need to first check that our machine is suitable
for these experiments, and then if it is, install the benchmarking
infrastructure on our local machine. Finally, we need to make sure we
can run the benchmarks and obtain results.

**Hardware dependencies** The experiments require a machine with
multiple x86-64 cores and well-provisioned RAM, e.g., 50GB or more.

**Software dependencies** Our artifact depends on the [nix package
manager](https://nixos.org/nix/download.html).

Installation
------------

Once `nix` is installed, we can change directory to where our `nix`
build scripts are stored.

~~~~
$ cd tpal/runtime/nix
~~~~

Now, we build the artifact as follows.

~~~~
$ nix-build
~~~~

If successful, there will appear in the current directory a symlink
named `result`.

Experimental workflow
---------------------

We can now perform a complete run of the Linux-based benchmarks by
executing the following command.

~~~~
$ ./result/bench work_efficiency linux_work_efficiency linux_vs_cilk
~~~~

If the command takes a long time, you can pick some subset of the
benchmarks to run by following instructions given in the sequel.

Once complete, there will appear in the current directory several PDF
files, such as the following.

- `tables_work_efficiency.pdf`
- `tables_interrupt_work_efficiency_linux_ping_thread.pdf`
- `tables_linux_vs_cilk_proc_1_kappa_usec_20.pdf`
- `tables_linux_vs_cilk_proc_15_kappa_usec_20.pdf`
- `tables_linux_vs_cilk_proc_1_kappa_usec_100.pdf`
- `tables_linux_vs_cilk_proc_15_kappa_usec_100.pdf`

Note that the results in these tables are incomplete until we can
collect multiple samples of each benchmark run. In the sequel we cover
these steps.

Also, in the sequel, we explain how to relate the results in these
tables to results reported in the paper.

Step-by-Step Instructions
=========================

We are now ready to collect the results of our experimental
evaluation. To do so, we need to make a complete run of the
Linux-based experiments, which is done by setting the `-runs`
parameter, as shown below.

~~~~
$ ./result/bench linux_vs_cilk -runs 25
~~~~

Note that it may take a few hours to complete.

Claims in the paper supported by this artifact
----------------------------------------------

In the paper, we ran benchmarks in Linux and Nautilus, an experimental
microkernel. However, for our artifact, we believe it is best to
collect only the Linux-related claims. The reason is that Nautilus is
currently has limited compatibility with stock hardware, and can
capture output only via a serial port.

We now address (the Linux-related part of) each claim in the paper.

### Claim: TPAL's task creation overheads are lower than Cilk's

In the paper: Figure 6

In our results: `tables_linux_vs_cilk_proc_1_kappa_usec_100.pdf`

In the results table, the columns to consider are the ones labeled
"Cilk" and the first column under "INT-PingThread", which represents
TPAL.

### Claim: TPAL performs better than Cilk at full scale

In the paper: Figure 7

In our results: `tables_linux_vs_cilk_proc_15_kappa_usec_100.pdf`

In the results table, the columns to consider are the ones labeled
"Cilk" and the first column under "INT-PingThread", which represents
TPAL.

### Claim: TPAL's compilation-related performance overhead is low

In the paper: Figure 8

In our results: `tables_work_efficiency.pdf`

The column to consider is the one labeled "TPAL".

### Claim: Signal overhead is low but could be improved

In the paper: Figure 9

In our results: `tables_interrupt_work_efficiency_linux_ping_thread.pdf`

In the plot in the paper and the table in our results, we consider the
bars and columns labeled "Serial".

### Claim: Promotion overhead is low but could be improved

In the paper: Figure 9

In our results: `tables_interrupt_work_efficiency_linux_ping_thread.pdf`

In the plot in the paper and the table in our results, we consider the
bars and columns labeled "TPAL".

### Claim: Linux misses its target heartbeat rate

In the paper: Figure 10

In our results: `tables_interrupt_work_efficiency_linux_ping_thread.pdf`

In the plot in the paper and the table in our results, we consider the
bars and columns labeled "Heartbeats per sec".

Benchmarking customization
--------------------------

### Setting the number of cores

In order to obtain clean results, it is important that the benchmarks
are configured to use (at most) P-1 cores, where P is the total number
of cores in the machine. Please check that the P you use does in fact
count the number of *cores*, not SMT units.

Our benchmark script tries to determine P-1 for your test machine
automatically, and should get the right number. We can check by
looking at the arguments passed to the benchmarks by the `bench`
script. For example, on our test machine, we have P=16 cores. The
script should always pass on the command line to the parallel
benchmark runs the argument `-proc 15`.

We can pick the number manually by passing an extra argument to our
benchmarking script.

~~~~
$ ./result/bench linux_vs_cilk -proc 7
~~~~

Note that the only experiment that uses multiple cores is the one
named `linux_vs_cilk`.

### Setting the heartbeat rate

By default, our benchmarking script collects results using heartbeat
rates of 20 and 100 microseconds. Your machine might benefit from
different settings. To see how, we can specify the settings by the
command-line argument shown below.

~~~~
$ ./result/bench linux_vs_cilk -kappa_usec 120,200,300
~~~~

### Picking which benchmarks to run

We can run the experiments for only a subset of benchmarks.

~~~~
$ ./result/bench linux_vs_cilk -benchmarks floyd_warshall,knapsack
~~~~

### Experimenting with different signaling mechanisms in Linux

There are two other mechanisms available in Linux that we considered
for driving the Heartbeat interrupt. 

The first one uses a mechanism exported by the Papi library, which
triggers an interrupt every time there has elapsed some specified
number of CPU cycles. The Papi mechanism requires performance counters
be enabled in the Linux kernel.

The second mechanism uses a Linux-specific extension that allows
Pthreads to handle timer-based interrupts directly.

We did not report results for these mechanisms in the paper owing to
space considerations and that they were generally slower than our
default, namely PingThread, configuration. However, we can benchmark
using all available mechanisms by passing to our benchmarking script
the following command-line arguments.

~~~~
$ ./result/bench work_efficiency linux_work_efficiency linux_vs_cilk -skip_interrupts none -skip_serial_interrupts none
~~~~

Format of the csv results files
-------------------------------

In this section, we summarize the raw data output by the benchmarking
scripts.

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
