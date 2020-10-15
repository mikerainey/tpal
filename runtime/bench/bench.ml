open XBase
open Params

let system = XSys.command_must_succeed_or_virtual

(*****************************************************************************)
(** Parameters *)

let arg_virtual_run = XCmd.mem_flag "virtual_run"
let arg_virtual_build = XCmd.mem_flag "virtual_build"
let arg_benchmarks = XCmd.parse_or_default_list_string "benchmarks" []
let arg_nb_runs = XCmd.parse_or_default_int "runs" 1
let arg_mode = Mk_runs.mode_from_command_line "mode"
let arg_skips = XCmd.parse_or_default_list_string "skip" []
let arg_onlys = XCmd.parse_or_default_list_string "only" []
let arg_proc =
  let cmdline_proc = XCmd.parse_or_default_int "proc" 0 in
  let default =
    if cmdline_proc > 0 then
      cmdline_proc
    else
      let _ = system "get-nb-cores.sh > nb_cores" false in
      let chan = open_in "nb_cores" in
      let str = try input_line chan
      with End_of_file -> (close_in chan; "1")
      in
      int_of_string str
  in
  let default = default - 1 in
  XCmd.parse_or_default_int "proc" default
let arg_proc_step = XCmd.parse_or_default_int "proc_step" 10
let arg_dflt_size = XCmd.parse_or_default_int "n" 600000000
let arg_par_baseline = XCmd.parse_or_default_string "par_baseline" "cilk"
let arg_kappas_usec = XCmd.parse_or_default_list_int "kappa_usec" [20;100]
let arg_output_csv = XCmd.mem_flag "output_csv"
let arg_elide_baseline = XCmd.mem_flag "elide_baseline"
let arg_par_timeout = XCmd.parse_or_default_int "par_timeout" 220
let arg_seq_timeout = XCmd.parse_or_default_int "seq_timeout" 220
let arg_results_path = XCmd.parse_or_default_string "results_path" "."
let arg_show_execcycles = XCmd.mem_flag "show_execcycles"
let arg_skip_nautilus = XCmd.mem_flag "skip_nautilus"

let run_modes =
  Mk_runs.([
    Mode arg_mode;
    Virtual arg_virtual_run;
    Runs arg_nb_runs; ])
                  
(*****************************************************************************)
(** Steps *)

let select make run check plot =
   let arg_skips =
      if List.mem "run" arg_skips && not (List.mem "make" arg_skips)
         then "make"::arg_skips
         else arg_skips
      in
   Pbench.execute_from_only_skip arg_onlys arg_skips [
      "make", make;
      "run", run;
      "check", check;
      "plot", plot;
      ]

let nothing () = ()

(*****************************************************************************)
(** Files and binaries *)

let build path bs is_virtual =
   system (sprintf "make -C %s -j %s" path (String.concat " " bs)) is_virtual

let file_results exp_name =
  Printf.sprintf "%s/results_%s.txt" arg_results_path exp_name

let file_results_cilk exp_name =
  Printf.sprintf "%s/results_%s_cilk.txt" arg_results_path exp_name

let file_results_sta exp_name =
  Printf.sprintf "%s/results_%s_sta.txt" arg_results_path exp_name

let file_plots exp_name =
  Printf.sprintf "plots_%s.pdf" exp_name

let file_tables_src exp_name =
  Printf.sprintf "tables_%s.tex" exp_name

let file_tables exp_name =
  Printf.sprintf "tables_%s.pdf" exp_name
  
(** Evaluation functions *)

let eval_exectime = fun env all_results results ->
   Results.get_mean_of "exectime" results

let formatter =
 Env.format (Env.(
       [ ("scheduler_configuration", Format_custom (fun n ->
                                         if n = "software_polling" then "Software polling"
                                         else if n = "interrupt_ping_thread" then "HW interrupt (pthread_kill)"
                                         else if n = "interrupt_pthread" then "HW interrupt (direct to pthread)"
                                         else if n = "interrupt_papi" then "HW interrupt (papi)"
                                         else if n = "manual" then "Manual"
                                         else n));
         ("kappa_usec", Format_custom (fun n -> Printf.sprintf "heartbeat=%s usec" n));
         ("manual_T", Format_custom (fun n -> Printf.sprintf "Thresh=%s" n));
         ("n", Format_custom (fun n -> Printf.sprintf "Array: %s 64-bit ints" n));
       ]
   ))

