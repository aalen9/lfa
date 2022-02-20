open Lib

let debug = false 

let usage_msg = ""
let test = ref ""
let anon_fun filename = test := ""
let range_num = ref 0
let range_basic = ref 0
let methods = ref 0
let states = ref 0
let foos = ref 1
let comp = ref false
let num_basic_fun = ref 2
let count = ref false

let speclist =
  [
    ("-rangenum", Arg.Set_int range_num, "Total number of LoC");
    ("-rangebasic", Arg.Set_int range_basic, "Number of calls to methods");
    ("-methods", Arg.Set_int methods, "Number of methods in in base class");
    ("-numcomp", Arg.Set_int foos, "Number of composed classes");
    ("-numbasicfun", Arg.Set_int num_basic_fun, "Number of implemented methods");
    ("-states", Arg.Set_int states, "Number of states in DFA contract");
    ("-comp", Arg.Set comp, "Class composition");
    ("-count", Arg.Set count, "Count LoC in contracts");
  ]

let () = Arg.parse speclist anon_fun usage_msg

(* let var_num = 100  *)
(* let var_num = 50  *)
(* let var_basic = 50   *)

(* let var_num = 2500
let var_basic = 1000 *)

(* let var_num = 3500
let var_basic = 2000 *)

let var_num = 6000 
let var_basic = 4000

(* let var_num = 1500 
let var_basic = 500  *)

let file =
  "cr/" ^ "foo-" ^ string_of_int !methods ^ "-" ^ string_of_int !states
  ^ "-lfa.json"

let fun1 () =
  let quit_loop = ref false in
  (* let len1 = 2 in *)
  let len1 = 5 in 
  let num_lines1 = !range_num - !methods - 20 - (!num_basic_fun * 5) in
  let repeats1 = num_lines1 / len1 in
  let repeats1 = repeats1 / !foos in
  let repeats1 = repeats1 / 8 in
  (* let repeats1 = 1 in *)
  (* let repeats1 = 2 in  *)
  (* let repeats1 = 5 in  *)
  (* this is working fot the 3500 3000 code clients *)
  (* let repeats1 = 4 in  *)
     
  let repeats1 = 5 in 
  (* let repeats1 = 0 in  *)
  let repeats = ref repeats1 in

  let c = ref 0 in

  (* let max = if (!comp) then 500000 else 10000 in
     let safe_max = 100000000 in *)
  (* let max = if (!comp) then 500000 else 10000 in
     let safe_max = 100000000 in *)
  (* let max = if !comp then 1000 else 10000 in
  let safe_max = 100000 in *)
  (* let max = if !comp then 100000 else 10000 in
  let safe_max = 10000000 in *)

  (* let max = if !comp then 500 else 10000 in
  let safe_max = 5000 in *)


  (* let max = if !comp then 1000 else 10000 in
  let safe_max = 10000 in *)


  (* let max = if !comp then 10 else 10000 in
  let safe_max = 100 in *)

  (* let max = if !comp then 100 else 10000 in
  let safe_max = 1000 in *)
(* 
  let max = if !comp then 100 else 10000 in
  let safe_max = 1000 in *)

  let max = if !comp then 1000 else 10000 in
  let safe_max = 10000 in
 
  (* let max = if !comp then 5000 else 10000 in
  let safe_max = 50000 in *)

