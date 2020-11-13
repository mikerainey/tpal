open XBase
open Params

let system = XSys.command_must_succeed_or_virtual

(*****************************************************************************)
(** Parameters *)

let arg_virtual_run = XCmd.mem_flag "virtual_run"
let arg_virtual_build = XCmd.mem_flag "virtual_build"
let arg_benchmarks = XCmd.parse_or_default_list_string "benchmarks" []
let arg_nb_runs = XCmd.parse_or_default_int "runs" 1
let arg_nb_seq_runs = XCmd.parse_or_default_int "seq_runs" 1
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
let arg_par_timeout = XCmd.parse_or_default_int "par_timeout" 420
let arg_seq_timeout = XCmd.parse_or_default_int "seq_timeout" 420
let arg_results_path = XCmd.parse_or_default_string "results_path" "."
let arg_show_execcycles = XCmd.mem_flag "show_execcycles"
let arg_skip_nautilus = XCmd.mem_flag "skip_nautilus"

let serial_interrupt_ping_thread = "serial_interrupt_ping_thread"
let serial_interrupt_papi = "serial_interrupt_papi"
let serial_interrupt_pthread = "serial_interrupt_pthread"

let serial_interrupts =
  [serial_interrupt_ping_thread;
   serial_interrupt_papi;
   serial_interrupt_pthread;]

let interrupt_ping_thread = "interrupt_ping_thread"
let interrupt_papi = "interrupt_papi"
let interrupt_pthread = "interrupt_pthread"

let interrupts =
  [interrupt_ping_thread;
   interrupt_papi;
   interrupt_pthread;]

let on_iit_or_nwu_machine =
  match Unix.gethostname () with
    "tinker-2.cs.iit.edu" -> true
  | "tinker-3.cs.iit.edu" -> true
  | "v-test-5038ki.cs.northwestern.edu" -> true
  | _ -> false

let arg_skip_interrupts =
  let dflt =
    if on_iit_or_nwu_machine then
      [interrupt_papi;interrupt_pthread;]
    else
      []
  in
  XCmd.parse_or_default_list_string "skip_interrupts" dflt

let arg_skip_serial_interrupts =
  let dflt =
    if on_iit_or_nwu_machine then
      [serial_interrupt_papi;serial_interrupt_pthread;]
    else
      []
  in
  XCmd.parse_or_default_list_string "skip_serial_interrupts" dflt

let filter_skips skips =
  List.filter (fun s -> not (List.mem s skips))

let interrupts =
  filter_skips arg_skip_interrupts interrupts

let serial_interrupts =
  filter_skips arg_skip_serial_interrupts serial_interrupts

let nautilus_interrupts =
  [interrupt_ping_thread;]

let nautilus_serial_interrupts =
  [serial_interrupt_ping_thread;]

let run_modes =
  Mk_runs.([
    Mode arg_mode;
    Virtual arg_virtual_run;
    Runs arg_nb_runs; ])

let seq_run_modes =
  Mk_runs.([
    Mode arg_mode;
    Virtual arg_virtual_run;
    Runs arg_nb_seq_runs; ])

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

let file_csv exp_name =
  Printf.sprintf "results_%s.csv" exp_name
  
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

let string_of_thousands v =
  let x = v /. 1000. in
  if x >= 10. then sprintf "%.0f" x
  else if x >= 1. then sprintf "%.1f" x
  else if x >= 0.1 then sprintf "%.2f" x
  else sprintf "%.3f" x 

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

type benchmark_descr = {
    bd_problem : string;
    bd_mk_input : Params.t;
  }

let mk_inputname =
  mk string "inputname"

let pretty_problemname_of bd =
  Latex.escape bd.bd_problem

let one_hundred_million_64bit_ints = "one_hundred_million_64bit_ints"
let bigrows = "bigrows"
let bigcols = "bigcols"
let arrowhead = "arrowhead"
let fourk_by_fourk = "fourk_by_fourk"
let one_million_objects = "one_million_objects"
let thirty_six_items = "thirty_six_items"
let uniformdist = "uniformdist"
let expdist = "expdist"
let onek_vertices = "onek_vertices"
let twok_vertices = "twok_vertices"
let fourk_items = "fourk_items"