let prog_heartbeat = "run"
let prog_cilk = "run"

let scheduler_configuration = "scheduler_configuration"
              
let mk_scheduler_configuration =
  mk string scheduler_configuration

let mk_sizes =
  mk_list int "n" [200000000;400000000;600000000]

let values_of_keys_in_params params keys =
  ~~ List.map (Params.to_envs params) (fun e ->
      List.map (Env.get_as_string e) keys)

let mk_all f xs =
  let rec g xs =
    match xs with
    | [] -> failwith "error"
    | [x] -> f x
    | x::xs -> f x ++ g xs
  in
  g xs

let string_of_percentage_value v =
  let x = 100. *. v in
  let sx = sprintf "%.0f" x in
  sx

let string_of_percentage ?(show_plus=false) v =
   match classify_float v with
   | FP_subnormal | FP_zero | FP_normal ->
      sprintf "%s%s%s"
        (if v > 0. && show_plus then "+" else "")
        (string_of_percentage_value v) "%"
   | FP_infinite -> "$+\\infty$"
   | FP_nan -> "na"

let string_of_percentage_change ?(show_plus=false) vold vnew =
  string_of_percentage ~show_plus:show_plus (vnew /. vold -. 1.0)

let string_of_millions v =
   let x = v /. (1000. *. 1000.) in
     if x >= 10. then sprintf "%.0f" x
     else if x >= 1. then sprintf "%.1f" x
     else if x >= 0.1 then sprintf "%.2f" x
     else sprintf "%.3f" x 

let string_of_billions v =
   let x = v /. (1000. *. 1000. *. 1000.) in
     if x >= 10. then sprintf "%.0f" x
     else if x >= 1. then sprintf "%.1f" x
     else if x >= 0.1 then sprintf "%.2f" x
     else sprintf "%.3f" x 

let print_csv s =
  if arg_output_csv then
    Printf.printf "%s, " s
  else
    ()

let print_csv_newline () =
  if arg_output_csv then
    Printf.printf "\n"
  else
    ()

(*****************************************************************************)
(* Benchmark descriptions *)

let pretty_name = "!pretty_name" 
let mk_pretty_name = mk string pretty_name

let mk_n n =
    (mk int "n" n)
    & (mk_pretty_name (Printf.sprintf "$%s \\cdot 10^9$ items" (string_of_billions (float_of_int n))))

let mk_n2 n =
    (mk int "n" n)
    & (mk_pretty_name (Printf.sprintf "%d items" n))

let mk_infile f =
  mk string "infile" f

type benchmark_descr = {
    bd_problem : string;
    bd_mk_input : Params.t;
  }

let one_billion = 1000 * 1000 * 1000

let mk_spmv_input n =
  (mk string "matrixgen" n) & (mk_pretty_name n)

let mk_width=
  mk int "width"

let mk_height=
  mk int "height"

let mk_mandelbrot_input (w, h) =
  (mk_width w) &
    (mk_height h) &
      (mk_pretty_name (Printf.sprintf "%dx%d" w h))

let mk_kmeans_input n =
  (mk int "nb_objects" n)
  & (mk_pretty_name (Printf.sprintf "$%s \\cdot 10^6$ items" (string_of_millions (float_of_int n))))

let mk_floyd_warshall_input v =
  (mk int "vertices" v) &
    (mk_pretty_name (Printf.sprintf "%d x %d" v v))

