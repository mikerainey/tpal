open XBase
open Params

let system = XSys.command_must_succeed_or_virtual

(*****************************************************************************)
(** Parameters *)

let arg_virtual_run = XCmd.mem_flag "virtual_run"
let arg_virtual_build = XCmd.mem_flag "virtual_build"
let arg_problems = XCmd.parse_or_default_list_string "problems" []
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
let arg_par_timeout = XCmd.parse_or_default_int "par_timeout" 120
let arg_seq_timeout = XCmd.parse_or_default_int "seq_timeout" 120
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
   let x = v /. 1000000. in
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
  & (mk_pretty_name (Printf.sprintf "$%s \\cdot 10^6$ items" (string_of_millions (float_of_int n))))

let mk_infile f =
  mk string "infile" f

type benchmark_descr = {
    bd_problem : string;
    bd_mk_input : Params.t;
  }

let mk_spmv_input =
  mk string "matrixgen"

let mk_spmv_inputs =
  (mk_spmv_input "bigrows" ++
   mk_spmv_input "bigcols" ++
   mk_spmv_input "arrowhead")

let benchmarks : benchmark_descr list = [
    { bd_problem = "incr_array";
      bd_mk_input = mk_unit; };
    { bd_problem = "plus_reduce_array";
      bd_mk_input = mk_unit };
    { bd_problem = "spmv";
      bd_mk_input = mk_spmv_inputs; };
    { bd_problem = "mandelbrot";
      bd_mk_input = mk_unit; };
    { bd_problem = "kmeans";
      bd_mk_input = mk_unit; };
    { bd_problem = "floyd_warshall";
      bd_mk_input = mk_unit; };
    { bd_problem = "knapsack";
      bd_mk_input = mk_unit; }; 
    { bd_problem = "mergesort";
      bd_mk_input = mk_unit; };

]

let benchmarks =
  if arg_problems = [] then
    benchmarks
  else
    List.filter (fun b -> List.exists (fun a -> a = b.bd_problem) arg_problems) benchmarks

let mk_benchmark_descr bd =
    (mk string "benchmark" bd.bd_problem)
  & bd.bd_mk_input

let mk_nautilus_benchmark_descr bd =
    (mk_prog bd.bd_problem)
  & bd.bd_mk_input

(*****************************************************************************)
(** Feasibility experiment *)

module ExpFeasibility = struct

let name_of bd = "feasibility_" ^ bd.bd_problem
         
let kappas_usec = arg_kappas_usec
                
let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let mk_hardware_interrupt_config_of hwi kappa =
  mk_scheduler_configuration hwi & mk int "kappa_usec" kappa

let interrupt_ping_thread = "interrupt_ping_thread"
let interrupt_pthread = "interrupt_pthread"
let interrupt_papi = "interrupt_papi"

let serial_interrupt_ping_thread = "serial_interrupt_ping_thread"
let serial_interrupt_pthread = "serial_interrupt_pthread"
let serial_interrupt_papi = "serial_interrupt_papi"

let nopromote_interrupt = "nopromote_interrupt"

let is_nautilus_scheduler_configuration s =
  (s = interrupt_ping_thread || s = serial_interrupt_ping_thread)

let is_only_serial s =
  (s = serial_interrupt_ping_thread || s = serial_interrupt_pthread || s = serial_interrupt_papi ||
   s = nopromote_interrupt)

let mk_hardware_interrupt_configs =
      (mk_scheduler_configuration interrupt_ping_thread)
      (*   ++ (mk_scheduler_configuration interrupt_pthread)*)
   ++ (mk_scheduler_configuration interrupt_papi)
   ++ (mk_scheduler_configuration serial_interrupt_ping_thread)
      (*   ++ (mk_scheduler_configuration serial_interrupt_pthread)*)
   ++ (mk_scheduler_configuration serial_interrupt_papi)
   ++ (mk_scheduler_configuration nopromote_interrupt)

let pretty_name_of_interrupt_config n =
  if n = interrupt_ping_thread then "INT-PingThread"
  else if n = interrupt_pthread then "INT-Pthread"
  else if n = interrupt_papi then "INT-Papi"
  else if n = serial_interrupt_ping_thread then "INT-PingThread-SI"
  else if n = serial_interrupt_pthread then "INT-Pthread-SI"
  else if n = serial_interrupt_papi then "INT-Papi-SI"
  else if n = nopromote_interrupt then "INT-NP"
  else "<unknown>"
    
let mk_heartbeat_configs = 
    mk_hardware_interrupt_configs & mk_kappas_usec

let mk_baseline_config =
  mk_scheduler_configuration "serial"

let procs = [1;arg_proc;]
          
let mk_proc = mk_list int "proc" procs
            
let mk_size = mk int "n" arg_dflt_size
  
let mk_prog_homegrown = mk_prog prog_heartbeat

