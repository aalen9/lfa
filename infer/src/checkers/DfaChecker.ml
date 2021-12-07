(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd
module F = Format
module L = Logging
module Json = Yojson
module JsonUtil = Json.Basic.Util 

(* module B = Bitv *)

(* module _Label = String  *)
module Key = AccessPath 
module State = String 




module DomSum = DfaCheckerDomain.DomainSummary 

module StateSet = DfaCheckerDomain.DfaSet(State) 
(* module Domain = DfaCheckerDomain.DomainSummary *)


module Summary = DfaCheckerDomain.DfaMap (State) (DfaCheckerDomain.DfaSet (State))
(* module Summary = DfaCheckerDomain.DomainSummary.Summary  *)


(* module DfaMapDom = DfaCheckerDomain.DfaMap (Key) (Domain)  *)
module DfaMapDom = DfaCheckerDomain.DfaMap (Key) (DfaCheckerDomain.DfaSet(State) ) 

(* module DfaMapSum = DfaCheckerDomain.DfaMap (Key) (Summary)  *)
module DfaMapSum = DfaCheckerDomain.DfaMap (Key) (DfaCheckerDomain.DfaMap (State) (DfaCheckerDomain.DfaSet (State))) 

(* GENERATE DFA BEGIN *)


module LabelStateMap = PrettyPrintable.MakePPMonoMap (String) (String) 
module DfaDefMap = PrettyPrintable.MakePPMonoMap (String) (LabelStateMap)

(* module MapString = Caml.Map.Make(String)  *)
    

(* READ DFA FROM JSON *)
let dfa_properties_path = Config.dfa_properties 
let is_active () = Config.is_checker_enabled Dfachecker && not (List.is_empty dfa_properties_path)

 (* read from file *)
 let dfa_json = 
  if (is_active ()) then 
    Caml.Option.some (Json.Basic.from_file (Caml.List.hd dfa_properties_path)) 
  else 
    Caml.Option.none 

 

  (* init method name *)
  (* let java_proc_name class_name return_type proc_name = 
    return_type^" "^class_name^"."^proc_name^"()" *)
  
  
  (* let gen_proc_name = java_proc_name   *)
  
  (* let pn = gen_proc_name "Foo" "void" *)
  
  (* let init_pn = pn "init"  *)



  (* DFA read *)
let json_to_dfa dfa_json = 
  (* let bindings = dfa_json |> JsonUtil.to_assoc in  *)
  let init_state = dfa_json |> JsonUtil.member "init_state" |> JsonUtil.to_string in 
  let transitions = dfa_json |> JsonUtil.member "transitions" |> JsonUtil.to_assoc in 
  let f_per_state_map (label, to_state_json) dfa_state = 
    let to_state = to_state_json |> JsonUtil.to_string in 
    LabelStateMap.add label to_state dfa_state in 
  let f (state, state_json) dfa_map = 
    let bindings_per_state = state_json |> JsonUtil.to_assoc in 
    let dfa_state = LabelStateMap.empty in 
    let dfa_state =
        Caml.List.fold_right f_per_state_map bindings_per_state dfa_state in 
      DfaDefMap.add state dfa_state dfa_map in 
  let dfa_map = DfaDefMap.empty in 
  let dfa_map = Caml.List.fold_right f transitions dfa_map  in 
      (init_state, dfa_map)

let (init_state_name, dfa) = 
  (match dfa_json with 
  | Some json -> json_to_dfa json
  | None -> ("empty", DfaDefMap.empty))  

let debug fmt = L.debug Analysis Verbose fmt

module TransferFunctions = struct
  (* module CFG = ProcCfg.OneInstrPerNode (ProcCfg.Normal)  *)
  module CFG = ProcCfg.Normal 
  module Domain = DomSum 

   type analysis_data = Domain.t InterproceduralAnalysis.t
  (* type analysis_data = unit  *)


(* 2^n states *)
(* let dfa6 = gen_dfa 5 "q" "void Foo.foo" "void Foo.bar"  *)


let dfa0 = dfa

let get_start_state_dfa = init_state_name
let get_error_state_dfa = "error"
(* TODO:  this should also be in JSON file *)
let init_pn = if (Config.infer_is_clang) then 
  "Foo::init"
else 
"void Foo.init()"

let _is_state_error state = Int.equal (String.compare state get_error_state_dfa) 0 

let get_state_dfa state label dfa = 
  let labelStateOpt = DfaDefMap.find_opt state dfa in 
  match labelStateOpt with 
  | None -> get_error_state_dfa  
  | Some map1 -> 
      (match (LabelStateMap.find_opt label map1) with 
        | None -> get_error_state_dfa 
        | Some state -> state)


(* let counter = ref 0  *)
(* let incr_counter = fun x -> counter := (!counter) + x  *)



(* first try as a function *)

(* TODO *)
(* let dfa1_func =  *)


(* 
  let _annotations1 label = 
    match label with 
      | "A::foo1" -> DfaAnnon.DfaEnable ["A::bar1"] 
      | "A::foo2" -> DfaAnnon.DfaEnable ["A::bar2"]
      | "A::foo3" -> DfaAnnon.DfaDisable ["A::bar3"]
      | "A::A" -> DfaAnnon.DfaEnable ["A::foo1";"A::foo2";"A::foo3";"A::bar3"] 
      | _ -> DfaAnnon.DfaEmpty 

  (* java test *)
   (* let init_pn = "void Iterator2.init()" *)
  let _annotations2 label = 
    match label with 
    | "void Iterator2.init()" -> DfaAnnon.DfaEnable ["boolean Iterator2.hasNext2()"; "void Iterator2.getInfo()"]
    | "boolean Iterator2.hasNext2()" -> DfaAnnon.DfaEnable ["void Iterator2.next2()"]
    | "void Iterator2.next2()" ->  DfaAnnon.DfaDisable ["void Iterator2.next2()"] 
    | _ -> DfaAnnon.DfaEmpty

  (* java test procedura summaries *)
  let init_pn = "void Foo.init()"
  let annotations2 label = 
    match label with 
    | "void Foo.init()" -> DfaAnnon.DfaEnable ["void Foo.foo1()";
                                            "void Foo.foo2()"; 
                                            "void Foo.foo3()"] 
    | "void Foo.foo1()" -> DfaAnnon.DfaEnable ["void Foo.bar1()"] 
    | "void Foo.foo2()" -> DfaAnnon.DfaEnable ["void Foo.bar2()"]
    | "void Foo.foo3()" -> DfaAnnon.DfaEnable ["void Foo.bar3()"]  
    | "void Foo.bar1()" -> DfaAnnon.DfaDisable ["void Foo.bar1()"]  
    | "void Foo.bar2()" -> DfaAnnon.DfaDisable ["void Foo.bar2()"]
    | "void Foo.bar3()" -> DfaAnnon.DfaDisable ["void Foo.bar3()"]
    | _ -> DfaAnnon.DfaEmpty  *)


  (* get rcv_id
  (* this should only work for pointers, that is Var, not LVar *)
  let rec _get_base_rcv_id exp =
    match exp with 
    | Exp.Lfield (exp0,_,_) -> get_base_rcv_id exp0  
    | Exp.Var x -> x 
    | Exp.Lvar _x -> Ident.create_none () 
    | _ -> Ident.create_none () *)


  (* get access list from exp : Lfield *)
  (* return pair (access_list, Option base pvar) *)
  let rec get_access_list0 access_list exp0 = 
    match exp0 with 
    | Exp.Lfield (exp1, name, _typ) -> 
          let access = AccessPath.FieldAccess name in 
          get_access_list0 (List.cons access access_list) exp1 
    | Exp.Lvar pvar -> (access_list, Caml.Option.Some pvar) 
    | _ -> (access_list, Caml.Option.None)

  (* return access list *)
  let get_access_list exp0 = get_access_list0 [] exp0 

  (* return option exp *)
  let get_caller rcv_id node = 
    let instrs_node = CFG.instrs node in 
    let instrs_array = Instrs.get_underlying_not_reversed instrs_node in 
    match (Caml.Array.get instrs_array 0) with 
      |  Load {id = id; e=exp; root_typ = _root_typ; typ = _typ;_} -> 
          if (Ident.equal rcv_id id) then 
            Caml.Option.some exp
          else 
             Caml.Option.None 
      | _ -> Caml.Option.None 


  (* access path for multiple arguments for summary apply *)
  let get_caller2 rcv_id arg_id node = 
    let instrs_node = CFG.instrs node in 
    let instrs_array = Instrs.get_underlying_not_reversed instrs_node in 
    (* let () = L.d_printfln "GET_CALLER2:" in  *)
    (* let () = L.d_printfln "rcv id is: %a" Ident.pp rcv_id in  *)
    (* let () = L.d_printfln "arg_id: %i" arg_id in  *)
    (* let () = debug "Instrs array is: %a" (Instrs.pp Pp.text) instrs_array in  *)
    let () = L.d_printfln "Instruction is: %a" (Sil.pp_instr ~print_types:true Pp.text)
                    (Caml.Array.get instrs_array arg_id)  in 
    match (Caml.Array.get instrs_array arg_id) with 
      |  Load {id = id; e=exp; root_typ = _root_typ; typ = _typ;_} -> 
          if (Ident.equal rcv_id id) then 
            Caml.Option.some exp
          else 
             Caml.Option.None 
      | _ -> Caml.Option.None 

  (* let get_access_path2 exp0 typ0 node =  *)

    (* return option access_path *)
  let get_access_path2 exp0 typ0 arg_id node = 
    let () = L.d_printfln "get_access_path2:" in 
    let () = L.d_printfln "exp0 is: %a" Exp.pp exp0 in 
    let exp1 = match exp0 with 
    | Exp.Var rcv_id -> get_caller2 rcv_id arg_id node 
    | exp2 ->  Caml.Option.Some exp2 in
    (* | _ -> Caml.Option.None in  *)
    match exp1 with 
    | Caml.Option.Some (Exp.Lfield (_exp1, _name, _typ)) ->      
      let (access_list, pvar_opt) = get_access_list exp0 in 
      let pvar = Caml.Option.get pvar_opt in   (* exception here *)
      let base = AccessPath.of_pvar pvar typ0 in 
      let access_path = AccessPath.append base access_list in 
      Caml.Option.some access_path 
    | Caml.Option.Some (Exp.Lvar pvar) -> 
        let base = AccessPath.of_pvar pvar typ0 in 
        Caml.Option.some base 
    | _ -> Caml.Option.None 


  (* return option access_path *)
  let get_access_path exp0 typ0 node = 
    let exp1 = match exp0 with 
    | Exp.Var rcv_id -> get_caller rcv_id node 
    | exp2 ->  Caml.Option.Some exp2 in
    (* | _ -> Caml.Option.None in  *)
    match exp1 with 
    | Caml.Option.Some (Exp.Lfield (_exp1, _name, _typ)) ->      
      let (access_list, pvar_opt) = get_access_list exp0 in 
      let pvar = Caml.Option.get pvar_opt in   (* exception here *)
      let base = AccessPath.of_pvar pvar typ0 in 
      let access_path = AccessPath.append base access_list in 
      Caml.Option.some access_path 
    | Caml.Option.Some (Exp.Lvar pvar) -> 
        let base = AccessPath.of_pvar pvar typ0 in 
        Caml.Option.some base 
    | _ -> Caml.Option.None 


  (* check if ap is this *)
  let is_this_ap ap = 
    match ap with 
    | ((var, _typ), _access) -> Var.is_this var 
    (* | _ -> false  *)


  (* return bool *)
  let _is_this rcv_id node = 
    let instrs_node = CFG.instrs node in 
    let instrs_array = Instrs.get_underlying_not_reversed instrs_node in 
    let _count_instrs = Caml.Array.length instrs_array in 
    (* print first instruction *)
    let instr_str = F.asprintf "Instruction 0 is: %a" (Sil.pp_instr ~print_types:true Pp.text) (Caml.Array.get instrs_array 0) in
    let () = L.d_printfln "Instruction 0 is: %s" instr_str in 
    match (Caml.Array.get instrs_array 0) with 
      | Load {id = id; e=exp; root_typ = _root_typ; typ = _typ;_} ->
          let () = L.d_printfln "Ident is: %a" Ident.pp id in 
          let () = L.d_printfln "Expression is: %a" Exp.pp exp in 
          (Ident.equal rcv_id id) && (Exp.is_this exp)
      | _ -> false 


  let (--) i j = 
      let rec aux n acc =
        if n < i then acc else aux (n-1) (n :: acc)
      in aux j [] 

  let apply_summary2 summary_map node astate ((pvar, _type1), arg_id) 
                                    (exp, typ2)  = 
    (* get access path of exp and apply it *)
      let dom_map = DomSum.get_dom astate in 
      let ap = AccessPath.of_pvar pvar typ2 in 
      L.d_printfln "APPLY SUMMARY2 ap is: %a" AccessPath.pp ap; 
      L.d_printfln "APPLY SUMMARY2 Summary map is: %a\n" DfaMapSum.pp summary_map; 
      let sum1_opt = DfaMapSum.find_opt ap summary_map in 
      (* let en_set = (match sum1_opt with 
                    | Some sum1 -> Summary.get_en sum1 
                    | None -> DfaSet.empty) in 
      let dis_set = (match sum1_opt with 
                    | Some sum1 -> Summary.get_dis sum1 
                    | None -> DfaSet.empty) in
      let pre_state = (match sum1_opt with 
                        | Some sum1 -> Summary.get_pre sum1
                        | None -> DfaSet.empty) in  *)

      let sum1 = (match sum1_opt with 
                  | Some sum1 -> sum1 
                  | None -> Summary.empty) in 
        
      if (Summary.is_empty sum1) then 
        let ()= L.d_printfln "APPLY SUMMARY 2: return astate is: %a" Domain.pp astate in 
        astate
    else 

      (* APPLY SUMMARY *)
      let ap_exp_opt = get_access_path2 exp typ2 (arg_id+2) node in 

      (* let () = L.d_printfln "ap_exp_opt is: %a" AccessPath.pp ap_exp in  *)
      let () = L.d_printfln "ap is: %a" AccessPath.pp ap in 

      (* check if access path in  *)

      let get_states_in_sum sum state = 
        let stateset_opt = Summary.find_opt state sum in 
        (match stateset_opt with
        | None -> StateSet.singleton get_error_state_dfa 
        | Some stateset -> stateset) in 
      
      (match ap_exp_opt with 
      | Some ap_exp -> 
          let dom_opt = DfaMapDom.find_opt ap_exp dom_map in 
          (* let astate' = Domain.add2 (ap_exp, pre_state) astate in  *)
          (match dom_opt with 
          | Some dom -> 
                (* SUMMARY APPLY  *)
                (* let label = proc_name in  *)
                (* let f label state stateset' = 
                  (let stateset = get_states_in_sum sum1 label in 
                  StateSet.union stateset stateset') in  *)
                (* let f state stateset' = 
                  let stateset = get_states_in_sum sum1 state in 
                  StateSet.union stateset stateset' in  *)
                  let f state stateset' = 
                    if (StateSet.mem "error" stateset') then 
                      StateSet.singleton "error" else 
                    if (StateSet.mem "error_handled" stateset') then 
                      StateSet.singleton "error_handled" else 
              
                    let stateset = get_states_in_sum sum1 state in 
                    if (StateSet.mem "all_error" stateset) then 
                      StateSet.singleton "error" else 
                    StateSet.union stateset stateset' in 
                let transition stateset = 
                  (* if (StateSet.mem "error" stateset) then 
                    StateSet.singleton "error" 
                    stateset  *)
                     (* if (StateSet.mem "error" stateset || StateSet.mem "error_handled" stateset) then 
                        StateSet.singleton "error"  *)
                    if (StateSet.mem "error" stateset) then 
                        StateSet.singleton "error"  else 
                    if (StateSet.mem "error_handled" stateset) then 
                        StateSet.singleton "error_handled"  else 
                    if (StateSet.is_empty stateset) then 
                      StateSet.singleton "error" 
                else 
                  let set1 = StateSet.fold f stateset StateSet.empty in 
                  if (StateSet.mem "error" set1 || StateSet.is_empty set1) then 
                    StateSet.singleton "error" else 
                      set1 in 
                let dom' = transition dom in 
                let dom_map' = DfaMapDom.add ap_exp dom' dom_map in
                let astate' =   DomSum.update_dom dom_map' astate in 
                let ()= L.d_printfln "APPLY SUMMARY 2: return astate is: %a" Domain.pp astate' in
                        astate'
                (* DomSum.update_dom dom_map' astate *)
          | None -> (* SUMMARY COMPUTATIONS *) 
                let () = L.d_printfln "In summary computation NONE" in 
                let () = L.d_printfln "ap_exp_opt is: %a" AccessPath.pp ap_exp in 

                (* if (is_this_ap ap_exp) then 
                  astate
                else  *)
                  (* let label = ap_exp in  *)
                  let () = L.d_printfln "In summary computation NONE ELSE" in 
                  let sum_map0 = DomSum.get_sum astate in 
                  let sum0_opt = DfaMapSum.find_opt ap_exp sum_map0 in 
                  (match sum0_opt with 
                    (* TODO: summary computations *)
                    (* summary to summary *)
                    (* use sum1 to compute sum0 *)
                    | Some sum0 -> 
                      if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum0) then 
                          let transition_all_error  _stateset = 
                            StateSet.singleton "all_error" in 
                        let sum' = Summary.map transition_all_error sum0 in 
                        let sum_map' = DfaMapSum.add ap_exp sum' sum_map0 in 
                          DomSum.update_sum sum_map' astate
                      else 
                      if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum1) then 
                        (* transition all error *)
                        let transition_all_error  _stateset = 
                          StateSet.singleton "all_error" in 
                          let sum' = Summary.map transition_all_error sum0 in 
                          let sum_map' = DfaMapSum.add ap_exp sum' sum_map0 in 
                             DomSum.update_sum sum_map' astate
                      else 
                        let () = L.d_printfln "In summary computation NONE ELSE SOME" in 
                        let f state stateset' = 
                          if (StateSet.mem "error" stateset') then 
                              StateSet.singleton "error"  
                          (* StateSet.empty  *)
                          else 
                              (let stateset = get_states_in_sum sum1 state in 
                              (* L.d_printfln "State is: %s\n" state;  *)
                              (* L.d_printfln "Statset is: %a\n" StateSet.pp stateset;  *)
                                  StateSet.union stateset stateset') in
                        let error_stop = ref true in 
                        L.d_printfln "sum1 is: %a\n" Summary.pp sum1; 
                        let transition stateset = 
                             if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
                              (* StateSet.singleton "error"  *)
                             StateSet.empty 
                            else 
                              let () = error_stop := false in 
                              StateSet.fold f stateset StateSet.empty in 
                        let sum' = Summary.map transition sum0 in 
                        let transition_all_error  _stateset = 
                          StateSet.singleton "all_error" in 
                        let sum'' = if (!error_stop) then 
                          Summary.map transition_all_error sum0 
                      else 
                          sum' in 
                        let sum_map' = DfaMapSum.add ap_exp sum'' sum_map0 in 
                        let astate' = DomSum.update_sum sum_map' astate in 
                        let ()= L.d_printfln "APPLY SUMMARY 2: return astate is: %a" Domain.pp astate' in
                        astate'  
                   (* DomSum.update_sum sum_map' astate *)
                    | None -> 
                        let () = L.d_printfln "In summary computation NONE ELSE NONE" in 
                        let sum_map' = DfaMapSum.add ap_exp sum1 sum_map0 in 
                        let astate' =  DomSum.update_sum sum_map' astate in 
                        let ()= L.d_printfln "APPLY SUMMARY 2: None return astate is: %a" Domain.pp astate' in
                          (* DomSum.update_sum sum_map' astate *)
                          astate' 
                          )
                )
      | None -> 
        let ()= L.d_printfln "APPLY SUMMARY 2: None2 return astate is: %a" Domain.pp astate in
        astate)


   
  let summary_compute annotations sum_map proc_name ap loc =
      (* first check if error *)
      let is_state_error state = Int.equal (String.compare state get_error_state_dfa) 0 in
      let () = L.d_printfln "In SUMMARY_COMPUTE" in 
      if (is_this_ap ap) then 
        sum_map 
      else 
        let () = L.d_printfln "In SUMMARY_COMPUTE ELSE" in 
        let () = L.d_printfln "sum_map is: %a" DfaMapSum.pp sum_map in 
        let () = L.d_printfln "Access path is: %a" AccessPath.pp ap in 
        let sum_ap_opt = DfaMapSum.find_opt ap sum_map in 
        (match sum_ap_opt with 
        | None -> 
            (* initialize in summary *)
            (* REVIEW: za svaki state u sum-u treba  *)

              (* sta u pocetku treba da bude? u pocetku treba da bude taj state *)
              (* initialize with state -> state map *)
            let _sum = Summary.empty in 
            (* get states from annotations map *)
            (* napravi novu mapu *)
            (* use mapi for this *)
            (* let f key _value = StateSet.singleton key in 
            let init_sum = Summary.mapi f annotations in  *)

            let f key _state map' = 
              Summary.add key (StateSet.singleton key) map' in 
            let init_sum = DfaDefMap.fold f annotations Summary.empty in 
            let f label state = 
              (* let () = incr_counter 1 in  *)
              get_state_dfa state label annotations in 
            let error_stop = ref true in 
          
            let transition label stateset = 
              (* if (StateSet.mem "error" stateset) then 
                StateSet.singleton "error"   *)
                 if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
                        StateSet.singleton "error" 
                  (* StateSet.empty  *)
                else 
                  let set1 = StateSet.map (f label) stateset in
                  if (StateSet.exists is_state_error set1) then 
                    let () = debug "ERROR CHECK IS CALLED AND SHOULD BE EMPTY\n" in
                    (* let () = F.printf "error empty set\n" in    *)
                    (* StateSet.singleton "error"  *)
                    StateSet.empty 
                else 
                  let () = error_stop := false in
                  set1 in 
          (* let () = if (!error_stop) then 
            F.printf "STOPED AT LINE INITIALIZE: %a\n" Location.pp loc 
            else 
              () in  *)
            (* print annotations *)
            (* let () = L.d_printfln "DFA MAP IS: %a" DfaDefMap.pp annotations in  *)
            let sum' = Summary.map (transition proc_name) init_sum in 
            let () = if (!error_stop) then 
              F.printf "STOPED AT LINE INITIALIZE: %a\n" Location.pp loc 
              else 
                () in 
                let transition_all_error _label _stateset = 
                  StateSet.singleton "all_error" 
                in 
            let sum' = if (!error_stop) then 
                Summary.map (transition_all_error proc_name) init_sum 
            else 
              sum' in 
              DfaMapSum.add ap sum' sum_map
        | Some sum -> 
           let error_stop = ref false in
             let () = L.d_printfln "In SUMMARY_COMPUTE ELSE Some sum" in 
             (* let () = F.printf "SUMMARY COMPUTE ELSE\n" in  *)
             (* let () = debug "SUMMARY_COMPUTE ELSE" in  *)
            (* TODO: for each state in set in sum transition *)
            (* sum : State -> Set State *)
            (* za svaki state ovde, koji na pocetku treba da bude svaki 
              state u  *)
              if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum) then 
                sum_map
              else 
            let _f label astate = 
              (* if (StateSet.mem "error" state) then 
                (* StateSet.singleton "error"  *)
              (* let () = F.printf "error empty set 3\n" in  *)
                  state  
                else  *)
              (* let () = incr_counter 1 in *)
              get_state_dfa astate label annotations in 
            let f2 label state astate =
              if (StateSet.mem "error" astate) then 
                (* StateSet.singleton "error"  *)
              (* let () = F.printf "error empty set 3\n" in  *)
                  astate  
                else 
                  let state' = get_state_dfa state label annotations in 
                  StateSet.add state' astate in 
            (* let is_error = ref false in  *)
            let () = error_stop := true in 
            let transition label stateset =
              (* if (StateSet.mem "error" stateset) then 
                (* let () = is_error := (!is_error && true) in   *)
                (* stateset  *)
                StateSet.singleton "error"  *)
                 if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
                        (* StateSet.singleton "error"  *)
                 StateSet.empty 
                 (* let () = F.printf "error empty set1 \n" in   *)
                  (* stateset *)
                  (* StateSet.empty  *)
                else 
              (* let error_stop = ref true in  *)
              (* let () = error_stop := true in  *)
              (* if all errors then stop, or just print the line loc *)
              (* let set1=StateSet.map (f label) stateset in *)
              (* ako jedna nije error onda error_stop stavi na false *)
              let set1 = StateSet.fold (f2 label) stateset StateSet.empty in 
                (* NEW BEGIN *)
              if (StateSet.mem "error" set1) then 
                (* if (StateSet.exists is_state_error set1) then  *)
                  let () = debug "ERROR CHECK IS CALLED AND SHOULD BE EMPTY\n" in
                  (* let () = F.printf "error empty set\n" in    *)
                  StateSet.empty 
              else 
                let () = error_stop := false in
                set1 in 
              (* NEW END *)
            let sum' = Summary.map (transition proc_name) sum in 
            let () = if (!error_stop) then 
              F.printf "STOPED AT LINE: %a\n" Location.pp loc 
              else 
                () in 
                let transition_all_error _label _stateset = 
                  StateSet.singleton "all_error" 
                in 
            let sum' = if (!error_stop) then 
                Summary.map (transition_all_error proc_name) sum' 
            else 
              sum' in 
            (* let () = if (!is_error) then  *)
                  (* L.d_printfln "IS ERROR IS TRUE" 
              else 
                 L.d_printfln "IS ERROR IS FALSE" in  *)
            (* TODO: sta ako treba da iskoristimo sum za compute sum? *)
            DfaMapSum.add ap sum' sum_map) 


  (* let (--) i j = 
      let rec aux n acc =
        if n < i then acc else aux (n-1) (n :: acc)
      in aux j []  *)

  let exec_instr astate {InterproceduralAnalysis.proc_desc= _; tenv= _; 
                  analyze_dependency=analyze_dependency; _} node _id instr =
    let _node_description = 
      Procdesc.Node.get_description (Pp.html Black) 
        (CFG.Node.underlying_node node) in 

    match instr with 
    | Sil.Call ((_ret_id, ret_typ), Exp.Const (Const.Cfun pn), args, _, _) -> 
      if (not (is_active ())) then 
        astate 
      else 
        let _class_name0_opt = Procname.get_class_name pn in 
        (* SUMMARY APPLY  *)
        (* kada je summary apply? a kada je samo obican call? *)
        (* let () = L.d_printfln "SPOLJA: astate is: %a" DomSum.pp astate in  *)
        (* let astate' = 
            (match analyze_dependency pn with 
            | Some (callee_proc_desc, callee_summary) -> 
                 let () = L.d_printfln "We are in Some analyze_dependency" in 
                (* TODO: CHECK THIS *)
                let callee_sum = DomSum.get_sum callee_summary in 
                if (DfaMapSum.is_empty callee_sum) then 
                  astate 
                else 
                  let formals = Procdesc.get_pvar_formals callee_proc_desc in 
                  let formals' = Caml.List.tl formals in 
                  let args' = Caml.List.tl args in 
                  let args_ids = 0--((Caml.List.length formals')-1) in
                  let formals_ids = Caml.List.combine formals' args_ids in
                  let astate'' = Caml.List.fold_left2 (apply_summary2 callee_sum node) 
                                astate formals_ids args' in 
                  astate'' 
            | None -> astate) in  *)
       let (astate', b) = (match analyze_dependency pn with 
            | Some (callee_proc_desc, callee_summary) -> 
                 let () = L.d_printfln "We are in Some analyze_dependency" in 
                (* TODO: CHECK THIS *)
                let callee_sum = DomSum.get_sum callee_summary in 
                if (DfaMapSum.is_empty callee_sum) then 
                  (astate, false) 
                else 
                  let formals = Procdesc.get_pvar_formals callee_proc_desc in 
                  let formals' = Caml.List.tl formals in 
                  let args' = Caml.List.tl args in 
                  let args_ids = 0--((Caml.List.length formals')-1) in
                  let formals_ids = Caml.List.combine formals' args_ids in
                  let astate'' = Caml.List.fold_left2 (apply_summary2 callee_sum node) 
                                astate formals_ids args' in 
                  (astate'', true)
            | None -> (astate, false)) in 
            if (b) then 
              let () = L.d_printfln "INSTR CALL: CALL APPLY SUMMARY\n" in 
              let () = L.d_printfln "astate' is: %a\n" Domain.pp astate' in 
              astate' 
          else 
            let () = L.d_printfln "INSTR CALL: NOT APPLU SUMMARY\n" in 
        let proc_name = Procname.to_string pn in 
        let () = L.d_printfln "procedure name is %s" proc_name in 
        let arg0opt =  (List.hd args) in 
        let class_proc = ref true in 
        let (exp1, typ0) = (match arg0opt with 
                              | Some (exp1, typ1) -> (exp1, typ1) 
                              | None -> let () = class_proc := false
                                            in (Exp.zero, ret_typ)) in 
        if (not !class_proc) then 
          let () = L.d_printfln "it is not a class proc" in 
          astate'
        else 
          let access_path_opt =  get_access_path exp1 typ0 node in 
            if (Caml.Option.is_none access_path_opt) then 
              let () = L.d_printfln "we cannot get an access path" in 
              astate'
            else 
              let ap = Caml.Option.get access_path_opt in
              let () = L.d_printfln "access path is: %a" AccessPath.pp ap in 
              (* TODO: Ovde treba da ide implementacija za DFA *)
              let dom_map = DomSum.get_dom astate' in 
              if (Procname.is_constructor pn || String.equal proc_name init_pn) then 

                (* INITIALIZE DOMAIN FOR THIS ACCESS PATH *)
                (* for DFA this should be start state *)
                let start_state = get_start_state_dfa in 

                (* initialize singleton set *)
                let state_set = StateSet.singleton start_state in 
                let dom_map' = DfaMapDom.add ap state_set dom_map in 
                  DomSum.update_dom dom_map' astate'
              else 
                let dom_ap_opt = DfaMapDom.find_opt ap dom_map in 
                let astaten = (match dom_ap_opt with 
                | None -> 
                    (* astate'  *)
                    (* let () = L.d_printfln "SPOLJA: astate is: %a" DomSum.pp astate' in  *)
                    let sum_map = DomSum.get_sum astate' in 
                    let sum_map' = summary_compute dfa0 sum_map proc_name ap (Procdesc.Node.get_loc node) in 
                    (* let () = L.d_printfln "Summary compute COUNTER is: %i" !counter in  *)
                     DomSum.update_sum sum_map' astate'
                | Some dom -> 
                    (* REVIEW: check this later, what is proc_name *)
                    let label = proc_name in 
                    (* for each state in dom transition it *)
                    let f = fun state -> get_state_dfa state label dfa0 in 
                    (* continue *)
                    (* let  dom = 
                    if (StateSet.mem "error" dom) then 
                      StateSet.remove "error" dom 
                    else 
                      dom
                    in  *)
                    (* let dom' = StateSet.map f dom in *)
                    (* not continue *)
                    let dom' = 
                      if (StateSet.mem "error" dom || StateSet.mem "error_handled" dom) then 
                        StateSet.singleton "error_handled" 
                        (* CHECK THIS *)
                        (* dom  *)
                      else 
                        StateSet.map f dom in
                     let dom_map' = DfaMapDom.add ap dom' dom_map in 
                    DomSum.update_dom dom_map' astate') in 
                astaten

      | _ -> let nodekind = CFG.Node.kind node in 
                match nodekind with 
                        | Stmt_node (Call str) -> 
                              let () = L.d_printfln "Node is: %s" str in 
                              astate 
                        | _ -> 
                          L.d_printfln "INSIDE OTHER DOMAIN RESET2"; 
                        (* astate *)
                        DomSum.reset2 "error" "error_handled" astate 
                 


  let pp_session_name _node fmt = F.pp_print_string fmt "dfa checker"
end




module Analyzer = AbstractInterpreter.MakeRPO (TransferFunctions)

let checker ({InterproceduralAnalysis.proc_desc; err_log} as analysis_data) =
  let proc_name = Procdesc.get_proc_name proc_desc in
  let nodes = Procdesc.get_nodes proc_desc in
  let get_error_state_dfa = "error" in 
  let is_state_error state = Int.equal (String.compare state get_error_state_dfa) 0 in
  let log_report astate_pre astate_post loc _ = 
    let ltr = [Errlog.make_trace_element 0 loc "Write of unused value" []] in
    let message = 
      DomSum.report_issue2 ~is_state_error:is_state_error ~pre:astate_pre ~post:astate_post in 
    Reporting.log_issue proc_desc err_log ~loc ~ltr Dfachecker IssueType.dfachecker_error message in 
  let do_reporting node_id state = 
    let astate_set = state.AbstractInterpreter.State.post in
    let astate_pre = state.AbstractInterpreter.State.pre in 
    if (DomSum.has_issue ~is_state_error:is_state_error ~pre:(astate_pre) ~post:(astate_set)) then 
      (* should never fail since keys in the invariant map should always be real node id's *)
          (* let () = debug "DFA: HAS ISSUE astate_pre: %a, and astate_post: %a" Domain.pp astate_pre Domain.pp astate_set in  *)
      let node =
        List.find_exn
          ~f:(fun node -> Procdesc.Node.equal_id node_id (Procdesc.Node.get_id node))
          nodes
      in
        log_report astate_pre astate_set (ProcCfg.Exceptional.Node.loc node) proc_name 
  in
  let inv_map = Analyzer.exec_pdesc analysis_data ~initial:DomSum.empty proc_desc in
  let result = Analyzer.compute_post analysis_data ~initial:DomSum.empty proc_desc in 
  Analyzer.InvariantMap.iter do_reporting inv_map; 
  result 