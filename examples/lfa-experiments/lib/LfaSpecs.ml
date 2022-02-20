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



let read_and_count_lta_filter file_path =
  let lta = read_lta file_path in 
  let (lta1, reachable) = filter_lta lta in 
  (count_lta_loc lta1, reachable) 




  let read_lta_dfa_topl_filter ~num_methods ~num_states ~folder =
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
      () 



let time f x =
  let t = Sys.time() in
  let fx = f x in
  Printf.printf "Execution time: %fs\n" (Sys.time() -. t);
  fx