let pretty_input_names = [
    one_hundred_million_64bit_ints, "$100 \cdot 10^6$ 64-bit doubles";
    bigrows, "random";
    bigcols, "exponential";
    arrowhead, "arrowhead";
    fourk_by_fourk, "4k by 4k pixels";
    one_million_objects, "$1 \cdot 10^6$ objects";
    onek_vertices, "1k vertices";
    twok_vertices, "2k vertices";
    thirty_six_items, "36 items";
    uniformdist, "$20 \cdot 10^6$ ints (uniform)";
    expdist, "$20 \cdot 10^6$ ints (exponential)";
    fourk_items, "4k items";
  ]

let inputname_of mk =
  List.hd (List.flatten (values_of_keys_in_params mk ["inputname";]))

let pretty_inputname_of bd =
  Latex.escape (List.assoc (inputname_of bd.bd_mk_input) pretty_input_names)

let benchmarks : benchmark_descr list = [
(*    { bd_problem = "incr_array";
      bd_mk_input = mk_inputname one_hundred_million_64bit_ints; }; *)
    { bd_problem = "plus_reduce_array";
      bd_mk_input = mk_inputname one_hundred_million_64bit_ints; };
    { bd_problem = "spmv";
      bd_mk_input = mk_inputname bigrows; };
    { bd_problem = "spmv";
      bd_mk_input = mk_inputname bigcols; };
    { bd_problem = "spmv";
      bd_mk_input = mk_inputname arrowhead; };
    { bd_problem = "mandelbrot";
      bd_mk_input = mk_inputname fourk_by_fourk; };
    { bd_problem = "kmeans";
      bd_mk_input = mk_inputname one_million_objects; };
    { bd_problem = "srad";
      bd_mk_input = mk_inputname fourk_items; };
    { bd_problem = "floyd_warshall";
      bd_mk_input = mk_inputname onek_vertices; };
    { bd_problem = "floyd_warshall";
      bd_mk_input = mk_inputname twok_vertices; };
    { bd_problem = "knapsack";
      bd_mk_input = mk_inputname thirty_six_items; };
    { bd_problem = "mergesort";
      bd_mk_input = mk_inputname uniformdist; }; 
    { bd_problem = "mergesort";
      bd_mk_input = mk_inputname expdist; }; 
  ]

let spmv_extra_benchmarks : benchmark_descr list = [
    { bd_problem = "spmv_outer";
      bd_mk_input = mk_inputname bigrows; };
    { bd_problem = "spmv_outer";
      bd_mk_input = mk_inputname bigcols; };
    { bd_problem = "spmv_outer";
      bd_mk_input = mk_inputname arrowhead; };
    { bd_problem = "spmv_red";
      bd_mk_input = mk_inputname bigrows; };
    { bd_problem = "spmv_red";
      bd_mk_input = mk_inputname bigcols; };
    { bd_problem = "spmv_red";
      bd_mk_input = mk_inputname arrowhead; };
  ]

let benchmarks =
  if arg_benchmarks = [] then
    benchmarks
  else
    List.filter (fun b -> List.exists (fun a -> a = b.bd_problem) arg_benchmarks) benchmarks

let nb_benchmarks = List.length benchmarks

(*****************************************************************************)
(* Common benchmark configuration *)

let pretty_name = "!pretty_name"

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
   
let mk_serial_interrupt_configs =
  mk_list string scheduler_configuration serial_interrupts

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

let mk_benchmark_descr bd =
    (mk string "benchmark" bd.bd_problem)
  & bd.bd_mk_input

let mk_runs_of_bd proc bd =
    mk_prog_heartbeat
  & (mk_benchmark_descr bd)
  & (mk_proc proc)

let mk_serial_runs_of_bd bd =
   (mk_runs_of_bd 1 bd)
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

let get_time results mk =
  let [col] = mk Env.empty in
  let results = Results.filter col results in
  (Results.get_mean_of "execcycles" results,
   Results.get_mean_of "exectime_via_cycles" results)