(* 
  let max = if !comp then 1000 else 10000 in
  let safe_max = 10000 in *)
  (* let max = if !comp then 1000 else 10000 in *)
  (* let safe_max = 10000 in *)
  
  (* this works for the 3500 3000 code clients *)
  (* let max = if !comp then 100 else 10000 in
  let safe_max = 1000 in *)

  (* let max = if (!comp) then 500000 else 10000 in
     let safe_max = 100000000 in *)
  let safe_counter = ref 0 in
  let range_basic_min = !range_basic in
  (* let len_basics1 = if !comp then (3, 1) else (len1, !repeats) in *)
  let len_basics1 = (2, !repeats) in 
  let len_fun1 = if !comp then (len1, !repeats) else (1, 1) in
  let len_basics = ref len_basics1 in
  let len_fun = ref len_fun1 in
  let num_basics = if !comp then !num_basic_fun else 1 in
  let num_foos = if !comp then !foos else 1 in

  (* let basic_bias, if_bias = if !comp then (95, 20) else (100, 0) in *)
  let basic_bias, if_bias = if !comp then (95, 40) else (100, 0) in

  (* let num_conds = if !comp then 1 else 0 in *)
  let num_conds = 0 in 
  (* this should one cond *)
  while not !quit_loop do
    if !safe_counter > safe_max then
      let () = quit_loop := true in
      let () =
        Printf.eprintf
          "error methods: %i; states: %i; range_num: %i; foos: %i; 
           range_basic%i"
          !methods !states !range_num !foos !range_basic
      in
      ()
    else
      let num_lines, count, str, out_path =
        Gencomp.gen_java_nested_comp ~comp:!comp ~num_methods:!methods
          ~basic_bias ~if_bias ~num_basic_fun:num_basics ~num_fun:1
          ~num_lines:2 ~num_body_ifs:2 ~num_repeats:2 ~funs_in_if:true
          ~if_branch:true ~num_conds ~num_foos ~len:!len_fun
          ~len_basics:!len_basics ~in_path:file ()
      in
      let () = safe_counter := !safe_counter + 1 in
      (* debug begin *)
      let () = Printf.printf "counter is: %i\n" !safe_counter in 
      let () = Printf.printf "repeats is: %i\n" !repeats in 
      let () = Printf.printf "num of lines is: %i\n" num_lines in
      let () = Printf.printf "num of basic calls is: %i\n" count in
      let () = Printf.printf "\n" in
      (* debug end *)
      let range_num1 = !range_num in 
      (* let range_num1 = !range_num*num_foos in  *)
      let accept = if debug then 
        true 
      else 
        num_lines < range_num1 + var_num
        (* && num_lines > range_num1 - var_num *)
        && count > !range_basic - var_basic
        && count < !range_basic + var_basic  in 
      (* if
        num_lines < range_num1 + var_num
        (* && num_lines > range_num1 - var_num *)
        && count > !range_basic - var_basic
        && count < !range_basic + var_basic  *)
        (* true  *)
      if accept 
      then
        let out_path2 = "foo-" ^ string_of_int !methods ^ "-" in
        let out_path2 = out_path2 ^ string_of_int !states ^ "-lfa-foos-" in
        let out_path2 =
          out_path2 ^ string_of_int !foos ^ "-num-" ^ string_of_int !range_num
        in
        let out_path2 =
          out_path2 ^ "-count-" ^ string_of_int !range_basic ^ ".java"
        in
        let out_path2 =
          if !comp then out_path2
          else
            "flat-foo-" ^ string_of_int !methods ^ "-" ^ string_of_int !states
            ^ "-lfa-num-" ^ string_of_int !range_num ^ ".java"
        in
        let () = Gencomp.print_to_file out_path2 str in
        let () = Printf.printf "%s" out_path2 in
        let () = quit_loop := true in
        ()
      else if !c > max then
        let () = c := 0 in
        let () = repeats := !repeats + 1 in
        let () = len_basics := if !comp then (5, 1) else (len1, !repeats) in
        let () = len_fun := if !comp then (len1, !repeats) else (1, 1) in
        ()
      else
        let () = c := !c + 1 in
        ()
  done

let count_fun () =
  let cr =
    [
      (3, 2);
      (3, 3);
      (3, 4);
      (5, 5);
      (5, 9);
      (5, 14);
      (7, 18);
      (7, 30);
      (7, 41);
      (10, 85);
      (14, 100);
      (* (14, 522);  *)
      (14, 1044);
      (14, 1628);
      (14, 2322);
      (16, 2644);
      (18, 3138);
      (18, 3638);
      (18, 4000);
      (* (3,5);  *)
    ]
  in

  let dir1 = "cr/" in
  let counter = ref 1 in
  let count_list x =
    let states = snd x in
    let methods = fst x in
    let () = Format.printf "CR %i\n" !counter in
    let () = Format.printf "Num methods: %i\n" methods in
    let () = Format.printf "Num states: %i\n" states in
    let () =
      LfaSpecs.read_lta_dfa_topl_filter ~num_states:states ~num_methods:methods
        ~folder:dir1
    in
    let () = counter := !counter + 1 in
    let () = Format.printf "\n" in
    ()
  in
  List.iter count_list cr

let () = if !count then count_fun () else fun1 ()
