module Json = Yojson
(* require Ltatodfa5 *)

(* open Ltatodfa *)
module JsonUtil = Json.Basic.Util 

module B = Bitv 

module Label = String 

module LtaSet = Set.Make (Label)

module LtaDefMap = Map.Make (Label) 
module LtaDefMapInt = Map.Make (Int) 

module MapInt = Map.Make(Int)
module MapString = Map.Make(String)



let (--) i j = 
    let rec aux n acc =
    if n < i then acc else aux (n-1) (n :: acc)
    in aux j [] 

let rec random_not_in_list l0 max = 
  let r = Random.int max in 
  if (List.memq r l0) then 
      random_not_in_list l0 max 
  else 
      r 

let rec random_list len max = 
  if (len == 0) then 
      [] 
  else 
      let l1 = random_list (len - 1) max in 
      let r = random_not_in_list l1 max in 
      List.cons r l1 





type ltas_dict = {enable: LtaSet.t; disable: LtaSet.t}

let empty_ltas_d = {enable=LtaSet.empty; disable=LtaSet.empty}

let a = {enable = LtaSet.empty; disable= LtaSet.empty}

(* produce LtaDefMap *)
let json_to_lta json = 
  let lta_map = LtaDefMap.empty in 
  let class_name_bindings = json |>JsonUtil.to_assoc in 
  let (class_name, lta_json) = List.hd class_name_bindings in 
  let bindings = lta_json |> JsonUtil.to_assoc in 
  (* iterate over bindings *)
  let f_per_method json0 = 
    let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
    let enables = List.map (fun x -> JsonUtil.to_string x) en_json in
    let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
    let disables = List.map (fun x -> JsonUtil.to_string x) dis_json in
    let en_set = LtaSet.of_list enables in 
    let dis_set = LtaSet.of_list disables in 
      {enable = en_set; disable=dis_set} in 
  let f (method_name, json_per_method) lta_map0 = 
    let ltas = f_per_method json_per_method in 
    LtaDefMap.add method_name ltas lta_map0 in 
  (class_name, List.fold_right f bindings lta_map)




 (* read from file *)
let get_lta_from_file lta_properties_paths = 
  let lta_json =     
   Option.some (Json.Basic.from_file (List.hd lta_properties_paths)) in  
   let (class_name, lta) = 
   (match lta_json with 
   | Some json -> json_to_lta json
   | None -> ("empty", LtaDefMap.empty)) in 
   (class_name, lta) 

   
let set_to_list_s set = 
  let s = LtaSet.to_seq set in 
  let l = List.of_seq s in l 
(* LTA to JSON *)