(* WARNING: all inputs specified here must match the specifications in nautilus (benchmark.hpp) *)
let benchmarks : benchmark_descr list = [
    { bd_problem = "incr_array";
      bd_mk_input = mk_n one_billion; };
    { bd_problem = "plus_reduce_array";
      bd_mk_input = mk_n one_billion; };
    { bd_problem = "spmv";
      bd_mk_input = mk_spmv_input "bigrows"; };
    { bd_problem = "spmv";
      bd_mk_input = mk_spmv_input "bigcols"; };
    { bd_problem = "spmv";
      bd_mk_input = mk_spmv_input "arrowhead"; };
    { bd_problem = "mandelbrot";
      bd_mk_input = mk_mandelbrot_input (4192, 4192); };
    { bd_problem = "kmeans";
      bd_mk_input = mk_kmeans_input 1000000; };
    { bd_problem = "floyd_warshall";
      bd_mk_input = mk_floyd_warshall_input 1024; };
    { bd_problem = "knapsack";
      bd_mk_input = mk_n2 36; }; (*
    { bd_problem = "mergesort";
      bd_mk_input = mk_unit; }; *)

]

let benchmarks =
  if arg_benchmarks = [] then
    benchmarks
  else
    List.filter (fun b -> List.exists (fun a -> a = b.bd_problem) arg_benchmarks) benchmarks

let nb_benchmarks = List.length benchmarks

let mk_benchmark_descr bd =
    (mk string "benchmark" bd.bd_problem)
  & bd.bd_mk_input

let mk_nautilus_benchmark_descr bd =
    (mk_prog bd.bd_problem)
    & bd.bd_mk_input

(*****************************************************************************)
(* Common benchmark configuration *)

let mk_proc =
  mk int "proc" 

let mk_prog_heartbeat =
  mk_prog prog_heartbeat

let mk_serial_config =
  mk_scheduler_configuration "serial"

let mk_cilk_config =
  mk_scheduler_configuration "cilk"

let nopromote_interrupt = "nopromote_interrupt"

let mk_nopromote_interrupt_config =
  mk_scheduler_configuration nopromote_interrupt

let serial_interrupt_ping_thread = "serial_interrupt_ping_thread"
let serial_interrupt_papi = "serial_interrupt_papi"
let serial_interrupt_pthread = "serial_interrupt_pthread"

let serial_interrupts =
  [serial_interrupt_ping_thread;
   serial_interrupt_papi;
   (*serial_interrupt_pthread;*)]
   
let mk_serial_interrupt_configs =
  mk_list string scheduler_configuration serial_interrupts

let interrupt_ping_thread = "interrupt_ping_thread"
let interrupt_papi = "interrupt_papi"
let interrupt_pthread = "interrupt_pthread"

let interrupts =
  [interrupt_ping_thread;
   interrupt_papi;
   (*interrupt_pthread;*)]

let mk_interrupt_configs =
  mk_list string scheduler_configuration interrupts

let pretty_name_of_interrupt_config n =
  if n = interrupt_ping_thread then "INT-PingThread"
  else if n = interrupt_pthread then "INT-Pthread"
  else if n = interrupt_papi then "INT-Papi"
  else if n = serial_interrupt_ping_thread then "INT-PingThread"
  else if n = serial_interrupt_pthread then "INT-Pthread"
  else if n = serial_interrupt_papi then "INT-Papi"
  else if n = "nopromote_interrupt" then "INT-NP"
  else "<unknown>"

let is_only_serial s =
  (s = serial_interrupt_ping_thread || s = serial_interrupt_pthread || s = serial_interrupt_papi ||
   s = nopromote_interrupt)

let mk_runs_of_bd proc bd =
    mk_prog_heartbeat
  & (mk_benchmark_descr bd)
  & (mk_proc proc)

let mk_nautilus_runs_of_bd proc bd =
    (mk_prog bd.bd_problem)
  & (mk_proc proc)

let mk_serial_runs_of_bd bd =
   (mk_runs_of_bd 1 bd)
  & mk_serial_config

let mk_nautilus_serial_runs_of_bd bd =
   (mk_nautilus_runs_of_bd 1 bd)
  & mk_serial_config

let mk_nopromote_interrupt_runs_of_bd bd =
   (mk_runs_of_bd 1 bd)
  & mk_nopromote_interrupt_config

let mk_serial_interrupt_runs_of_bd bd =
   (mk_runs_of_bd 1 bd)
  & mk_serial_interrupt_configs

let mk_interrupt_runs_of_bd proc bd =
   (mk_runs_of_bd proc bd)
  & mk_interrupt_configs

