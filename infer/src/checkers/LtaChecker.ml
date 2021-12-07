(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd
module F = Format
module L = Logging

module Label = String 

module Json = Yojson
module JsonUtil = Json.Basic.Util 


module Domain = LtaCheckerDomain.DomainSummary

module Summary = LtaCheckerDomain.Summary(Label)  
module Dom = LtaCheckerDomain.LtaSet(Label) 
module LtaSet = LtaCheckerDomain.LtaSet(Label)

(* type ltas = EmptyS | EnableS of LtaSet.t | DisableS of LtaSet.t  *)


module LtaMapDom = LtaCheckerDomain.LtaMap (AccessPath) (LtaCheckerDomain.LtaSet (Label)) 
module LtaMapSum = LtaCheckerDomain.LtaMap (AccessPath) (LtaCheckerDomain.Summary (Label)) 

module LtaDefMap = Caml.Map.Make(Label) 


let continue = Config.lta_continue 
(* let continue = true  *)

let _debug fmt = L.debug Analysis Verbose fmt

module TransferFunctions = struct
  (* module CFG = ProcCfg.OneInstrPerNode (ProcCfg.Normal)  *)
  module CFG = ProcCfg.Normal 
  module Domain = Domain

   type analysis_data = Domain.t InterproceduralAnalysis.t
  (* type analysis_data = unit  *)

(* let (--) i j = 
    let rec aux n acc =
    if n < i then acc else aux (n-1) (n :: acc)
    in aux j []  *)


let lta_properties_paths = Config.lta_properties 
(* let () = debug "LTA_PROPERTIES is: %i" lta_properties  *)
(* debug  *)
 
(* let is_active () = Config.is_checker_enabled Ltachecker && not (List.is_empty (Lazy.force lta_properties_paths)) *)
let is_active () = Config.is_checker_enabled Ltachecker && not (List.is_empty lta_properties_paths)


(* let cpp_proc_name  class_name _return_type proc_name = class_name^"::"^proc_name *)



type ltas_dict = {enable: LtaSet.t; disable: LtaSet.t} 


(* produce LtaDefMap *)
let json_to_lta json = 
  let lta_map = LtaDefMap.empty in 
  let class_name_bindings = json |>JsonUtil.to_assoc in 
  let (class_name, lta_json) = Caml.List.hd class_name_bindings in 
  let bindings = lta_json |> JsonUtil.to_assoc in 
  (* iterate over bindings *)
  let f_per_method json0 = 
    let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
    let enables = Caml.List.map (fun x -> JsonUtil.to_string x) en_json in
    let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
    let disables = Caml.List.map (fun x -> JsonUtil.to_string x) dis_json in
    let en_set = LtaSet.of_list enables in 
    let dis_set = LtaSet.of_list disables in 
      {enable = en_set; disable=dis_set} in 
  let f (method_name, json_per_method) lta_map0 = 
    let ltas = f_per_method json_per_method in 
    LtaDefMap.add method_name ltas lta_map0 in 
  (class_name, Caml.List.fold_right f bindings lta_map)


 (* read from file *)
 let lta_json = 
  if (is_active ()) then 
    Caml.Option.some (Json.Basic.from_file (Caml.List.hd lta_properties_paths)) 
  else 
    Caml.Option.none 

(* LtaDefMap should be map: Label -> {enable: LtaSet.t; disable: LtaSet.t} *)
(* let java_proc_name class_name return_type proc_name = 
  return_type^" "^class_name^"."^proc_name^"()" *)


(* let gen_proc_name = java_proc_name   *)

let init_pn = if (Config.infer_is_clang) then 
              "Foo::init"
else 
  "void Foo.init()"

(* let pn = gen_proc_name "Foo" "void" *)

(* let init_pn = pn "init"   *)

let (_class_name, lta) = 
  (match lta_json with 
  | Some json -> json_to_lta json
  | None -> ("empty", LtaDefMap.empty))  

let empty_ltas = {enable= LtaSet.empty; disable= LtaSet.empty}

let annons2set label = 
  let ltas_opt = LtaDefMap.find_opt label lta in 
  (match ltas_opt with 
  | None -> empty_ltas 
  | Some ltas -> ltas)

(* let annons2set label = get_lta_annon (fun x -> x) lta0 label  *)


  (* let annons2set label = 
    let pn = gen_proc_name "Foo" "void" in 
      match label with 
    | "void Foo.init()" -> EnableS (LtaSet.of_list [pn "foo1";
                                            pn "foo2"; 
                                            pn "foo3"]) 
    | (pn "foo1") -> EnableS (LtaSet.of_list [pn "bar1"]) 
    | "void Foo.foo2()" -> EnableS (LtaSet.of_list ["void Foo.bar2()"])
    | "void Foo.foo3()" -> EnableS (LtaSet.of_list ["void Foo.bar3()"])
    | "void Foo.foo4()" -> EnableS (LtaSet.of_list ["void Foo.bar4()"])
    | "void Foo.foo5()" -> EnableS (LtaSet.of_list ["void Foo.bar5()"])
    | "void Foo.foo6()" -> EnableS (LtaSet.of_list ["void Foo.bar6()"])
    | "void Foo.foo7()" -> EnableS (LtaSet.of_list ["void Foo.bar7()"])
    | "void Foo.foo8()" -> EnableS (LtaSet.of_list ["void Foo.bar8()"])
    | "void Foo.foo9()" -> EnableS (LtaSet.of_list ["void Foo.bar9()"])
    | "void Foo.foo10()" -> EnableS (LtaSet.of_list ["void Foo.bar10()"])
    | "void Foo.foo11()" -> EnableS (LtaSet.of_list ["void Foo.bar11()"])
    | "void Foo.foo12()" -> EnableS (LtaSet.of_list ["void Foo.bar12()"])
    | "void Foo.foo13()" -> EnableS (LtaSet.of_list ["void Foo.bar13()"])
    | "void Foo.foo14()" -> EnableS (LtaSet.of_list ["void Foo.bar14()"])
    | "void Foo.bar2()" -> DisableS (LtaSet.of_list ["void Foo.bar2()"])
    | _ -> EmptyS *)


  (* let counter = ref 0  *)
  (* let incr_counter = fun x -> counter := (!counter) + x  *)

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


  let apply_summary2 summary_map node astate ((pvar, _type1), arg_id) 
                                    (exp, typ2)  = 
    (* get access path of exp and apply it *) 
      let ap_test = AccessPath.of_pvar pvar typ2 in 
       (* apply summary *)
       let ap_exp_opt = get_access_path2 exp typ2 (arg_id+2) node in 
       let ap = (match ap_exp_opt with 
                  | None -> ap_test 
                  | Some ap -> ap) in 
      let sum1_opt = LtaMapSum.find_opt ap_test summary_map in 
      
      let sum1 = (match sum1_opt with 
                  | Some sum1 -> sum1 
                  | None -> Summary.empty) in 

      if (Caml.Option.is_none sum1_opt) then 
        astate 
    else 
      (* if (Summary.is_error sum1) then
        (* TODO: put Some {function} here, so we know this function cannot be applied, 
        there is an error in this function *)
        let label = (ap, (LtaSet.singleton "function")) in 
        let astate' = Domain.add_error_proc_names label astate in 
            astate' 
    else  *)
      let en_set = Summary.get_en sum1  in 
      let dis_set = Summary.get_dis sum1  in
      let pre_state = Summary.get_pre sum1 in 

      let dom_map = Domain.get_dom astate in


      (* apply summary
      let ap_exp_opt = get_access_path2 exp typ2 (arg_id+2) node in  *)

      (* let () = L.d_printfln "ap_exp_opt is: %a" AccessPath.pp ap_exp in  *)
      let () = L.d_printfln "ap is: %a" AccessPath.pp ap in 

      (* check if access path in  *)
      
      (match ap_exp_opt with 
      | Some ap_exp -> 
          (* APPLY SYMNART *)
          if (Summary.is_error sum1) then
                  (* TODO: put Some {function} here, so we know this function cannot be applied, 
                  there is an error in this function *)
                  let label = (ap, (LtaSet.singleton "function")) in 
                  let astate' = Domain.add_error_proc_names label astate in 
                      astate' 
              else 
          let dom_opt = LtaMapDom.find_opt ap_exp dom_map in 
          (* let astate' = Domain.add2 (ap_exp, pre_state) astate in  *)
          (match dom_opt with 
          | Some dom -> (* APPLY SUMMARY *)
                (* check transition first *)
                (* this should be regular apply summary *)
                let label = (ap_exp, pre_state) in 
                let (astate', b) = Domain.check_state label astate in 
                (* let b = Domain.check_state2 label astate in  *)
                (* let astate' = astate in  *)
                if (not b && not continue) then 
                  astate'
                else  
                  (* check if there is an error in summary we want to apply here *)
                  let label = (ap_exp, pre_state) in 
                  let astate' = Domain.transition_check label astate' in 
                  (* apply summary *)
                  (* if (Summary.is_error ) then  *)
                  let dom' = LtaSet.union en_set dom in 
                  let dom'' = LtaSet.diff dom' dis_set in 
                  let dom_map' = LtaMapDom.add ap_exp dom'' dom_map in 
                  (* ProcLabel update *)
                  (* let astate' = Domain.add2 (ap_exp, pre_state) astate in  *)
                  Domain.update_dom dom_map' astate'
          | None -> (* summary computation *)
             
                let () = L.d_printfln "In summary computation NONE" in 
                let () = L.d_printfln "ap_exp_opt is: %a" AccessPath.pp ap_exp in 

                (* if (is_this_ap ap_exp) then 
                  astate
                else  *)
                  let () = L.d_printfln "In summary computation NONE ELSE" in 
                  let sum_map0 = Domain.get_sum astate in 
                  let sum0_opt = LtaMapSum.find_opt ap_exp sum_map0 in 
                 
                  (match sum0_opt with 
                    | Some sum0 -> 
                      if (Summary.is_error sum0) then 
                        astate else 
                      if (Summary.is_error sum1) then
                        let sum' = Summary.error sum0 in 
                        let sum_map' = LtaMapSum.add ap_exp sum' sum_map0 in 
                        Domain.update_sum sum_map' astate
                    else
                        let () = L.d_printfln "In summary computation NONE ELSE SOME" in 
                        let en_set0 = Summary.get_en sum0 in 
                        let dis_set0 = Summary.get_dis sum0 in 
                        (* check pre *)
                        let b = LtaSet.disjoint pre_state dis_set0 in
                        if (not b) then 
                             let sum' = Summary.error sum0 in 
                             let sum_map' = LtaMapSum.add ap_exp sum' sum_map0 in 
                            Domain.update_sum sum_map' astate 
                      else 
                        let pre_state0 = Summary.get_pre sum0 in 
                        let sum' = Summary.empty in 
                        let sum' = Summary.add_pre_set (LtaSet.union (LtaSet.diff pre_state en_set0) pre_state0 ) sum' in 
                        let sum' = Summary.add_dis_set (LtaSet.diff (LtaSet.union dis_set dis_set0) en_set) sum' in 
                        let sum' = Summary.add_en_set (LtaSet.diff (LtaSet.union en_set0 en_set) dis_set) sum' in 
                        let () = L.d_printfln "Summary en set:" in 
                        let () = L.d_printfln "en_set0 is: %a, en_set is: %a" LtaSet.pp en_set0 LtaSet.pp en_set in 
                        let sum_map' = LtaMapSum.add ap_exp sum' sum_map0 in 
                        (* reset ProcLabel, check why ProcLabel is not empty at this point *)
                        (* let astate'' = Domain.reset2 astate' in   *)
                        Domain.update_sum sum_map' astate
                    | None -> 
                        let () = L.d_printfln "In summary computation NONE ELSE NONE" in 
                        let sum_map' = LtaMapSum.add ap_exp sum1 sum_map0 in 
                        Domain.update_sum sum_map' astate)
                )
      | None -> astate)


    (* access path of pvar *)
    (* let _apply_summary summary_map node astate (pvar, _typ1) (exp, typ2) = 
      (* get access path of exp and apply it *)
      let dom_map = Domain.get_dom astate in 
      let ap = AccessPath.of_pvar pvar typ2 in 
      let sum1_opt = LtaMapSum.find_opt ap summary_map in 
      let en_set = (match sum1_opt with 
                    | Some sum1 -> Summary.get_en sum1 
                    | None -> LtaSet.empty) in 
      let dis_set = (match sum1_opt with 
                    | Some sum1 -> Summary.get_dis sum1 
                    | None -> LtaSet.empty) in
      let pre_state = (match sum1_opt with 
                        | Some sum1 -> Summary.get_pre sum1
                        | None -> LtaSet.empty) in 

      (* apply summary *)
      let ap_exp_opt = get_access_path exp typ2 node in 
      
      (match ap_exp_opt with 
      | Some ap_exp -> 
          let dom_opt = LtaMapDom.find_opt ap_exp dom_map in 
          let astate' = Domain.add2 (ap_exp, pre_state) astate in 
          (match dom_opt with 
          | Some dom -> 
                let dom' = LtaSet.union en_set dom in 
                let dom'' = LtaSet.diff dom' dis_set in 
                let dom_map' = LtaMapDom.add ap_exp dom'' dom_map in 
                Domain.update_dom dom_map' astate'
          | None -> astate)
      | None -> astate) *)

  

  let summary_compute annotations sum_map proc_name ap =
      (* first check if error *)
      (* let counter = ref 0 in  *)
      (* let () = counter := 0 in  *)
      (* let incr_counter = fun x -> counter := (!counter) + x in  *)
      let () = L.d_printfln "In SUMMARY_COMPUTE" in 
      if (is_this_ap ap) then 
        sum_map 
      else 
        let () = L.d_printfln "In SUMMARY_COMPUTE ELSE" in 
        let sum_ap_opt = LtaMapSum.find_opt ap sum_map in 
        (match sum_ap_opt with 
        | None -> 
            (* initialize in summary *)
            let sum = Summary.empty in 
            let ltas_dict = annotations proc_name in 
            let en_labels = ltas_dict.enable in 
            let dis_labels = ltas_dict.disable in 
            let sum' =  Summary.add_en_set en_labels sum  in 
            let sum'' =  Summary.add_dis_set dis_labels sum' in 
            (* let sum' = (match (annotations proc_name) with 
                        | EnableS aset -> 
                            let () = incr_counter 1 in 
                              Summary.add_en_set aset sum  
                        | DisableS aset ->  
                            let () = incr_counter 1 in 
                              Summary.add_dis_set aset sum 
                        | EmptyS -> sum) in  *)
            let sum''' = Summary.add_pre proc_name sum'' in 
            LtaMapSum.add ap sum''' sum_map
        | Some sum -> 
          (* stop computing summary if there is None here, also report error *)
          if (Summary.is_error sum) then 
            let () = L.d_printfln "IN SUMMARY COMPUTE: IS NONE SO DO NOTHING!" in 
            sum_map 
          else 
            if (Summary.mem_pre_dis proc_name sum) then 
                let sum' = Summary.error sum in 
                LtaMapSum.add ap sum' sum_map 
            else  
              let sum' = 
                  if (Summary.mem_pre_en proc_name sum) then 
                    sum 
                  else 
                    Summary.add_pre proc_name sum in 
              let ltas_dict = annotations proc_name in 
              let en_labels = ltas_dict.enable in 
              let dis_labels = ltas_dict.disable in
              (* check if proc_name is in disable *)
                (* if (LtaSet.mem proc_name dis_labels) then 
                  Summary.error  *)
              let sum'' =  
                sum' |> Summary.add_en_set en_labels |> Summary.remove_dis_set en_labels in 
              let sum''' = 
                sum'' |> Summary.add_dis_set dis_labels |> Summary.remove_en_set dis_labels in 
              (* let sum'' = 
                (match (annotations proc_name) with 
                  | EnableS aset -> 
                    (* sum' |> Summary.add_en alist |> Summary.remove_dis alist  *)
                    sum' |> Summary.add_en_set aset |> Summary.remove_dis_set aset
                  | DisableS aset -> 
                    sum' |> Summary.add_dis_set aset |> Summary.remove_dis_set aset
                  | _ -> sum')  *)
              LtaMapSum.add ap sum''' sum_map) 

  let (--) i j = 
      let rec aux n acc =
        if n < i then acc else aux (n-1) (n :: acc)
      in aux j [] 

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
        (* let astate = Domain.reset2 astate in *)
        (* summary apply *)
        
        let (astate',b) = 
            (match analyze_dependency pn with 
            | Some (callee_proc_desc, callee_summary) ->  
                let callee_sum = Domain.get_sum callee_summary in
                (* check if empty *)
                if (LtaMapSum.is_empty callee_sum) then 
                  (astate, false) 
                else 
                  let formals = Procdesc.get_pvar_formals callee_proc_desc in 
                  let formals' = Caml.List.tl formals in 
                  let args' = Caml.List.tl args in 
                  let args_ids = 0--((Caml.List.length formals')-1) in
                  let formals_ids = Caml.List.combine formals' args_ids in 
                  (* let astate' = Domain.reset2 astate in  *)
                  let astate'' = Caml.List.fold_left2 (apply_summary2 callee_sum node) 
                                astate formals_ids args' in 
                  (astate'', true)
            | None -> (astate, false)) in 
        if (b) then 
          astate' 
      else 
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
              let dom_map = Domain.get_dom astate' in 
              (* let init_pn = "void Iterator2.init()" in  *)
              if (Procname.is_constructor pn || String.equal proc_name init_pn) then 
                (* initialize domain *)
                let () = L.d_printfln "INIT_PN is: %s" proc_name in 
                let ltas_dict = annons2set proc_name in 
                let en_labels = ltas_dict.enable in 
                let dom_map' = LtaMapDom.add ap en_labels dom_map in 
                (* let dom_map' = (match (annons2set proc_name) with 
                        | EnableS aset ->  LtaMapDom.add ap aset dom_map 
                        | DisableS _a ->  LtaMapDom.add ap Dom.empty dom_map  
                        | EmptyS -> LtaMapDom.add ap Dom.empty dom_map) in  *)
                (* let astate'' =  Domain.reset2 astate' in  *)
                let astate'' = astate' in 
                Domain.update_dom dom_map' astate''
              else 
                let dom_ap_opt = LtaMapDom.find_opt ap dom_map in 
                let astaten = (match dom_ap_opt with 
                | None -> 
                    let sum_map = Domain.get_sum astate' in 
                    let sum_map' = summary_compute annons2set sum_map proc_name ap in 
                    Domain.update_sum sum_map' astate' 
                | Some _ -> 
                      (* LTA transition here *)
                      let label = (ap, LtaSet.singleton proc_name) in 
                      let () =  L.d_printfln "IN LTA TRANSITION\n" in 
                      let () =  L.d_printfln "ASTATE' is: %a\n" Domain.pp astate' in 
                      let (astate'', b) = Domain.check_state label astate' in
                      (* let b = Domain.check_state2 label astate' in  *)
                      if (not b && not continue) then   
                        let () = L.d_printfln "CHECK IS False\n" in 
                         astate''
                      else 
                        let () = L.d_printfln "CHECK IS TRUE\n" in 
                        (* let                    *)
                        (* let label = (ap, LtaSet.singleton proc_name) in  *)
                        let astate0 = Domain.transition_check label astate'' in 
                        let ltas_dict = annons2set proc_name in 
                        let en_labels = ltas_dict.enable in 
                        let dis_labels = ltas_dict.disable in 
                        let f = fun dom -> Dom.union en_labels dom in 
                            let dom_map' = LtaMapDom.update ap (Caml.Option.map f) dom_map in 
                              let f = fun dom -> Dom.diff dom dis_labels in 
                              let dom_map'' = LtaMapDom.update ap (Caml.Option.map f) dom_map'  in 
                        Domain.update_dom dom_map'' astate0) 
                              in 
                astaten
              

      | _ -> let nodekind = CFG.Node.kind node in 
                match nodekind with 
                        | Stmt_node (Call str) -> 
                              let () = L.d_printfln "Node is: %s" str in 
                              (* Domain.reset2 astate *)
                              astate
                        | _ -> 
                        (* astate *)
                          Domain.reset2 astate 
                 


  let pp_session_name _node fmt = F.pp_print_string fmt "lta checker"
end


module Analyzer = AbstractInterpreter.MakeRPO (TransferFunctions)

let checker ({InterproceduralAnalysis.proc_desc; err_log} as analysis_data) =
   (* let counter = ref 0 in  *)
  let proc_name = Procdesc.get_proc_name proc_desc in
  let nodes = Procdesc.get_nodes proc_desc in
  let log_report _astate_pre astate_post loc _ = 
    let ltr = [Errlog.make_trace_element 0 loc "Write of unused value" []] in
    let message =  Domain.report_issue2 ~post:astate_post in 
    Reporting.log_issue proc_desc err_log ~loc ~ltr Ltachecker IssueType.ltachecker_error message in 
  let do_reporting node_id state = 
    let astate_set = state.AbstractInterpreter.State.post in
    let astate_pre = state.AbstractInterpreter.State.pre in 
    if (Domain.has_issue ~post:(astate_set)) then 
      (* should never fail since keys in the invariant map should always be real node id's *)
          (* let () = debug "LTA: HAS ISSUE astate_pre: %a, and astate_post: %a" Domain.pp astate_pre Domain.pp astate_set in  *)
      let node =
        List.find_exn
          ~f:(fun node -> Procdesc.Node.equal_id node_id (Procdesc.Node.get_id node))
          nodes
      in
        log_report astate_pre astate_set (ProcCfg.Exceptional.Node.loc node) proc_name 
  in
  let inv_map = Analyzer.exec_pdesc analysis_data ~initial:Domain.empty proc_desc in
  let result = Analyzer.compute_post analysis_data ~initial:Domain.empty proc_desc in 
  Analyzer.InvariantMap.iter do_reporting inv_map; 
  result 