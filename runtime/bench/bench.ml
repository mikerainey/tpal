open XBase
open Params

let system = XSys.command_must_succeed_or_virtual

(*****************************************************************************)
(** Parameters *)

let arg_virtual_run = XCmd.mem_flag "virtual_run"
let arg_virtual_build = XCmd.mem_flag "virtual_build"
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
  XCmd.parse_or_default_int "proc" default
let arg_proc_step = XCmd.parse_or_default_int "proc_step" 10
let arg_dflt_size = XCmd.parse_or_default_int "n" 600000000
let arg_par_baseline = XCmd.parse_or_default_string "par_baseline" "cilk"

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
  Printf.sprintf "results_%s.txt" exp_name

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
         ("software_polling_K", Format_custom (fun n -> Printf.sprintf "K=%s" n));
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

(*****************************************************************************)
(* Benchmark descriptions *)

let pretty_name = "!pretty_name" 
let mk_pretty_name = mk string pretty_name

let mk_n n =
    (mk int "n" n)
  & (mk_pretty_name (Printf.sprintf "$%s \\cdot 10^6$ items" (string_of_millions (float_of_int n))))

type benchmark_descr = {
    bd_problem : string;
    bd_mk_input : Params.t;
}

let benchmarks : benchmark_descr list = [
    { bd_problem = "incr_array";
      bd_mk_input = mk_n (1000 * 1000 * 1000) };
    { bd_problem = "plus_reduce_array";
      bd_mk_input = mk_n (1000 * 1000 * 1000) };
    { bd_problem = "spmv";
      bd_mk_input = mk_n (500 * 1000 * 1000) };
    { bd_problem = "fib";
      bd_mk_input = mk_n 40 };    
]

let mk_benchmark_descr bd =
    (mk string "benchmark" bd.bd_problem)
  & bd.bd_mk_input
                                        
(*****************************************************************************)
(** Scaling experiment *)

module ExpScaling = struct

let name = "scaling"
             
let kappas_usec = [30;100;200;400]

let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let mk_software_polling_configuration =
  (mk_scheduler_configuration "software_polling") & (mk_list int "software_polling_K" [256;])

let mk_manual_configuration =
  (mk_scheduler_configuration "manual") & (mk int "incr_array_manual_T" 2048)

let mk_heartbeat_scheduler_configurations = ((
      mk_software_polling_configuration  
   ++ (mk_scheduler_configuration "interrupt_ping_thread")
   ++ (mk_scheduler_configuration "interrupt_pthread")
   ++ (mk_scheduler_configuration "interrupt_papi")) & mk_kappas_usec)
   ++ mk_manual_configuration
                                          
let mk_proc1 = mk int "proc" 1

let procs =
  let rec gen p =
    if p >= arg_proc then
      [arg_proc]
    else
      p :: gen (p + arg_proc_step)
  in
  let procs = gen arg_proc_step in
  match procs with
  | 1 :: _ -> procs
  | _ -> 1 :: procs

let mk_procs = mk_list int "proc" procs

let mk_progs =
  (mk_prog prog_heartbeat) & mk_sizes
  
let mk_heartbeat_runs =
   mk_progs & mk_procs & mk_heartbeat_scheduler_configurations
  
let mk_baseline_runs =
  mk_progs & mk_proc1 & mk_scheduler_configuration "serial"

let mk_cilk_scheduler_configuration =
  mk_scheduler_configuration "cilk"
  
let mk_cilk_runs =
  (mk_prog prog_cilk) & mk_procs & mk_sizes & mk_cilk_scheduler_configuration

let name_baseline = name ^ "_baseline"
let name_cilk = name ^ "_cilk"
  
let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run() = (
  Mk_runs.(call (run_modes @ [
    Output (file_results name);
    Timeout 1000;
    Args mk_heartbeat_runs]));
  Mk_runs.(call (run_modes @ [
    Output (file_results name_cilk);
    Timeout 1000;
    Args mk_cilk_runs]));
  Mk_runs.(call (run_modes @ [
    Output (file_results name_baseline);
    Timeout 1000;
    Args mk_baseline_runs])))
  
let check = nothing  (* do something here *)
          