let get_stats_heartbeat results mk =
  let [col] = mk Env.empty in
  let results = Results.filter col results in
  (Results.get_mean_of "utilization" results,
   Results.get_mean_of "nb_promotions" results,
   Results.get_mean_of "nb_heartbeats" results)

let get_stats_nautilus results mk =
  let [col] = mk Env.empty in
  let results = Results.filter col results in
  let ticks_idle = Results.get_mean_of "total_idle_time" results in
  let total_time = Results.get_mean_of "total_time" results in
  let utilization = 1. -. (ticks_idle /. total_time) in
  (utilization,
   Results.get_mean_of "nb_promotions" results,
   Results.get_mean_of "nb_heartbeats" results)

let get_stats_cilk results mk =
  let [col] = mk Env.empty in
  let results = Results.filter col results in
  (Results.get_mean_of "utilization" results,
   Results.get_mean_of "nb_threads_alloc" results)

let build_csv csv_file body =
   let s = Buffer.create 1 in
   let add x = Buffer.add_string s x in
   body add;
   let csv = Buffer.contents s in
   XFile.put_contents csv_file csv;
   Pbench.info (sprintf "Produced file %s." csv_file)

let csv_cell ?(last=false) add s =
  add s;
  if not last then add ", "

let csv_newline = "\n"

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
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]))
  
let check = nothing  (* do something here *)
      
let plot () =
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let csv_file = file_csv name in
  let nb_cols = 2 in
  let results = Results.from_file (file_results name) in
  build_csv csv_file (fun add_csv ->
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "Serial (s)";
      Mk_table.cell ~escape:true ~last:true add "Heartbeat";
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          let benchdescr = Printf.sprintf "\vtop{\hbox{\strut %s}\hbox{\strut {\\tiny %s}}}"
                             (pretty_problemname_of bd) (pretty_inputname_of bd)
          in
          Mk_table.cell ~escape:true ~last:false add benchdescr;
          csv_cell add_csv (pretty_problemname_of bd);
          csv_cell add_csv (pretty_inputname_of bd);
            let serial_elapsed =
              get_time results (mk_serial_runs_of_bd bd)
            in
            let heartbeat_elapsed =
              get_time results (mk_nopromote_interrupt_runs_of_bd bd)
            in
            Mk_table.cell ~escape:true ~last:false add (report_elapsed serial_elapsed);
            csv_cell add_csv (report_elapsed serial_elapsed);
            Mk_table.cell ~escape:true ~last:true add (report_percent_diff_of_elapsed serial_elapsed heartbeat_elapsed);
            csv_cell add_csv ~last:true (report_elapsed heartbeat_elapsed);
            add Latex.tabular_newline;
            add_csv csv_newline;
        );
      add Latex.tabular_end
    ));
  ()

let all () = select make run check plot

end

(*****************************************************************************)
(** Work-efficiency with interrupts experiment *)

module ExpInterruptWorkEfficiency = struct

let name = "interrupt_work_efficiency"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  ((mk_all mk_serial_interrupt_runs_of_bd benchmarks) ++
     (mk_all (mk_interrupt_runs_of_bd 1) benchmarks)) & mk_kappas_usec

let mk_runs_sta =
  ((mk_all (mk_interrupt_runs_of_bd 1) benchmarks) & mk_ext_sta & mk_kappas_usec)

let run () = (
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]));
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results_sta name);
                 Timeout arg_seq_timeout;
                 Args mk_runs_sta])))
  
  
let check = nothing  (* do something here *)