let mk_nautilus_baseline_runs bd =
  mk_baseline_config
  & (mk_nautilus_benchmark_descr bd)
  
let mk_baseline_runs bd =
  mk_prog_homegrown
  & mk_baseline_config
  & (mk_benchmark_descr bd)

let mk_manual_runs_of bd proc =
    mk_prog_homegrown
  & mk int "proc" proc
  & mk_scheduler_configuration "manual"
  & (mk_benchmark_descr bd)  

let mk_manual_runs bd =
  mk_all (mk_manual_runs_of bd) procs

let mk_heartbeat_runs_of bd mk_configs proc =
    mk_prog_homegrown
  & mk int "proc" proc
  & mk_configs
  & (mk_benchmark_descr bd)

let mk_nautilus_heartbeat_runs_of bd mk_configs proc =
  mk int "proc" proc
  & mk_configs
  & (mk_nautilus_benchmark_descr bd)

let mk_heartbeat_runs bd =
  mk_all (mk_heartbeat_runs_of bd mk_heartbeat_configs) procs
                      
let mk_cilk_config = mk_scheduler_configuration "cilk"
 
let mk_cilk_runs_of bd proc =
    mk_prog prog_cilk
  & mk int "proc" proc
  & mk_cilk_config
  & (mk_benchmark_descr bd)

let mk_cilk_runs bd =
  mk_all (mk_cilk_runs_of bd) procs

let mk_par_baseline_runs =
  if arg_par_baseline = "cilk" then
    mk_cilk_runs
  else
    mk_manual_runs

let name_linux = "Linux"
let name_nautilus = "Nautilus"

let name_heartbeat bd = (name_of bd) ^ "_heartbeat"
let name_nautilus_baseline = "nautilus_baseline"
let name_nautilus_heartbeat = "nautilus_heartbeat"
let name_manual bd = (name_of bd) ^ "_manual"
let name_baseline bd = (name_of bd) ^ "_baseline"
let name_cilk bd = (name_of bd) ^ "_cilk"
let name_par_baseline bd = (name_of bd) ^ "_" ^ arg_par_baseline

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run_for bd = (
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_heartbeat bd));
    Timeout arg_par_timeout;
    Args (mk_heartbeat_runs bd)]));
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_par_baseline bd));
    Timeout arg_seq_timeout;
    Args (mk_par_baseline_runs bd)]));
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_baseline bd));
    Timeout arg_seq_timeout;
    Args (mk_baseline_runs bd)])))

let run() = ~~ List.iter benchmarks run_for
  
let check = nothing  (* do something here *)