let plot_baseline() =
  let results_baseline = Results.from_file (file_results name_baseline) in
  let eval_speedup = fun env all_results results ->
    let results_baseline =
      ~~ Results.filter_by_params results_baseline (
           from_env (Env.filter_keys ["n";] env))
    in
    let v = Results.get_mean_of "exectime" results in
    let b = Results.get_mean_of "exectime" results_baseline in
    b /. v
  in
    Mk_scatter_plot.(call ([
      Chart_opt Chart.([
        Legend_opt Legend.([Legend_pos Bottom_right]); 
        ]);
      Scatter_plot_opt Scatter_plot.([
         Draw_lines true; 
         Y_axis [Axis.Lower (Some 0.);] ]);
      Charts mk_sizes;
      Series mk_heartbeat_scheduler_configurations;
      X mk_procs;
      Input (file_results name);
      Y_label "exectime(serial) / exectime(*)";
      X_label "Nb. proc";
      Y eval_speedup;
      Output (file_plots name);
      Formatter formatter;
      ] 
     )); ()

let plot_cilk() =
  let results_baseline = Results.from_file (file_results name_cilk) in
  let eval_speedup = fun env all_results results ->
    let results_baseline =
      ~~ Results.filter_by_params results_baseline (
           from_env (Env.filter_keys ["n";] env))
    in
    let v = Results.get_mean_of "exectime" results in
    let b = Results.get_mean_of "exectime" results_baseline in
    b /. v
  in
    Mk_scatter_plot.(call ([
      Chart_opt Chart.([
        Legend_opt Legend.([Legend_pos Bottom_right]); 
        ]);
      Scatter_plot_opt Scatter_plot.([
         Draw_lines true; 
         Y_axis [Axis.Lower (Some 0.0);] ]);
      Charts mk_sizes;
      Series mk_heartbeat_scheduler_configurations;
      X mk_procs;
      X_label "Nb. proc";
      Input (file_results name);
      Y_label "exectime(Cilk) / exectime(*)";
      Y eval_speedup;
      Output (file_plots name_cilk);
      Formatter formatter;
      ] 
     )); ()

let plot () = (plot_baseline(); plot_cilk())
            
let all () = select make run check plot

end

(*****************************************************************************)
(** Work-efficiency *)

module ExpWorkEfficiency = struct

let name = "work_efficiency"
             
let kappas_usec = (*[20;30;40;50;60;100;150;200;400]*)
  [20;50;100;200;]

let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let mk_software_polling_configuration =
  (mk_scheduler_configuration "software_polling") & (mk_list int "software_polling_K" [128;256;512;])

let mk_heartbeat_scheduler_configurations = 
      mk_software_polling_configuration  
   ++ (mk_scheduler_configuration "interrupt_ping_thread")
   ++ (mk_scheduler_configuration "interrupt_pthread")
   ++ (mk_scheduler_configuration "interrupt_papi")
    
let mk_proc1 = mk int "proc" 1

let mk_progs =
  (mk_prog prog_heartbeat) & mk_proc1 & mk_sizes
  
let mk_heartbeat_runs =
   mk_progs & mk_heartbeat_scheduler_configurations & mk_kappas_usec
  
let mk_baseline_runs =
  mk_progs & mk_scheduler_configuration "serial"

let mk_cilk_scheduler_configuration =
  mk_scheduler_configuration "cilk"
  
let mk_cilk_runs =
  (mk_prog prog_cilk) & mk_proc1 & mk_sizes & mk_cilk_scheduler_configuration

let name_baseline = name ^ "_baseline"
let name_cilk = name ^ "_cilk"
  
let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run() = (
  Mk_runs.(call (run_modes @ [
    Output (file_results name);
    Timeout 1000;
    Args mk_heartbeat_runs]));
  Mk_runs.(call (run_modes @ [
    Output (file_results name_cilk);
    Timeout 1000;
    Args mk_cilk_runs]));
  Mk_runs.(call (run_modes @ [
    Output (file_results name_baseline);
    Timeout 1000;
    Args mk_baseline_runs])))
  

let check = nothing  (* do something here *)
          
let plot_baseline() =
  let results_baseline = Results.from_file (file_results name_baseline) in
  let eval_work_efficiency = fun env all_results results ->
    let results_baseline =
      ~~ Results.filter_by_params results_baseline (
           from_env (Env.filter_keys ["n";] env))
    in
    let v = Results.get_mean_of "exectime" results in
    let b = Results.get_mean_of "exectime" results_baseline in
    v /. b
  in
    Mk_scatter_plot.(call ([
      Chart_opt Chart.([
        Legend_opt Legend.([Legend_pos Bottom_right]); 
        ]);
      Scatter_plot_opt Scatter_plot.([
         Draw_lines true; 
         Y_axis [Axis.Lower (Some 0.8); Axis.Upper (Some 1.4)] ]);
      Charts mk_sizes;
      Series mk_heartbeat_scheduler_configurations;
      X mk_kappas_usec;
      Input (file_results name);
      Y_label "exectime(*) / exectime(serial)";
      X_label "heartbeat period (usec))";
      Y eval_work_efficiency;
      Output (file_plots name);
      Formatter formatter;
      ] 
     )); ()