let plot_for os results results_sta results_work_efficiency interrupts serial_interrupts mk_runs_of_bd =
  let name_out = name ^ "_" ^ os in
  let tex_file = file_tables_src name_out in
  let pdf_file = file_tables name_out in
  let csv_file = file_csv name_out in
  let mk_scfgs = mk_list string scheduler_configuration (List.append serial_interrupts interrupts) in
  let scfgs = List.flatten (values_of_keys_in_params mk_scfgs [scheduler_configuration;]) in
  let (serial_scfgs, parallel_scfgs) = List.partition is_only_serial scfgs in
  let scfgs = List.flatten [serial_scfgs; parallel_scfgs;] in
  let nb_serial_scfgs = List.length serial_scfgs in
  let nb_parallel_scfgs = List.length parallel_scfgs in
  let nb_scfgs = List.length scfgs in
  let nb_kappas = List.length kappas_usec in
  let nb_hb_cols = 3 in
  let nb_cols = (nb_serial_scfgs * nb_kappas) + (nb_parallel_scfgs * nb_kappas * nb_hb_cols)  in
  build_csv csv_file (fun add_csv ->
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l||c|%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add (Latex.tabular_multicol (nb_serial_scfgs * nb_kappas) "c|" "Serial");
      Mk_table.cell ~escape:true ~last:true add (Latex.tabular_multicol (nb_parallel_scfgs * nb_hb_cols * nb_kappas) "c|" "Heartbeat");
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let pretty_scfg = pretty_name_of_interrupt_config scfg in
          let n = nb_kappas * (if is_only_serial scfg then 1 else nb_hb_cols) in
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol n "c|" pretty_scfg));
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "Serial (s)";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          ~~ List.iteri kappas_usec (fun kappa_i kappa ->
              let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
              let n = if is_only_serial scfg then 1 else nb_hb_cols in
              let pretty_kappa = Printf.sprintf "$%d\mu s$" kappa in
              Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol n "c|" pretty_kappa)
            ));
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          ~~ List.iteri kappas_usec (fun kappa_i kappa ->
              let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
              if is_only_serial scfg then
                Mk_table.cell ~escape:true ~last:last add ""
              else (
                Mk_table.cell ~escape:true ~last:false add "";
                Mk_table.cell ~escape:true ~last:false add "Prom.";
                Mk_table.cell ~escape:true ~last:last add "Hb.")
            ));
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          let benchdescr = Printf.sprintf "\vtop{\hbox{\strut %s}\hbox{\strut {\\tiny %s}}}"
                             (pretty_problemname_of bd) (pretty_inputname_of bd)
          in
          Mk_table.cell ~escape:true ~last:false add benchdescr;
          csv_cell add_csv (pretty_problemname_of bd);
          csv_cell add_csv (pretty_inputname_of bd);
          ~~ List.iteri scfgs (fun scfg_i scfg ->
              ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                  let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
                  Mk_table.cell ~escape:true ~last:true add ""));
              let serial_elapsed =
                get_time results_work_efficiency (mk_serial_runs_of_bd bd)
              in              
              Mk_table.cell ~escape:true ~last:false add (report_elapsed serial_elapsed);
              csv_cell add_csv (report_elapsed serial_elapsed);
              ~~ List.iteri scfgs (fun scfg_i scfg ->
                  ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                      let mk_scfg = (mk string scheduler_configuration scfg) &
                                      (mk int "kappa_usec" kappa) in
                      let heartbeat_elapsed =
                        get_time results ((mk_runs_of_bd 1 bd) & mk_scfg)
                      in
                      let (_, heartbeat_sec_sta) =
                        get_time results_sta ((mk_runs_of_bd 1 bd) & mk_scfg)
                      in
                      let diff = report_percent_diff_of_elapsed serial_elapsed heartbeat_elapsed in
                      let last = scfg_i+1 = nb_scfgs && kappa_i+1 = nb_kappas in
                      if is_only_serial scfg then (
                        Mk_table.cell ~escape:true ~last:last add diff;
                        csv_cell add_csv (report_elapsed heartbeat_elapsed))
                      else
                        let (_, nb_promotions, nb_heartbeats) =
                          get_stats_nautilus results_sta ((mk_runs_of_bd 1 bd) & mk_scfg)
                        in
                        let nb_promotions_per_sec = nb_promotions /. heartbeat_sec_sta in
                        let nb_heartbeats_per_sec = nb_heartbeats /. heartbeat_sec_sta in
                        Mk_table.cell ~escape:true ~last:false add diff;
                        csv_cell add_csv (report_elapsed heartbeat_elapsed);
                        Mk_table.cell ~escape:true ~last:false add (Printf.sprintf "%sk/s" (string_of_thousands nb_promotions_per_sec));
                        csv_cell add_csv (Printf.sprintf "%f" nb_promotions_per_sec);
                        Mk_table.cell ~escape:true ~last:last add (Printf.sprintf "%sk/s" (string_of_thousands nb_heartbeats_per_sec));
                        csv_cell add_csv ~last:last (Printf.sprintf "%f"  nb_heartbeats_per_sec);
                    )
                );
              add Latex.tabular_newline;
              add_csv csv_newline;);
      add Latex.tabular_end
    ));
  ()