let mk_cilk_runs_of_bd proc bd =
    mk_prog_heartbeat
  & (mk_benchmark_descr bd)
  & (mk_proc proc)
  & mk_cilk_config

let kappas_usec = arg_kappas_usec
                
let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let mk_ext = mk string "ext"

let mk_ext_sta = mk_ext "sta"
let mk_ext_opt = mk_ext "opt"

let report_elapsed (ec, et) =
  if arg_show_execcycles then
    Printf.sprintf "%.3f (%sm)" et (string_of_millions ec)
  else
    Printf.sprintf "%.3f" et

let report_percent_diff b r =
  string_of_percentage_change ~show_plus:true b r

let report_percent_diff_of_elapsed (bec,_) (ec,_) =
  let s = string_of_percentage_change ~show_plus:true bec ec in
  if arg_show_execcycles then
    Printf.sprintf "%s (%sm)" s (string_of_millions ec)
  else
    s

(*****************************************************************************)
(** Work-efficiency experiment *)

module ExpWorkEfficiency = struct

let name = "work_efficiency"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  (mk_all mk_serial_runs_of_bd benchmarks) ++
  (mk_all mk_nopromote_interrupt_runs_of_bd benchmarks) ++
  (mk_all (mk_cilk_runs_of_bd 1) benchmarks)

let run () =
  Mk_runs.(call (run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]))
  
let check = nothing  (* do something here *)
      
let plot () =
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let nb_cols = 2 in
  let results = Results.from_file (file_results name) in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|p{1cm}l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell add (Latex.tabular_multicol 2 "|l||" "Application/Input");
      Mk_table.cell ~escape:true ~last:false add "Serial (s)";
      Mk_table.cell ~escape:true ~last:true add "Heartbeat";
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          Mk_table.cell add (Latex.tabular_multicol 2 "|l||" (sprintf "\\textbf{%s}" (Latex.escape bd.bd_problem)));
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:true add "";
          add Latex.tabular_newline;
          let inputs = values_of_keys_in_params bd.bd_mk_input [pretty_name;] in
          ~~ List.iter inputs (fun [input] ->
            let get_time mk =
              let [col] = mk Env.empty in
              let results = Results.filter col results in
              (Results.get_mean_of "execcycles" results,
               Results.get_mean_of "exectime_via_cycles" results)
            in
            let serial_elapsed =
              get_time (mk_serial_runs_of_bd bd)
            in
            let heartbeat_elapsed =
              get_time (mk_nopromote_interrupt_runs_of_bd bd)
            in
            Mk_table.cell ~escape:true ~last:false add "";
            Mk_table.cell ~escape:true ~last:false add input;
            Mk_table.cell ~escape:true ~last:false add (report_elapsed serial_elapsed);
            Mk_table.cell ~escape:true ~last:true add (report_percent_diff_of_elapsed serial_elapsed heartbeat_elapsed);
            add Latex.tabular_newline));
      add Latex.tabular_end
    );
  ()

let all () = select make run check plot

end

(*****************************************************************************)
(** Linux work-efficiency experiment *)

module ExpLinuxWorkEfficiency = struct

let name = "linux_work_efficiency"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  ((mk_all mk_serial_interrupt_runs_of_bd benchmarks) ++
  (mk_all (mk_interrupt_runs_of_bd 1) benchmarks)) & mk_kappas_usec

let run () =
  Mk_runs.(call (run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]))
  
let check = nothing  (* do something here *)
      