let plot_cilk() =
  let results_baseline = Results.from_file (file_results name_cilk) in
  let eval_work_efficiency = fun env all_results results ->
    let results_baseline =
      ~~ Results.filter_by_params results_baseline (
           from_env (Env.filter_keys ["n";] env))
    in
    let v = Results.get_mean_of "exectime" results in
    let b = Results.get_mean_of "exectime" results_baseline in
    v /. b
  in
    Mk_scatter_plot.(call ([
      Chart_opt Chart.([
        Legend_opt Legend.([Legend_pos Bottom_right]); 
        ]);
      Scatter_plot_opt Scatter_plot.([
         Draw_lines true; 
         Y_axis [Axis.Lower (Some 0.8); Axis.Upper (Some 1.4)] ]);
      Charts mk_sizes;
      Series mk_heartbeat_scheduler_configurations;
      X mk_kappas_usec;
      X_label "heartbeat period (usec))";
      Input (file_results name);
      Y_label "exectime(*) / exectime(Cilk)";
      Y eval_work_efficiency;
      Output (file_plots name_cilk);
      Formatter formatter;
      ] 
     )); ()

let plot () = (plot_baseline(); plot_cilk())
            
let all () = select make run check plot

end

(*****************************************************************************)
(** Feasibility experiment *)

module ExpFeasibility = struct

let name_of bd = "feasibility_" ^ bd.bd_problem
         
let kappas_usec = [20;40;100]
                
let mk_kappas_usec =
  mk_list int "kappa_usec" kappas_usec

let software_polling_Ks = [8;32;128;512]

let software_polling_K = "software_polling_K"

let mk_software_polling_config_of k =
    (mk_scheduler_configuration "software_polling")
  & (mk int software_polling_K k)
    
let mk_software_polling_configs =
  mk_all mk_software_polling_config_of software_polling_Ks

let mk_hardware_interrupt_config_of hwi kappa =
  mk_scheduler_configuration hwi & mk int "kappa_usec" kappa

let interrupt_ping_thread = "interrupt_ping_thread"
let interrupt_pthread = "interrupt_pthread"
let interrupt_papi = "interrupt_papi"
                        
let mk_hardware_interrupt_configs =
      (mk_scheduler_configuration interrupt_ping_thread)
   ++ (mk_scheduler_configuration interrupt_pthread)
   ++ (mk_scheduler_configuration interrupt_papi)

let pretty_name_of_interrupt_config n =
  if n = interrupt_ping_thread then "INT-PingThread"
  else if n = interrupt_pthread then "INT-Pthread"
  else if n = interrupt_papi then "INT-Papi"
  else "<unknown>"
    
let mk_heartbeat_configs = 
    (  mk_software_polling_configs
    ++ mk_hardware_interrupt_configs)
  & mk_kappas_usec

let mk_baseline_config =
  mk_scheduler_configuration "serial"

let procs = [1;arg_proc;]
          
let mk_proc = mk_list int "proc" procs
            
let mk_size = mk int "n" arg_dflt_size
  
let mk_prog_homegrown = mk_prog prog_heartbeat
  
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

let name_heartbeat bd = (name_of bd) ^ "_heartbeat"
let name_manual bd = (name_of bd) ^ "_manual"
let name_baseline bd = (name_of bd) ^ "_baseline"
let name_cilk bd = (name_of bd) ^ "_cilk"
let name_par_baseline bd = (name_of bd) ^ "_" ^ arg_par_baseline

let make() =
  build "." [prog_heartbeat; prog_cilk;] arg_virtual_build

let run_for bd = (
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_heartbeat bd));
    Timeout 90;
    Args (mk_heartbeat_runs bd)]));
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_par_baseline bd));
    Timeout 400;
    Args (mk_par_baseline_runs bd)]));
  Mk_runs.(call (run_modes @ [
    Output (file_results (name_baseline bd));
    Timeout 1000;
    Args (mk_baseline_runs bd)])))

let run() = ~~ List.iter benchmarks run_for
  
let check = nothing  (* do something here *)