let plot_linux () =
  let _ = 
    let results = Results.from_file (file_results name) in
    let results_sta = Results.from_file (file_results_sta name) in
    let results_work_efficiency = Results.from_file (file_results ExpWorkEfficiency.name) in
    let serial_interrupts = [serial_interrupt_ping_thread] in
    let interrupts = [interrupt_ping_thread] in
    plot_for "linux_ping_thread" results results_sta results_work_efficiency interrupts serial_interrupts mk_runs_of_bd
  in
  let _ = 
    let results = Results.from_file (file_results name) in
    let results_sta = Results.from_file (file_results_sta name) in
    let results_work_efficiency = Results.from_file (file_results ExpWorkEfficiency.name) in
    let serial_interrupts = [serial_interrupt_pthread;serial_interrupt_papi] in
    let interrupts = [interrupt_pthread;interrupt_papi] in
    plot_for "linux_other" results results_sta results_work_efficiency interrupts serial_interrupts mk_runs_of_bd
  in
  ()

let plot_nautilus () =
  let _ =
    let name_nautilus = "nautilus_serial" in
    let results = Results.from_file (file_results name_nautilus) in
    let results_work_efficiency = Results.from_file (file_results name_nautilus) in
    plot_for "nautilus" results results results_work_efficiency nautilus_interrupts nautilus_serial_interrupts mk_runs_of_bd
  in
  ()


let all_linux () = select make run check plot_linux

let all_nautilus () = select make run check plot_nautilus

end

(*****************************************************************************)
(** Parallel Heartbeat experiment *)

module ExpParallelHeartbeat = struct