let plot () =
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let results = Results.from_file (file_results name) in
  let results_work_efficiency = Results.from_file (file_results ExpWorkEfficiency.name) in
  let mk_scfgs = mk_list string scheduler_configuration (List.append serial_interrupts interrupts) in
  let scfgs = List.flatten (values_of_keys_in_params mk_scfgs [scheduler_configuration;]) in
  let (serial_scfgs, parallel_scfgs) = List.partition is_only_serial scfgs in
  let scfgs = List.flatten [parallel_scfgs; serial_scfgs;] in
  let nb_serial_scfgs = List.length serial_scfgs in
  let nb_parallel_scfgs = List.length parallel_scfgs in
  let nb_scfgs = List.length scfgs in
  let nb_kappas = List.length kappas_usec in
  let nb_cols = 1 + (nb_scfgs * nb_kappas) in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|p{1cm}l||c||c|%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "Binary";
      Mk_table.cell ~escape:true ~last:false add (Latex.tabular_multicol (nb_parallel_scfgs * nb_kappas) "c|" "Heartbeat");
      Mk_table.cell ~escape:true ~last:true add (Latex.tabular_multicol (nb_parallel_scfgs * nb_kappas) "c|" "Serial");
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let pretty_scfg = pretty_name_of_interrupt_config scfg in
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" pretty_scfg));
      add Latex.tabular_newline;
      Mk_table.cell add (Latex.tabular_multicol 2 "|l||" "Application/Input");
      Mk_table.cell ~escape:true ~last:false add "Serial (s)";
      Mk_table.cell ~escape:true ~last:false add "$H$";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          ~~ List.iteri kappas_usec (fun kappa_i kappa ->
              let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
              let pretty_kappa = Printf.sprintf "$%d\mu s$" kappa in
              Mk_table.cell ~escape:true ~last:last add (Printf.sprintf "%s" pretty_kappa)));
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          Mk_table.cell add (Latex.tabular_multicol 2 "|l||" (sprintf "\\textbf{%s}" (Latex.escape bd.bd_problem)));
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:false add "";
          ~~ List.iteri scfgs (fun scfg_i scfg ->
              ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                  let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
                  Mk_table.cell ~escape:true ~last:last add ""));
          add Latex.tabular_newline;
          ~~ List.iteri scfgs (fun scfg_i scfg ->
              ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                  let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
                  Mk_table.cell ~escape:true ~last:true add ""));
          let inputs = values_of_keys_in_params bd.bd_mk_input [pretty_name;] in
          ~~ List.iter inputs (fun [input] ->
              let get_time results mk =
                let [col] = mk Env.empty in
                let results = Results.filter col results in
                (Results.get_mean_of "execcycles" results,
                 Results.get_mean_of "exectime_via_cycles" results)
              in
              let serial_elapsed =
                get_time results_work_efficiency (mk_serial_runs_of_bd bd)
              in
              Mk_table.cell ~escape:true ~last:false add "";
              Mk_table.cell ~escape:true ~last:false add input;
              Mk_table.cell ~escape:true ~last:false add (report_elapsed serial_elapsed);
              Mk_table.cell ~escape:true ~last:false add "";
              ~~ List.iteri scfgs (fun scfg_i scfg ->
                  ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                      let mk_scfg = (mk string scheduler_configuration scfg) &
                                      (mk int "kappa_usec" kappa) in
                      let heartbeat_elapsed =
                        get_time results ((mk_runs_of_bd 1 bd) & mk_scfg)
                      in
                      let diff = report_percent_diff_of_elapsed serial_elapsed heartbeat_elapsed in
                      let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
                      Mk_table.cell ~escape:true ~last:last add diff));
            add Latex.tabular_newline));
      add Latex.tabular_end
    );
  ()

let all () = select make run check plot

end

(*****************************************************************************)
(** Linux parallel experiment *)

module ExpLinuxParallel = struct