(* later: support plotting for benchmarks with multiple inputs *)
(* later : collect latencies from stats binaries *)
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
      let baseline_exectime =
        let results = Results.from_file (file_results (name_baseline bd)) in
        let [col] = (mk_baseline_runs bd) Env.empty in
        let results = Results.filter col results in
        Results.get_mean_of "exectime" results
      in
      let cilk_exectime_of proc =
        let results = Results.from_file (file_results (name_cilk bd)) in
        let [col] = (mk_cilk_runs_of bd proc) Env.empty in
        let results = Results.filter col results in
        Results.get_mean_of "exectime" results
      in
      let manual_exectime_of proc =
        let results = Results.from_file (file_results (name_manual bd)) in
        let [col] = (mk_manual_runs_of bd proc) Env.empty in
        let results = Results.filter col results in
        Results.get_mean_of "exectime" results
      in
      let par_baseline_exectime_of =
        if arg_par_baseline = "cilk" then
          cilk_exectime_of
        else
          manual_exectime_of
      in
      let heartbeat_exectime_of mk_config proc =
        let results = Results.from_file (file_results (name_heartbeat bd)) in
        let [col] = (mk_heartbeat_runs_of bd mk_config proc) Env.empty in
        let results = Results.filter col results in
        Results.get_mean_of "exectime" results
      in
      Mk_table.cell ~escape:true ~last:false add "baseline (s)";
      ~~ List.iteri procs (fun proc_i proc ->
            let par_baseline_exectime = par_baseline_exectime_of proc in
            let b = if proc = 1 then baseline_exectime else par_baseline_exectime in
            let last = proc_i+1 = nb_procs in
            Mk_table.cell ~escape:true ~last:last add (Latex.tabular_multicol nb_kappas "c|" (Printf.sprintf "%.3f" b)));
      (* Header *)
      add Latex.tabular_newline;
      Mk_table.cell ~escape:true ~last:false add "$H$";
      ~~ List.iteri procs (fun proc_i proc ->
          ~~ List.iteri kappas_usec (fun kappa_i kappa ->
              let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
              Mk_table.cell ~escape:true ~last:last add (Printf.sprintf "$%d\mu s$" kappa)
      ));
      add Latex.tabular_newline;
      ~~ List.iteri software_polling_Ks (fun swpK_i swpK ->
          Mk_table.cell ~escape:true ~last:false add (Printf.sprintf "SWP-%d" swpK);
        ~~ List.iteri procs (fun proc_i proc ->
            let par_baseline_exectime = par_baseline_exectime_of proc in
            let heartbeat_exectime =
              let mk_config = mk_software_polling_config_of swpK in
              heartbeat_exectime_of mk_config proc
            in
            let b = if proc = 1 then baseline_exectime else par_baseline_exectime in
            let chg = string_of_percentage_change ~show_plus:true b heartbeat_exectime in
            ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
                Mk_table.cell ~escape:true ~last:last add chg
      ));
      add Latex.tabular_newline);
      let hwis = values_of_keys_in_params mk_hardware_interrupt_configs [scheduler_configuration;] in
      ~~ List.iteri hwis (fun hwi_i [hwi] ->
          let hwi_pretty = pretty_name_of_interrupt_config hwi in
          Mk_table.cell ~escape:true ~last:false add hwi_pretty;
        ~~ List.iteri procs (fun proc_i proc ->
            ~~ List.iteri kappas_usec (fun kappa_i kappa ->
                let par_baseline_exectime = par_baseline_exectime_of proc in
                let heartbeat_exectime =
                  let mk_config = mk_hardware_interrupt_config_of hwi kappa in
                  heartbeat_exectime_of mk_config proc
                in
                let b = if proc = 1 then baseline_exectime else par_baseline_exectime in
                let chg = string_of_percentage_change ~show_plus:true b heartbeat_exectime in
                let last = proc_i+1 = nb_procs && kappa_i+1 = nb_kappas in
                Mk_table.cell ~escape:true ~last:last add chg
      ));
      add Latex.tabular_newline);
      add Latex.tabular_end;)
      
let plot () = ~~ List.iter benchmarks plot_for

let all () = select make run check plot

end

(*****************************************************************************)
(** Main *)

let _ =
  let arg_actions = XCmd.get_others() in
  let bindings = [
      "feasibility", ExpFeasibility.all;
(*      "scaling", ExpScaling.all;
      "work_efficiency", ExpWorkEfficiency.all;*)
  ]
  in
  Pbench.execute_from_only_skip arg_actions [] bindings;
  ()