let name = "parallel_heartbeat"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  (mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_kappas_usec

let mk_runs_sta =
  ((mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_ext_sta & mk_kappas_usec)

let run () = (
  Mk_runs.(call (run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]));
  Mk_runs.(call (run_modes @ [
                 Output (file_results_sta name);
                 Timeout arg_par_timeout;
                 Args mk_runs_sta])))

  
let check = nothing  (* do something here *)

let plot_of os kappa_usec results results_serial results_sta interrupts = 
  let mk_kappa_usec = mk int "kappa_usec" kappa_usec in
  let name_out = Printf.sprintf "%s_%s_kappa_usec_%d" name os kappa_usec in
  let tex_file = file_tables_src name_out in
  let pdf_file = file_tables name_out in
  let csv_file = file_csv name_out in
  let mk_scfgs = mk_list string scheduler_configuration interrupts in
  let scfgs = List.flatten (values_of_keys_in_params mk_scfgs [scheduler_configuration;]) in
  let nb_scfgs = List.length scfgs in
  let nb_hb_cols = 4 in
  let nb_cols = 1 + (nb_hb_cols * nb_scfgs) in
  build_csv csv_file (fun add_csv ->
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "Serial (s)";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let pretty_scfg = pretty_name_of_interrupt_config scfg in
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_hb_cols "c|" pretty_scfg));
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:false add "Speedup";
          Mk_table.cell ~escape:true ~last:false add "Util.";
          Mk_table.cell ~escape:true ~last:false add "Prom.";
          Mk_table.cell ~escape:true ~last:last add "Hb.");
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          let benchdescr = Printf.sprintf "\vtop{\hbox{\strut %s}\hbox{\strut {\\tiny %s}}}"
                             (pretty_problemname_of bd) (pretty_inputname_of bd)
          in
          Mk_table.cell ~escape:true ~last:false add benchdescr;
          csv_cell add_csv (pretty_problemname_of bd);
          csv_cell add_csv (pretty_inputname_of bd);
          let serial_elapsed =
            get_time results_serial (mk_serial_runs_of_bd bd)
          in
          let (serial_cyc, serial_sec) = serial_elapsed in
          Mk_table.cell ~escape:true ~last:false add (report_elapsed serial_elapsed);
          csv_cell add_csv (report_elapsed serial_elapsed);
          ~~ List.iteri scfgs (fun scfg_i scfg ->
              let mk_scfg = (mk string scheduler_configuration scfg) in
              let mk_heartbeat_runs = (mk_runs_of_bd arg_proc bd) & mk_scfg & mk_kappa_usec in
              let (heartbeat_cyc, heartbeat_sec) as heartbeat_elapsed =
                get_time results mk_heartbeat_runs
              in
              let (heartbeat_utilization, heartbeat_nb_tasks, heartbeat_nb_heartbeats) =
                get_stats_nautilus results_sta mk_heartbeat_runs
              in
              let (_, heartbeat_sec_sta) =
                get_time results_sta mk_heartbeat_runs
              in
              let speedup = serial_cyc /. heartbeat_cyc in
              let nb_prom_per_sec = heartbeat_nb_tasks /. heartbeat_sec_sta in
              let nb_heartbeat_per_sec = heartbeat_nb_heartbeats /. heartbeat_sec_sta in
              let last = scfg_i+1 = nb_scfgs in
              Mk_table.cell ~escape:true ~last:false add (Printf.sprintf "%.2fx" speedup);
              csv_cell add_csv (report_elapsed heartbeat_elapsed);
              Mk_table.cell ~escape:true ~last:false add (Printf.sprintf "%.0f%%" (100. *. heartbeat_utilization));
              csv_cell add_csv (Printf.sprintf "%f" heartbeat_utilization);
              Mk_table.cell ~escape:true ~last:false add (Printf.sprintf "%sk/s" (string_of_thousands nb_prom_per_sec));
              csv_cell add_csv (Printf.sprintf "%f" nb_prom_per_sec);             
              Mk_table.cell ~escape:true ~last:last add (Printf.sprintf "%sk/s" (string_of_thousands nb_heartbeat_per_sec));
              csv_cell add_csv ~last:last (Printf.sprintf "%f" nb_heartbeat_per_sec);
            );
          add Latex.tabular_newline;
          add_csv csv_newline;);
      add Latex.tabular_end
    ));
  ()

let plot_linux () =
  let _ = 
    let results = Results.from_file (file_results name) in
    let results_sta = Results.from_file (file_results_sta name) in
    let results_serial = Results.from_file (file_results ExpWorkEfficiency.name) in
    let interrupts = [interrupt_ping_thread] in
    ~~ List.iter arg_kappas_usec (fun kappa_usec -> plot_of "linux_ping_thread" kappa_usec results results_serial results_sta interrupts)
  in
  let _ = 
    let results = Results.from_file (file_results name) in
    let results_sta = Results.from_file (file_results_sta name) in
    let results_serial = Results.from_file (file_results ExpWorkEfficiency.name) in
    let interrupts = [interrupt_papi;interrupt_pthread] in
    ~~ List.iter arg_kappas_usec (fun kappa_usec -> plot_of "linux_other" kappa_usec results results_serial results_sta interrupts)
  in
  ()  

let all_linux () = select make run check plot_linux

let plot_nautilus () =
  let name_nautilus_serial = "nautilus_serial" in
  let name_nautilus_parallel = "nautilus_parallel" in
  let results_serial = Results.from_file (file_results name_nautilus_serial) in
  let results = Results.from_file (file_results name_nautilus_parallel) in
  let interrupts = [interrupt_ping_thread] in
  ~~ List.iter arg_kappas_usec (fun kappa_usec -> plot_of "nautilus" kappa_usec results results_serial results interrupts)

let all_nautilus () = select make run check plot_nautilus

end

(*****************************************************************************)
(** Linux vs Cilk experiment *)

module ExpLinuxVsCilk = struct

let name = "linux_vs_cilk"
let name_seq = name ^ "_seq"