let ltas_to_json {enable=enable_set;disable=disable_set} =
  let enables = set_to_list_s enable_set in 
  let disables = set_to_list_s disable_set in 
  let json_enables = List.map (fun x -> `String x) enables in 
  let json_disables = List.map (fun x -> `String x) disables in 
  let json = `Assoc [("enable", `List json_enables);("disable", `List json_disables)] in 
    json 

let lta_to_json class_name lta_map_s = 
  let method_list = [] in 
  let f method_name ltas method_list = 
    let json_ltas = ltas_to_json ltas in 
    let entry = (method_name, json_ltas) in 
    List.append [entry] method_list in 
  let method_list = LtaDefMap.fold f lta_map_s method_list in 
  let lta_json = `Assoc method_list in 
  `Assoc [(class_name, lta_json)]

(* let init_pn = "void Foo.init()"  *)

let print_set lta_set = LtaSet.iter print_endline lta_set 

(* produce LtaDefMap *)
(* desugaring EnableOnly and DisableOnly *)
let json_to_lfa_only json = 
  let lta_map = LtaDefMap.empty in 
  let class_name_bindings = json |>JsonUtil.to_assoc in 
  let (class_name, lta_json) = List.hd class_name_bindings in 
  let bindings = lta_json |> JsonUtil.to_assoc in 
  (* if init_pn is not in bindings, then infer it *)
  let init_pn_str = "init()" in 
  let is_init_pn x = 
    let strs = String.split_on_char '.' x in 
    let last_str = List.hd (List.rev strs) in 
      String.equal init_pn_str last_str in  
  (* let init_pn_opt = List.find_opt (fun x -> is_init_pn (fst x)) bindings in  *)
  let infer_init_b = List.exists (fun x -> is_init_pn (fst x)) bindings in 
  let init_pn = 
    let prefix_str1 = fst (List.hd bindings) in  
    let prefix_strs = String.split_on_char '.' prefix_str1 in 
    let prefix_str = List.hd prefix_strs in 
    let () = print_endline "prefix_str is: " in 
    let () = print_endline prefix_str in 
      String.concat "." [prefix_str;init_pn_str] in 
  let () = print_endline "init_pn is: " in 
  let () = print_endline init_pn in 
  (* let infer_init_b = List.exists (fun x -> String.equal (fst x) init_pn) bindings in  *)
  let infer_init_b = not infer_init_b in 
  let not_enabled_init = ref LtaSet.empty in 
  (* iterate over bindings *)
  let f_per_method all_methods_set json0 = 
    (* all keys are optional *)
    (* let f_opt_list = JsonUtil.to_option JsonUtil.to_list in  *)
    let f_opt_list = 
      JsonUtil.to_option 
        (fun x -> x |> JsonUtil.to_list |> List.map (fun x -> JsonUtil.to_string x)) in 
    let en_only_opt = json0 |> JsonUtil.member "enableOnly" |> f_opt_list in
    let dis_only_opt = json0 |> JsonUtil.member "disableOnly" |> f_opt_list in 
    let (en_set, dis_set) = 
      (match en_only_opt, dis_only_opt with 
      | Some en_only, None -> 
        (LtaSet.of_list en_only, LtaSet.diff all_methods_set (LtaSet.of_list en_only))
      | None, Some dis_only -> 
        (LtaSet.diff all_methods_set (LtaSet.of_list dis_only), LtaSet.of_list dis_only)
      | None, None -> 
        let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
        let enables = List.map (fun x -> JsonUtil.to_string x) en_json in
        let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
        let disables = List.map (fun x -> JsonUtil.to_string x) dis_json in
        let en_set = LtaSet.of_list enables in 
        let dis_set = LtaSet.of_list disables in 
          (en_set, dis_set)
      | _, _ -> raise (JsonUtil.Type_error ("Illegal", json0))) in 
    let () = if (LtaSet.subset all_methods_set en_set) then () else 
               not_enabled_init := LtaSet.union (!not_enabled_init) en_set in 
      {enable = en_set; disable=dis_set} in 
  let all_methods_list = List.map fst bindings in 
  let all_methods_set = LtaSet.of_list all_methods_list in 
  let f (method_name, json_per_method) lta_map0 = 
    let ltas = (f_per_method all_methods_set) json_per_method in 
    LtaDefMap.add method_name ltas lta_map0 in 
  let lfa = List.fold_right f bindings lta_map in 
  (* debug begin *)
  (* let () = print_endline "infer_init_b is: " in 
  let () = if (infer_init_b) then print_endline "yes" else print_endline "no" in 
  let () = print_endline "not_enabled_init is: " in 
  let () = print_set !not_enabled_init in  *)
  (* debug end *)
  let init_en = LtaSet.diff all_methods_set !not_enabled_init in 
  let init_dis = !not_enabled_init in 
  let lfa' = if (infer_init_b) then 
                LtaDefMap.add init_pn {enable = init_en; disable=init_dis} lfa  
              else lfa in 
  (class_name, lfa')



  let json_to_lfa_only_count json reachable_set = 
    let lta_map = LtaDefMap.empty in 
    let count = ref 0 in 
    let class_name_bindings = json |>JsonUtil.to_assoc in 
    let (class_name, lta_json) = List.hd class_name_bindings in 
    let bindings = lta_json |> JsonUtil.to_assoc in 
    (* iterate over bindings *)
    let f_per_method all_methods_set json0 = 
      (* all keys are optional *)
      (* let f_opt_list = JsonUtil.to_option JsonUtil.to_list in  *)
      let f_opt_list = 
        JsonUtil.to_option 
          (fun x -> x |> JsonUtil.to_list |> List.map (fun x -> JsonUtil.to_string x)) in 
      let en_only_opt = json0 |> JsonUtil.member "enableOnly" |> f_opt_list in
      let dis_only_opt = json0 |> JsonUtil.member "disableOnly" |> f_opt_list in 
      let (en_set, dis_set) = 
        (match en_only_opt, dis_only_opt with 
        | Some en_only, None -> 
          let () = if (LtaSet.is_empty (LtaSet.of_list en_only)) then 
                     () else  count := !count + 1 in 
          (LtaSet.of_list en_only, LtaSet.diff all_methods_set (LtaSet.of_list en_only))
        | None, Some dis_only -> 
          let () = if (LtaSet.is_empty (LtaSet.of_list dis_only)) then 
            () else  count := !count + 1 in 
          (LtaSet.diff all_methods_set (LtaSet.of_list dis_only), LtaSet.of_list dis_only)
        | None, None -> 
          let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
          let enables = List.map (fun x -> JsonUtil.to_string x) en_json in
          let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
          let disables = List.map (fun x -> JsonUtil.to_string x) dis_json in
          let en_set = LtaSet.of_list enables in 
          let () = if (LtaSet.is_empty en_set) then () else count := !count + 1 in 
          let dis_set = LtaSet.of_list disables in 
          let () = if (LtaSet.is_empty dis_set) then () else count := !count + 1 in 
            (en_set, dis_set)
        | _, _ -> raise (JsonUtil.Type_error ("Illegal", json0))) in 
        {enable = en_set; disable=dis_set} in 
    let all_methods_list = List.map fst bindings in 
    let all_methods_set = LtaSet.of_list all_methods_list in 
    let f (method_name, json_per_method) lta_map0 = 
      if (LtaSet.mem method_name reachable_set) then 
        let ltas = (f_per_method all_methods_set) json_per_method in 
          LtaDefMap.add method_name ltas lta_map0  
      else 
        lta_map0 in 
    let lfa =  List.fold_right f bindings lta_map in 
    (class_name, lfa, !count)

(* produce LtaDefMap *)
let json_to_lta json = 
  let lta_map = LtaDefMap.empty in 
  let class_name_bindings = json |>JsonUtil.to_assoc in 
  let (class_name, lta_json) = List.hd class_name_bindings in 
  let bindings = lta_json |> JsonUtil.to_assoc in 
  (* iterate over bindings *)
  let f_per_method json0 = 
    let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
    let enables = List.map (fun x -> JsonUtil.to_string x) en_json in
    let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
    let disables = List.map (fun x -> JsonUtil.to_string x) dis_json in
    let en_set = LtaSet.of_list enables in 
    let dis_set = LtaSet.of_list disables in 
      {enable = en_set; disable=dis_set} in 
  let f (method_name, json_per_method) lta_map0 = 
    let ltas = f_per_method json_per_method in 
    LtaDefMap.add method_name ltas lta_map0 in 
  (class_name, List.fold_right f bindings lta_map)

  (* DFA specs read and write JSON *)
  (* DFA write *)
(* DFA: MapString *)
(* state -> (label -> state) *)
let dfa_state_to_json dfa_map_state = 
  let bindings = MapString.bindings dfa_map_state in 
  let f (label, state) =  
    (label, `String state) in 
  let list_pairs = List.map f bindings in 
  `Assoc list_pairs 

let dfa_to_json (init_state, dfa_map) = 
  let bindings = MapString.bindings dfa_map in 
  let f (state, state_map) = 
    (state, dfa_state_to_json state_map) in 
  let list_pairs = List.map f bindings in 
  let transitions = `Assoc list_pairs in 
  let json = `Assoc [("init_state",`String init_state); ("transitions", transitions)] in 
    json 



  (* DFA read *)