let name = "linux_parallel"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  (mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_kappas_usec

let mk_runs_sta =
  (mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_ext_sta & mk_kappas_usec

let mk_runs_cilk =
  (mk_all (mk_cilk_runs_of_bd arg_proc) benchmarks)

let run () = (
  Mk_runs.(call (run_modes @ [
                 Output (file_results name);
                 Timeout arg_par_timeout;
                 Args mk_runs]));
  Mk_runs.(call (run_modes @ [
                 Output (file_results_sta name);
                 Timeout arg_par_timeout;
                 Args mk_runs_sta]));
  Mk_runs.(call (run_modes @ [
                 Output (file_results_cilk name);
                 Timeout arg_par_timeout;
                 Args mk_runs_cilk])))
  
let check = nothing  (* do something here *)
      
let plot () =
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let results = Results.from_file (file_results name) in
  let results_cilk = Results.from_file (file_results_cilk name) in
  let results_sta = Results.from_file (file_results_sta name) in
  let mk_scfgs = mk_list string scheduler_configuration interrupts in
  let scfgs = List.flatten (values_of_keys_in_params mk_scfgs [scheduler_configuration;]) in
  let nb_scfgs = List.length scfgs in
  let nb_cols = 1 + (3 * nb_scfgs) in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|p{1cm}l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell add (Latex.tabular_multicol 2 "|l||" "");
      Mk_table.cell ~escape:true ~last:false add "Cilk (s)";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let pretty_scfg = pretty_name_of_interrupt_config scfg in
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:false add pretty_scfg;
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol 2 "c|" (Printf.sprintf "%s / Cilk" pretty_scfg)));
      add Latex.tabular_newline;
      Mk_table.cell add (Latex.tabular_multicol 2 "|l||" "Application/Input");
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:false add "Idle time";
          Mk_table.cell ~escape:true ~last:last add "Nb. tasks");
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          Mk_table.cell add (Latex.tabular_multicol 2 "|l||" (sprintf "\\textbf{%s}" (Latex.escape bd.bd_problem)));
          Mk_table.cell ~escape:true ~last:false add "";
          ~~ List.iteri scfgs (fun scfg_i scfg ->
              let last = scfg_i+1 = nb_scfgs in
              Mk_table.cell ~escape:true ~last:false add "";
              Mk_table.cell ~escape:true ~last:false add "";
              Mk_table.cell ~escape:true ~last:last add "");
          add Latex.tabular_newline;
          let inputs = values_of_keys_in_params bd.bd_mk_input [pretty_name;] in
          ~~ List.iter inputs (fun [input] ->
            let get_time results mk =
              let [col] = mk Env.empty in
              let results = Results.filter col results in
              (Results.get_mean_of "execcycles" results,
               Results.get_mean_of "exectime_via_cycles" results)
            in
            let get_stats_heartbeat results mk =
              let [col] = mk Env.empty in
              let results = Results.filter col results in
              (Results.get_mean_of "total_idle_time" results,
               Results.get_mean_of "total_time" results,
               Results.get_mean_of "nb_promotions" results)
            in
            let get_stats_cilk results mk =
              let [col] = mk Env.empty in
              let results = Results.filter col results in
              (Results.get_mean_of "ticks_searching" results,
               Results.get_mean_of "utilization" results,
               Results.get_mean_of "nb_threads_alloc" results)
            in
            let mk_cilk_runs = mk_cilk_runs_of_bd arg_proc bd in
            let cilk_elapsed =
              get_time results_cilk mk_cilk_runs
            in
            let (cilk_ticks_idle, cilk_utilization, cilk_nb_tasks) =
              get_stats_cilk results_cilk mk_cilk_runs 
            in
            Mk_table.cell ~escape:true ~last:false add "";
            Mk_table.cell ~escape:true ~last:false add input;
            Mk_table.cell ~escape:true ~last:false add (report_elapsed cilk_elapsed);
            ~~ List.iteri scfgs (fun scfg_i scfg ->
                let mk_scfg = (mk string scheduler_configuration scfg) in
                let mk_heartbeat_runs = (mk_runs_of_bd arg_proc bd) & mk_scfg in
                let heartbeat_elapsed =
                  get_time results mk_heartbeat_runs
                in
                let (heartbeat_ticks_idle, heartbeat_total_time, heartbeat_nb_tasks) =
                  get_stats_heartbeat results_sta (mk_heartbeat_runs & mk_ext_sta)
                in
                let utilization_heartbeat = 1. -. (heartbeat_ticks_idle /. heartbeat_total_time) in
                let idle_heartbeat = (fst heartbeat_elapsed) *. utilization_heartbeat in
                let idle_cilk = (fst cilk_elapsed) *. cilk_utilization in
                let diff_exectime = report_percent_diff_of_elapsed cilk_elapsed heartbeat_elapsed in
                let diff_idle = report_percent_diff idle_cilk idle_heartbeat in
                let diff_nb_tasks = report_percent_diff cilk_nb_tasks heartbeat_nb_tasks in
                let last = scfg_i+1 = nb_scfgs in
                Mk_table.cell ~escape:true ~last:false add diff_exectime;
                Mk_table.cell ~escape:true ~last:false add diff_idle;
                Mk_table.cell ~escape:true ~last:last add diff_nb_tasks
              );
            add Latex.tabular_newline));
      add Latex.tabular_end
    );
  ()