let benchmarks = List.append benchmarks spmv_extra_benchmarks

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let mk_runs =
  (mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_kappas_usec

let mk_runs_sta =
  ((mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_ext_sta & mk_kappas_usec)

let mk_runs_cilk =
  (mk_all (mk_cilk_runs_of_bd arg_proc) benchmarks)

let mk_seq_runs =
  (mk_all (mk_interrupt_runs_of_bd 1) benchmarks) & mk_kappas_usec

let mk_seq_runs_sta =
  (mk_all (mk_interrupt_runs_of_bd 1) benchmarks) & mk_ext_sta & mk_kappas_usec

let mk_seq_runs_cilk =
  (mk_all (mk_cilk_runs_of_bd 1) benchmarks)

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
                 Args mk_runs_cilk]));
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results name_seq);
                 Timeout arg_seq_timeout;
                 Args mk_seq_runs]));
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results_sta name_seq);
                 Timeout arg_seq_timeout;
                 Args mk_seq_runs_sta]));
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results_cilk name_seq);
                 Timeout arg_seq_timeout;
                 Args mk_seq_runs_cilk]))
  )
  
let check = nothing  (* do something here *)

let interrupts =
  [interrupt_ping_thread;]

let serial_interrupts =
  [serial_interrupt_ping_thread;]
      
let plot_of proc results results_cilk results_sta kappa_usec =
  let mk_kappa_usec = mk int "kappa_usec" kappa_usec in
  let name_out = Printf.sprintf "%s_proc_%d_kappa_usec_%d" name proc kappa_usec in
  let tex_file = file_tables_src name_out in
  let pdf_file = file_tables name_out in
  let csv_file = file_csv name_out in
  let mk_scfgs = mk_list string scheduler_configuration interrupts in
  let scfgs = List.flatten (values_of_keys_in_params mk_scfgs [scheduler_configuration;]) in
  let nb_scfgs = List.length scfgs in
  let nb_cols = 1 + (3 * nb_scfgs) in
  build_csv csv_file (fun add_csv ->
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l||%s|" ls
      in
      add (Latex.tabular_begin hdr);
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "Cilk (s)";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let pretty_scfg = pretty_name_of_interrupt_config scfg in
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol 3 "c|" pretty_scfg));
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "";
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri scfgs (fun scfg_i scfg ->
          let last = scfg_i+1 = nb_scfgs in
          Mk_table.cell ~escape:true ~last:false add "";
          Mk_table.cell ~escape:true ~last:false add "Util.";
          Mk_table.cell ~escape:true ~last:last add "Prom.");
      add Latex.tabular_newline;
      ~~ List.iter benchmarks (fun bd ->
          let benchdescr = Printf.sprintf "\vtop{\hbox{\strut %s}\hbox{\strut {\\tiny %s}}}"
                             (pretty_problemname_of bd) (pretty_inputname_of bd)
          in
          Mk_table.cell ~escape:true ~last:false add benchdescr;
          csv_cell add_csv (pretty_problemname_of bd);
          csv_cell add_csv (pretty_inputname_of bd);
          let mk_cilk_runs = mk_cilk_runs_of_bd proc bd in
            let cilk_elapsed =
              get_time results_cilk mk_cilk_runs
            in
            let (cilk_utilization, cilk_nb_tasks) =
              get_stats_cilk results_cilk mk_cilk_runs 
            in
            Mk_table.cell ~escape:true ~last:false add (report_elapsed cilk_elapsed);
            csv_cell add_csv (report_elapsed cilk_elapsed);
            ~~ List.iteri scfgs (fun scfg_i scfg ->
                let mk_scfg = (mk string scheduler_configuration scfg) in
                let mk_heartbeat_runs = (mk_runs_of_bd proc bd) & mk_scfg & mk_kappa_usec in
                let heartbeat_elapsed =
                  get_time results mk_heartbeat_runs
                in
                let (heartbeat_utilization, heartbeat_nb_tasks, heartbeat_nb_heartbeats) =
                  get_stats_heartbeat results_sta (mk_heartbeat_runs & mk_ext_sta)
                in
                let idle_heartbeat = (fst heartbeat_elapsed) *. heartbeat_utilization in
                let idle_cilk = (fst cilk_elapsed) *. cilk_utilization in
                let diff_exectime = report_percent_diff_of_elapsed cilk_elapsed heartbeat_elapsed in
                let diff_idle = report_percent_diff idle_cilk idle_heartbeat in
                let diff_nb_tasks = report_percent_diff cilk_nb_tasks heartbeat_nb_tasks in
                let last = scfg_i+1 = nb_scfgs in
                Mk_table.cell ~escape:true ~last:false add diff_exectime;
                csv_cell add_csv (report_elapsed heartbeat_elapsed);
                Mk_table.cell ~escape:true ~last:false add diff_idle;
                csv_cell add_csv (Printf.sprintf "%f" cilk_utilization);
                csv_cell add_csv (Printf.sprintf "%f" heartbeat_utilization);
                Mk_table.cell ~escape:true ~last:last add diff_nb_tasks;
                csv_cell add_csv (Printf.sprintf "%f" cilk_nb_tasks);
                csv_cell add_csv ~last:last (Printf.sprintf "%f" heartbeat_nb_tasks);
              );
            add Latex.tabular_newline;
            add_csv csv_newline;);
      add Latex.tabular_end
    ));
  ()