let json_to_dfa dfa_json = 
  (* let bindings = dfa_json |> JsonUtil.to_assoc in  *)
  let init_state = dfa_json |> JsonUtil.member "init_state" |> JsonUtil.to_string in 
  let transitions = dfa_json |> JsonUtil.member "transitions" |> JsonUtil.to_assoc in 
  let f_per_state_map (label, to_state_json) dfa_state = 
    let to_state = to_state_json |> JsonUtil.to_string in 
    MapString.add label to_state dfa_state in 
  let f (state, state_json) dfa_map = 
    let bindings_per_state = state_json |> JsonUtil.to_assoc in 
    let dfa_state = MapString.empty in 
    let dfa_state =
        List.fold_right f_per_state_map bindings_per_state dfa_state in 
    MapString.add state dfa_state dfa_map in 
  let dfa_map = MapString.empty in 
  let dfa_map = List.fold_right f transitions dfa_map  in 
      (init_state, dfa_map)


  (* include class name  *)

let java_proc_name class_name return_type proc_name proc_name_num = 
  return_type^" "^class_name^"."^proc_name^(proc_name_num)^"()"

let java_proc_name_s = java_proc_name "Foo" "void" "foo"
let pn_init = java_proc_name "Foo" "void" "init" "" 



let print_to_file file str0 = 
    let oc = open_out file in 
        Printf.fprintf oc "%s" str0; 
        close_out oc;; 