(* later: support plotting for benchmarks with multiple inputs *)
let plot_for bd =
  let tex_file = file_tables_src (name_of bd) in
  let pdf_file = file_tables (name_of bd) in
  let nb_procs = List.length procs in
  let nb_kappas = List.length kappas_usec in
  let nb_cols = nb_procs * nb_kappas in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l|%s|" ls
      in
      add (Latex.tabular_begin hdr);
      (* Proc header *)
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri procs (fun proc_i proc ->
          let last = proc_i+1 = nb_procs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" (Printf.sprintf "$P=%d$" proc))
        );
      add Latex.tabular_newline;

      let get_time file_results_name mk_bench =
        let f = (file_results file_results_name) in
        let results = Results.from_file f in
        let [col] = mk_bench Env.empty in
        let results = Results.filter col results in
        (Results.get_mean_of "execcycles" results,
         Results.get_mean_of "exectime_via_cycles" results)
      in
      let (baseline_execcycles, baseline_exectime) =
        get_time (name_baseline bd) (mk_baseline_runs bd)
      in
      let cilk_execcycles_of proc =
        get_time (name_cilk bd) (mk_cilk_runs_of bd proc)
      in
      let manual_execcycles_of proc =
        get_time (name_manual bd) (mk_manual_runs_of bd proc)
      in
      let par_baseline_execcycles_of =
        if arg_par_baseline = "cilk" then
          cilk_execcycles_of
        else
          manual_execcycles_of
      in
      let heartbeat_execcycles_of mk_config proc =
        let (t, _) = get_time (name_heartbeat bd) (mk_heartbeat_runs_of bd mk_config proc)
        in t
      in

      let (nautilus_baseline_execcycles, nautilus_baseline_exectime) =
        if arg_skip_nautilus then (0., 0.) else
        get_time name_nautilus_baseline (mk_nautilus_baseline_runs bd)
      in
      let nautilus_heartbeat_execcycles_of mk_config proc =
        let (t, _) = get_time name_nautilus_heartbeat (mk_nautilus_heartbeat_runs_of bd mk_config proc)
        in t
      in

      let report_elapsed (ec, et) =
        if arg_show_execcycles then
          Printf.sprintf "%.3f (%sm)" et (string_of_millions ec)
        else
          Printf.sprintf "%.3f" et
      in

      let report_percent_diff bec ec =
        let s = string_of_percentage_change ~show_plus:true bec ec in
        if arg_show_execcycles then
          Printf.sprintf "%s (%sm)" s (string_of_millions ec)
        else
          s
      in

      Mk_table.cell ~escape:true ~last:false add "Linux baseline (s)";
      ~~ List.iteri procs (fun proc_i proc ->
          let s = report_elapsed (if proc = 1 then
                                    (baseline_execcycles, baseline_exectime)
                                  else
                                    (par_baseline_execcycles_of proc))
          in
          let last = proc_i+1 = nb_procs in
          print_csv s;
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" s));
      (* Header *)
      print_csv_newline();
      add Latex.tabular_newline;
      print_csv " ";

      if not (arg_skip_nautilus) then (
        Mk_table.cell ~escape:true ~last:false add "Nautilus baseline (s)";
        ~~ List.iteri procs (fun proc_i proc ->
            let s = (if proc = 1 then
                       report_elapsed (nautilus_baseline_execcycles, nautilus_baseline_exectime)
                     else
                       "na")
            in
            let last = proc_i+1 = nb_procs in
            print_csv s;
            Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" s));
        print_csv_newline();
        add Latex.tabular_newline;
        print_csv " ")
      else ();
      
      Mk_table.cell ~escape:true ~last:false add "Heartbeat rate $H$";
      ~~ List.iteri procs (fun proc_i proc ->
          ~~ List.iteri kappas_usec (fun kappa_i kappa ->
              let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
              let s = Printf.sprintf "$%d\mu s$" kappa in
              print_csv (Printf.sprintf "%d" kappa);
              Mk_table.cell ~escape:true ~last:last add s
        ));
      add Latex.tabular_newline;
      let mk_par os =
        let hwis = values_of_keys_in_params mk_hardware_interrupt_configs [scheduler_configuration;] in
        ~~ List.iteri hwis (fun hwi_i [hwi] ->
            if os = name_nautilus && not (is_nautilus_scheduler_configuration hwi) then
              ()
            else
              let hwi_pretty = os ^ " "^ pretty_name_of_interrupt_config hwi in
              print_csv hwi_pretty;
              Mk_table.cell ~escape:true ~last:false add hwi_pretty;
              ~~ List.iteri procs (fun proc_i proc ->
                  ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                      if proc != 1 && is_only_serial hwi then
                        let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
                        Mk_table.cell ~escape:true ~last:last add "na"
                      else
                        let (par_baseline_execcycles, _) = par_baseline_execcycles_of proc in
                        let heartbeat_execcycles =
                          let mk_config = mk_hardware_interrupt_config_of hwi kappa in
                          if os = name_linux then
                            heartbeat_execcycles_of mk_config proc
                          else
                            nautilus_heartbeat_execcycles_of mk_config proc
                        in
                        let baseline_execcycles = if os = name_linux then baseline_execcycles else nautilus_baseline_execcycles in
                        let b = if proc = 1 then baseline_execcycles else par_baseline_execcycles in
                        let chg = report_percent_diff b heartbeat_execcycles in
                        (*                        let chg = string_of_percentage_change ~show_plus:true b heartbeat_execcycles in*)
                        let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
                        print_csv (Printf.sprintf "%f" heartbeat_execcycles);
                        Mk_table.cell ~escape:true ~last:last add chg
                ));
        print_csv_newline ();
        add Latex.tabular_newline)
      in
      mk_par name_linux;
      if not (arg_skip_nautilus) then 
        mk_par name_nautilus
      else ();
      add Latex.tabular_end;)
      
let plot () = ~~ List.iter benchmarks plot_for

let all () = select make run check plot

end

(*****************************************************************************)
(** Stats experiment *)

module ExpStats = struct

module EF = ExpFeasibility

let name_of bd = "stats_" ^ bd.bd_problem
         
let pretty_name_of_interrupt_config = EF.pretty_name_of_interrupt_config
  
let mk_heartbeat_configs = EF.mk_heartbeat_configs

let procs = EF.procs
          
let mk_prog_homegrown = EF.mk_prog_homegrown

let mk_ext e = mk string "ext" e

let mk_ext_sta = mk_ext "sta"
  
let mk_manual_runs_of bd proc =
    mk_prog_homegrown
  & mk int "proc" proc
  & mk_scheduler_configuration "manual"
  & (mk_benchmark_descr bd)
  & mk_ext_sta

let mk_manual_runs bd =
  mk_all (mk_manual_runs_of bd) procs

let mk_heartbeat_runs_of bd mk_configs proc =
    mk_prog_homegrown
  & mk int "proc" proc
  & mk_configs
  & (mk_benchmark_descr bd)
  & mk_ext_sta