let plot () =
  let results = Results.from_file (file_results name) in
  let results_cilk = Results.from_file (file_results_cilk name) in
  let results_sta = Results.from_file (file_results_sta name) in
  let _ = ~~ List.iter arg_kappas_usec (plot_of arg_proc results results_cilk results_sta) in
  let results_seq = Results.from_file (file_results name_seq) in
  let results_cilk_seq = Results.from_file (file_results_cilk name_seq) in
  let results_sta_seq = Results.from_file (file_results_sta name_seq) in
  let _ = ~~ List.iter arg_kappas_usec (plot_of 1 results_seq results_cilk_seq results_sta_seq) in
  ()


let all () = select make run check plot

end

(*****************************************************************************)
(** Work-efficiency experiment *)

module ExpVaryKappa = struct

let name = "vary_kappa"

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let kappas_usec = [20;40;60;80;100;]
                
let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let mk_runs =
  (mk_all (mk_interrupt_runs_of_bd arg_proc) benchmarks) & mk_kappas_usec

let run () =
  Mk_runs.(call (seq_run_modes @ [
                 Output (file_results name);
                 Timeout arg_seq_timeout;
                 Args mk_runs]))
  
let check = nothing  (* do something here *)

let formatter = (* used to beautify the name of the series *)
     Env.format (Env.(
       [ ("prog", Format_hidden);
         ("benchmark", Format_custom (fun s -> s));
         ("inputname", Format_custom (fun s -> s));
         ("proc", Format_hidden);
       ]))

let plot () =
  Mk_bar_plot.(call ([
      Bar_plot_opt Bar_plot.([
         X_titles_dir Vertical;
         Y_axis [Axis.Lower (Some 0.)] ]);
      Formatter formatter;
      Charts mk_unit;
      Series mk_kappas_usec;
      X (mk_all (mk_runs_of_bd arg_proc) benchmarks);
      Input (file_results name);
      Output (file_plots name);
      Y_label "exectime";
      Y eval_exectime;
  ]))

let all () = select make run check plot

end

(*****************************************************************************)
(** Main *)

let _ =
  let arg_actions = XCmd.get_others() in
  let bindings = [
      "work_efficiency", ExpWorkEfficiency.all;
      "linux_work_efficiency", ExpInterruptWorkEfficiency.all_linux;
      "nautilus_work_efficiency", ExpInterruptWorkEfficiency.all_nautilus;
      "linux_vs_cilk", ExpLinuxVsCilk.all;
      "linux_parallel_heartbeat", ExpParallelHeartbeat.all_linux;
      "nautilus_parallel_heartbeat", ExpParallelHeartbeat.all_nautilus;
      "vary_kappa", ExpVaryKappa.all;
  ]
  in
  Pbench.execute_from_only_skip arg_actions [] bindings;
  ()