(* let print_set lta_set = LtaSet.iter print_endline lta_set  *)


let print_lfa_dict lfa_dict = 
  let () = print_endline "enable is: " in 
  let () = print_set lfa_dict.enable in 
  let () = print_endline "disable is: " in 
  let () = print_set lfa_dict.disable in () 


let read_lfa file_path = 
  let lta_json = Json.Basic.from_file (file_path)  in 
  let lta = json_to_lfa_only lta_json in 
  let (_class_name, lta) = lta in 
    lta

(* let read_count_lfa file_path = 
  let lfa_json = Json.Basic.from_file (file_path) in 
  let (_class_name, lfa) = json_to_lfa_only lfa_json in 
  (* let reachable_set = reachable  *)
  let (_class_name, _lfa, count) = json_to_lfa_only_count lfa_json in 
    count  *)


let read_lta file_path = 
  let lta_json = Json.Basic.from_file (file_path)  in 
  let lta = json_to_lta lta_json in 
  let (_class_name, lta) = lta in 
    lta 
  
(* count LoC in LTA *)
(* count enable and disable *)
(* all information, then we use what we use *)
let count_lta_loc_ltas ltas = 
  let {enable=set_en;disable=set_dis} = ltas in 
  let count1 = 0 in 
  let count1 = 
    if (LtaSet.is_empty set_en) then 
      count1 
  else 
    count1 + 1 in 
  let count1 = 
    if (LtaSet.is_empty set_dis) then 
      count1 
  else 
    count1 + 1 in 
  let count2 = (LtaSet.cardinal set_en) + (LtaSet.cardinal set_dis) in 
  (count1, count2) 

let count_lta_loc lta = 
  let f _key ltas (count1, count2) = 
    let (count_l1, count_l2) = count_lta_loc_ltas ltas in 
    (count1 + count_l1, count_l2+count2) in 
  MapString.fold f lta (0,0) 

let read_and_count_lta file_path =
  let lta = read_lta file_path in 
  count_lta_loc lta  


 (* count LoCs of DFA *)
 (* count transitions *)
let count_dfa_loc dfa = 
  let f _key map1 count = 
    count + (MapString.cardinal map1) in 
  MapString.fold f dfa 0 

let read_and_count_dfa file_path = 
  let dfa_json = Json.Basic.from_file file_path in 
  let (init_state_name, dfa) = json_to_dfa dfa_json in 
  let count = count_dfa_loc dfa in 
  count 


  let read_file_lines filename = 
    let lines = ref [] in
    let chan = open_in filename in
    try
      while true; do
        lines := input_line chan :: !lines
      done; !lines
    with End_of_file ->
      close_in chan;
      List.rev !lines ;;

  let read_and_count_topl file_path = 
    let lines = read_file_lines file_path in 
    let count = List.length lines in 
    let count = count - 4 in 
      count 


  (* file name should be num methods - num states *)
  let read_lta_dfa_topl ~num_methods ~num_states ~folder =
    let file_name = 
      "foo-"^(string_of_int num_methods)^"-"^(string_of_int num_states) in 
    let file_name = folder^file_name in 
    let lta_file_name = file_name^"-lta.json" in 
    let dfa_file_name = file_name^"-dfa.json" in 
    let topl_file_name = file_name^".topl" in 
    let count_lta = read_and_count_lta lta_file_name in 
    let count_dfa = read_and_count_dfa dfa_file_name in 
    let count_topl = read_and_count_topl topl_file_name in 
    (* now print *)
    let () = Format.printf "LTA locs: %i; set size: %i\n" (fst count_lta) (snd count_lta) in 
    let () = Format.printf "DFA locs: %i\n" count_dfa in 
    let () = Format.printf "TOPL locs: %i\n" count_topl in
      () 


let rec iter_queue_dynamic f res0 queue = 
  (* f : elt -> res -> queue -> res *)
  if (Queue.is_empty queue) then 
      res0 
  else 
      let elt = Queue.pop queue in 
      let res1 = f elt res0 queue in 
      iter_queue_dynamic f res1 queue 

let add_set_to_queue set queue = 
  let seq = LtaSet.to_seq set in 
  let () = Queue.add_seq queue seq in () 