let mk_heartbeat_runs bd =
  mk_all (mk_heartbeat_runs_of bd mk_heartbeat_configs) procs
                      
let mk_par_baseline_runs =
    mk_manual_runs

let name_heartbeat bd = (name_of bd) ^ "_heartbeat"
let name_manual bd = (name_of bd) ^ "_manual"
let name_par_baseline = name_manual

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run_for bd = (
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_heartbeat bd));
    Timeout arg_par_timeout;
    Args (mk_heartbeat_runs bd)]));
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_par_baseline bd));
    Timeout arg_seq_timeout;
    Args (mk_par_baseline_runs bd)])))

let run() = ~~ List.iter benchmarks run_for
  
let check = nothing  (* do something here *)

let plot_for stat bd =
  let name = (name_of bd) ^ "_" ^ stat in
  let tex_file = file_tables_src name in
  let pdf_file = file_tables name in
  let nb_procs = List.length procs in
  let nb_kappas = List.length EF.kappas_usec in
  let nb_cols = nb_procs * nb_kappas in
  Mk_table.build_table tex_file pdf_file (fun add ->
      let hdr =
        let ls = String.concat "|" (XList.init nb_cols (fun _ -> "c")) in
        Printf.sprintf "|l|%s|" ls
      in
      add (Latex.tabular_begin hdr);
      (* Proc header *)
      Mk_table.cell ~escape:true ~last:false add "";
      ~~ List.iteri procs (fun proc_i proc ->
          let last = proc_i+1 = nb_procs in
          Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" (Printf.sprintf "$P=%d$" proc))
        );
      add Latex.tabular_newline;
      let manual_stat_of proc =
        if arg_elide_baseline then
          0.0
        else
          let results = Results.from_file (file_results (name_manual bd)) in
          let [col] = (mk_manual_runs_of bd proc) Env.empty in
          let results = Results.filter col results in
          Results.get_mean_of stat results
      in
      let par_baseline_stat_of = manual_stat_of
      in
      let heartbeat_stat_of mk_config proc =
        let results = Results.from_file (file_results (name_heartbeat bd)) in
        let [col] = (mk_heartbeat_runs_of bd mk_config proc) Env.empty in
        let results = Results.filter col results in
        Results.get_mean_of stat results
      in
      Mk_table.cell ~escape:true ~last:false add "baseline (s)";
      ~~ List.iteri procs (fun proc_i proc ->
            let par_baseline_stat = par_baseline_stat_of proc in
            let b = par_baseline_stat in
            let last = proc_i+1 = nb_procs in
            Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" (Printf.sprintf "%.3f" b)));
      (* Header *)
      add Latex.tabular_newline;
      print_csv " ";
      Mk_table.cell ~escape:true ~last:false add "$H$";
      ~~ List.iteri procs (fun proc_i proc ->
          ~~ List.iteri EF.kappas_usec (fun kappa_i kappa ->
              let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
              let s = Printf.sprintf "$%d\mu s$" kappa in
              print_csv (Printf.sprintf "%d" kappa);
              Mk_table.cell ~escape:true ~last:last add s
          ));
      print_csv_newline();
      add Latex.tabular_newline;
      let hwis = values_of_keys_in_params EF.mk_hardware_interrupt_configs [scheduler_configuration;] in
      ~~ List.iteri hwis (fun hwi_i [hwi] ->
          let hwi_pretty = pretty_name_of_interrupt_config hwi in
          print_csv hwi_pretty;
          Mk_table.cell ~escape:true ~last:false add hwi_pretty;
        ~~ List.iteri procs (fun proc_i proc ->
            ~~ List.iteri EF.kappas_usec (fun kappa_i kappa ->
                let par_baseline_stat = par_baseline_stat_of proc in
                let heartbeat_stat =
                  let mk_config = EF.mk_hardware_interrupt_config_of hwi kappa in
                  heartbeat_stat_of mk_config proc
                in
                let b = par_baseline_stat in
                let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
                let s = Printf.sprintf "%0.f" heartbeat_stat in
                print_csv s;
                Mk_table.cell ~escape:true ~last:last add s
          ));
        print_csv_newline();
      add Latex.tabular_newline);
      add Latex.tabular_end;)
      
let plot () = (
    ~~ List.iter benchmarks (plot_for "nb_heartbeats");
    ~~ List.iter benchmarks (plot_for "nb_promotions");
    ~~ List.iter benchmarks (plot_for "nb_steals");
    ())

let all () = select make run check plot

end

(*****************************************************************************)
(** Main *)

let _ =
  let arg_actions = XCmd.get_others() in
  let bindings = [
      "feasibility", ExpFeasibility.all;
      "stats", ExpStats.all;      
  ]
  in
  Pbench.execute_from_only_skip arg_actions [] bindings;
  ()