let all () = select make run check plot

end

(*****************************************************************************)
(** Nautilus experiment *)

module ExpNautilus = struct

let name = "nautilus"

let name_serial = name ^ "_serial"
let name_parallel = name ^ "_heartbeat"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run () = ()
  
let check = nothing  (* do something here *)
      
let plot () =
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let nb_cols = 4 in
  let results_nautilus_serial = Results.from_file (file_results name_serial) in
  let results_nautilus_parallel = Results.from_file (file_results name_parallel) in
  let results_linux_serial = Results.from_file (file_results ExpWorkEfficiency.name) in
  let results_linux_parallel = Results.from_file (file_results ExpLinuxParallel.name) in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|p{1cm}l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell add (Latex.tabular_multicol 2 "|l|" "Application/Input");
      Mk_table.cell add (Latex.tabular_multicol 2 "|c|" "Serial");
      Mk_table.cell add ~escape:true ~last:true (Latex.tabular_multicol 2 "|c|" "Heartbeat");
      add Latex.tabular_newline;
      Mk_table.cell add (Latex.tabular_multicol 2 "|l||" "");
      Mk_table.cell ~escape:true ~last:false add "Nautilus (s)";
      Mk_table.cell ~escape:true ~last:false add "Linux";
      Mk_table.cell ~escape:true ~last:false add "Nautilus (s)";
      Mk_table.cell ~escape:true ~last:true add "Linux";
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          Mk_table.cell add (Latex.tabular_multicol 2 "|l||" (sprintf "\\textbf{%s}" (Latex.escape bd.bd_problem)));
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:true add "";
          add Latex.tabular_newline;
          let inputs = values_of_keys_in_params bd.bd_mk_input [pretty_name;] in
          ~~ List.iter inputs (fun [input] ->
            let get_time results mk =
              let [col] = mk Env.empty in
              let results = Results.filter col results in
              (Results.get_mean_of "execcycles" results,
               Results.get_mean_of "exectime_via_cycles" results)
            in
            let mk_scfg = (mk string scheduler_configuration interrupt_ping_thread) & (mk int "kappa_usec" 100) in
            let nautilus_serial_elapsed =
              get_time results_nautilus_serial (mk_nautilus_serial_runs_of_bd bd)
            in
            let nautilus_heartbeat_elapsed =
              get_time results_nautilus_parallel ((mk_nautilus_runs_of_bd arg_proc bd) & mk_scfg)
            in
            let linux_serial_elapsed =
              get_time results_linux_serial (mk_serial_runs_of_bd bd)
            in
            let linux_heartbeat_elapsed =
              get_time results_linux_parallel ((mk_runs_of_bd arg_proc bd) & mk_scfg)
            in
            Mk_table.cell ~escape:true ~last:false add "";
            Mk_table.cell ~escape:true ~last:false add input;
            Mk_table.cell ~escape:true ~last:false add (report_elapsed nautilus_serial_elapsed);
            Mk_table.cell ~escape:true ~last:false add (report_percent_diff_of_elapsed nautilus_serial_elapsed linux_serial_elapsed);
            Mk_table.cell ~escape:true ~last:false add (report_elapsed nautilus_heartbeat_elapsed);
            Mk_table.cell ~escape:true ~last:true add (report_percent_diff_of_elapsed nautilus_heartbeat_elapsed linux_heartbeat_elapsed);
            add Latex.tabular_newline));
      add Latex.tabular_end
    );
  ()

let all () = select make run check plot

end


(*****************************************************************************)
(** Main *)

let _ =
  let arg_actions = XCmd.get_others() in
  let bindings = [
      "work_efficiency", ExpWorkEfficiency.all;
      "linux_work_efficiency", ExpLinuxWorkEfficiency.all;
      "linux_parallel", ExpLinuxParallel.all;
      "nautilus", ExpNautilus.all;
  ]
  in
  Pbench.execute_from_only_skip arg_actions [] bindings;
  ()