let reachable_lta lta = 
  let unexplored = Queue.create () in 
  let f elt res unexplored = 
    let ltas = MapString.find elt lta in 
    let enabled = ltas.enable in 
    let new_en = LtaSet.diff enabled res in 
    let res1 = LtaSet.union enabled res in 
    let () = add_set_to_queue new_en unexplored in 
      res1 in 
  let init_pn =  "void Foo.init()" in
  let {enable=enabled;disable=_} = MapString.find init_pn lta in 
  let reachable = enabled in 
  let reachable = LtaSet.add init_pn reachable in 
  let () = add_set_to_queue enabled unexplored in 
  iter_queue_dynamic f reachable unexplored


  let set_to_list set = 
    let seq = LtaSet.to_seq set in 
    let li = List.of_seq seq in li 

let empty_ltas = {enable=LtaSet.empty;disable=LtaSet.empty}

(* reset all annotation that are not reachable *)
let filter_lta lta = 
  let reachable = reachable_lta lta in 
  let f key ltas = 
      if (LtaSet.mem key reachable) then 
        ltas 
    else 
      empty_ltas in 
  (MapString.mapi f lta, LtaSet.cardinal reachable) 



(* let count_lfa lfa = 
  let reachable_methods = reachable_lta lfa in  *)



let read_and_count_lta_filter file_path =
  let lta = read_lta file_path in 
  let (lta1, reachable) = filter_lta lta in 
  (count_lta_loc lta1, reachable) 

  let read_count_lfa file_path = 
    let lfa_json = Json.Basic.from_file (file_path) in 
    let (_class_name, lfa) = json_to_lfa_only lfa_json in 
    let reachable_set = reachable_lta lfa in 
    let (_class_name, _lfa, count) = json_to_lfa_only_count lfa_json reachable_set in 
      count 


  (* let read_lta_dfa_topl_filter ~num_methods ~num_states ~folder =
    let file_name = 
      "foo-"^(string_of_int num_methods)^"-"^(string_of_int num_states) in 
    let file_name = folder^file_name in 
    let lta_file_name = file_name^"-lfa.json" in 
    let dfa_file_name = file_name^"-dfa.json" in 
    let topl_file_name = file_name^".topl" in 
    let (count_lta, reachable) = read_and_count_lta_filter lta_file_name in 
    let count_dfa = read_and_count_dfa dfa_file_name in 
    let count_topl = read_and_count_topl topl_file_name in 
    let () = Format.printf "LFA locs: %i\n"(fst count_lta)  in 
    let () = Format.printf "DFA locs: %i\n" count_dfa in 
    let () = Format.printf "TOPL locs: %i\n" count_topl in
      ()  *)

  let read_lta_dfa_topl_filter ~num_methods ~num_states ~folder =
    let file_name = 
      "foo-"^(string_of_int num_methods)^"-"^(string_of_int num_states) in 
    let file_name = folder^file_name in 
    let lta_file_name = file_name^"-lfa.json" in 
    let dfa_file_name = file_name^"-dfa.json" in 
    let topl_file_name = file_name^".topl" in 
    (* let (count_lta, reachable) = read_and_count_lta_filter lta_file_name in  *)
    let count_lfa = read_count_lfa lta_file_name in 
    let count_dfa = read_and_count_dfa dfa_file_name in 
    let count_topl = read_and_count_topl topl_file_name in 
    let () = Format.printf "#LFA: %i\n" count_lfa  in 
    let () = Format.printf "#DFA: %i\n" count_dfa in 
    let () = Format.printf "#TOPL: %i\n" count_topl in
      () 



  (* let read_lfa_dfa_topl_filter ~num_methods ~num_states ~folder =
    let file_name = 
      "foo-"^(string_of_int num_methods)^"-"^(string_of_int num_states) in 
    let file_name = folder^file_name in 
    let lta_file_name = file_name^"-lfa.json" in 
    let dfa_file_name = file_name^"-dfa.json" in 
    let topl_file_name = file_name^".topl" in 
    let (count_lta, reachable) = read_and_count_lta_filter lta_file_name in 
    let count_dfa = read_and_count_dfa dfa_file_name in 
    let count_topl = read_and_count_topl topl_file_name in 
    let () = Format.printf "LFA locs: %i\n"(fst count_lta)  in 
    let () = Format.printf "DFA locs: %i\n" count_dfa in 
    let () = Format.printf "TOPL locs: %i\n" count_topl in
      ()  *)

let time f x =
  let t = Sys.time() in
  let fx = f x in
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);
  fx

