(*
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd
module F = Format
module L = Logging


module Label = String 

module Json = Yojson
module JsonUtil = Json.Basic.Util 


module Domain = LfaCheckerDomain.DomainSummary

module Summary = LfaCheckerDomain.Summary(Label)  
module LfaSet = LfaCheckerDomain.LfaSet(Label)

module LfaMapSum = LfaCheckerDomain.LfaMap (AccessPath) (LfaCheckerDomain.Summary (Label)) 

module LfaDefMap = Caml.Map.Make(Label) 


let continue = Config.lfa_continue 
(* let continue = true  *)

let error_reporting = not Config.lfa_no_error_reporting 


let _debug fmt = L.debug Analysis Verbose fmt

module TransferFunctions = struct
  (* module CFG = ProcCfg.OneInstrPerNode (ProcCfg.Normal)  *)
  module CFG = ProcCfg.Normal 
  module Domain = Domain

   type analysis_data = Domain.t InterproceduralAnalysis.t
  (* type analysis_data = unit  *)

  (* let init_pn = get_init_pn () 
  let () = F.printf "INIT PN IS: %s" init_pn   *)

(* let (--) i j = 
    let rec aux n acc =
    if n < i then acc else aux (n-1) (n :: acc)
    in aux j []  *)


let lfa_properties_paths = Config.lfa_properties 
let is_active_c = Config.is_checker_enabled Lfachecker && not (List.is_empty lfa_properties_paths)
let is_active = ref is_active_c 

(* let cpp_proc_name  class_name _return_type proc_name = class_name^"::"^proc_name *)

type lfas_dict = {enable: LfaSet.t; disable: LfaSet.t} 


(* produce LfaDefMap *)
let json_to_lfa json = 
  let lfa_map = LfaDefMap.empty in 
  let class_name_bindings = json |>JsonUtil.to_assoc in 
  let (class_name, lfa_json) = Caml.List.hd class_name_bindings in 
  let bindings = lfa_json |> JsonUtil.to_assoc in 
  (* iterate over bindings *)
  let f_per_method json0 = 
    let en_json = json0 |> JsonUtil.member "enable" |> JsonUtil.to_list in 
    let enables = Caml.List.map (fun x -> JsonUtil.to_string x) en_json in
    let dis_json = json0 |> JsonUtil.member "disable" |> JsonUtil.to_list in 
    let disables = Caml.List.map (fun x -> JsonUtil.to_string x) dis_json in
    let en_set = LfaSet.of_list enables in 
    let dis_set = LfaSet.of_list disables in 
      {enable = en_set; disable=dis_set} in 
  let f (method_name, json_per_method) lfa_map0 = 
    let lfas = f_per_method json_per_method in 
    LfaDefMap.add method_name lfas lfa_map0 in 
  (class_name, Caml.List.fold_right f bindings lfa_map)

  (* let contains s1 s2 =
    let re = Str.regexp_string s2
    in
      try ignore (Str.search_forward re s1 0); true
      with _e -> false *)



(* read from file *)
let lfa_json = 
if (!is_active) then 
  Caml.Option.some (Json.Basic.from_file (Caml.List.hd lfa_properties_paths)) 
else 
  Caml.Option.none 


let (_class_name, lfa) = 
  (match lfa_json with 
  | Some json -> json_to_lfa json
  | None -> ("empty", LfaDefMap.empty))  

let empty_lfas = {enable= LfaSet.empty; disable= LfaSet.empty}

let find_init x = 
  let len1 = String.length x in 
  let sub1 = String.sub x ~pos:(len1 - 7) ~len:(7) in 
   String.equal sub1 ".init()"


let get_init_pn = 
  match (LfaDefMap.find_first_opt (find_init) lfa) with 
    | Some (init_pn, _) -> init_pn 
    | None -> 
        let () = is_active := false in "" 

let init_pn = get_init_pn 
let lfa_bindings = LfaDefMap.bindings lfa 
let lfa_methods = Caml.List.map (fun x -> fst x) lfa_bindings 
let all_methods = LfaSet.of_list lfa_methods 

let annons2set label = 
  if (String.equal label init_pn) then 
    let lfas_opt = LfaDefMap.find_opt label lfa in 
        (match lfas_opt with 
        | None -> empty_lfas 
        | Some {enable=enable_set;disable=_} -> 
          let disable_set' = LfaSet.diff all_methods enable_set in 
            {enable=enable_set;disable=disable_set'})
  else 
  let lfas_opt = LfaDefMap.find_opt label lfa in 
      (match lfas_opt with 
      | None -> empty_lfas 
      | Some lfas -> lfas)



  let is_this ap = 
    match ap with 
    | ((var, _typ), _access) -> Var.is_this var 
  
  let is_this_ap ap = 
    match ap with 
    | ((var, _typ), access) -> (Var.is_this var) && (phys_equal access [])



  let get_caller_instrs rcv_id instrs_array i = 
    match (Caml.Array.get instrs_array i) with 
      |  Sil.Load {id = id; e=exp; root_typ = _root_typ; typ = typ;_} -> 
          if (Ident.equal rcv_id id) then 
            Caml.Option.some (exp, typ) 
          else 
             Caml.Option.None 
      | _ -> 
          Caml.Option.None 


  (* get full access path *)
  let get_access_path_multiple exp0 _typ0 node = 
    let instrs_node = CFG.instrs node in 
    let instr_count = Instrs.count instrs_node in 
    let instrs_array = Instrs.get_underlying_not_reversed instrs_node in 
    let start = instr_count - 1 in 
    let i = start in 
    let rec get_ap exp0 i =
      if (phys_equal i (-1)) then None 
      else 
      let exp_opt = (match exp0 with 
        | Exp.Var rcv_id -> 
          get_caller_instrs rcv_id instrs_array i 
        | _ -> Caml.Option.None) in 
        match exp_opt with 
          | Some (Exp.Lvar lvar, typ) -> 
            Some (AccessPath.of_pvar lvar typ) 
          | Some (Exp.Lfield (exp1, name, _typ), _) -> 
              let ap_opt = get_ap exp1 (i-1) in
              (match ap_opt with 
              | Some ap -> let access = AccessPath.FieldAccess name in 
                            Some (AccessPath.append ap [access]) 
              | None -> None)
          | None -> 
             let ap_opt = get_ap exp0 (i-1) in 
              ap_opt 
          | _ -> None in 
      get_ap exp0 i 


  
  
(* ------------------------------------------------------------------------------- *)

  let compute_summary_basic sum_caller sum_callee = 
    if (Summary.is_error sum_caller) then 
      sum_caller else 
    if (Summary.is_error sum_callee) then 
      let sum_caller' = Summary.error sum_caller in 
        sum_caller' else 
    let en_caller = Summary.get_en sum_caller in 
    let dis_caller = Summary.get_dis sum_caller in 
    let pre_caller = Summary.get_pre sum_caller in 

    let en_callee = Summary.get_en sum_callee in 
    let dis_callee = Summary.get_dis sum_callee in 
    let pre_callee = Summary.get_pre sum_callee in 
    
    let b = LfaSet.disjoint pre_callee dis_caller in 
    if (not b && not continue) then 
      let sum_caller' = Summary.error sum_caller in 
        sum_caller' 
    else 
      let pre_caller' = LfaSet.union (LfaSet.diff pre_callee en_caller) pre_caller in 
      let dis_caller' = LfaSet.diff (LfaSet.union dis_callee dis_caller) en_callee in 
      let en_caller' = LfaSet.diff (LfaSet.union en_caller en_callee) dis_callee in 
      let sum_caller' = Summary.empty in 
      let sum_caller' = Summary.add_pre_set pre_caller' sum_caller' in 
      let sum_caller' =  
        sum_caller' |> Summary.add_dis_set dis_caller' |> Summary.add_en_set en_caller' in 
        sum_caller' 

  let summary_astate ap_exp astate_caller sum_callee = 
    (* BEGIN debug *)
    let () = L.d_printfln "summary_astate called\n" in 
    let () = L.d_printfln "ap_exp is: %a \n" AccessPath.pp ap_exp in 
    let () = L.d_printfln "astate_caller is: %a \n" Domain.pp astate_caller in 
    let () = L.d_printfln "sum_calle is: %a\n" Summary.pp sum_callee in 
    (* END debug *)
    if (Summary.is_error sum_callee) then
      let label = (ap_exp, (LfaSet.singleton "function")) in 
      let astate' = Domain.add_error_proc_names label astate_caller in 
          astate' 
      else 
    let pre = Summary.get_pre sum_callee in 
    let (astate_caller, _b) = Domain.check_state (ap_exp, LfaSet.empty) astate_caller in 
    (* if (not b && not continue) then 
      astate_caller 
    else  *)
    let (astate_caller, b2) = Domain.transition_check (ap_exp, pre) astate_caller in 
    if (not b2 && not continue) then 
      astate_caller else 
    if (is_this_ap ap_exp) then 
          astate_caller 
    else 
    let sum_map_caller = Domain.get_sum astate_caller in 
    let sum_caller_opt = LfaMapSum.find_opt ap_exp sum_map_caller in 
    (match sum_caller_opt with 
    | Some sum_caller -> 
        let sum_caller' = compute_summary_basic sum_caller sum_callee in 
          let sum_map_caller' = LfaMapSum.add ap_exp sum_caller' sum_map_caller in 
            Domain.update_sum sum_map_caller' astate_caller 
    | None -> 
        (* INITIALIZE IN SUM ))  *)
        let sum_map_caller' = LfaMapSum.add ap_exp sum_callee sum_map_caller in 
          Domain.update_sum sum_map_caller' astate_caller)
    
(* ------------------------------------------------------------------------------- *)


  let apply_summary summary_map node astate ((pvar, _typ1), _arg_id) 
                                            (exp, typ2)  = 
    let ap_formal = AccessPath.of_pvar pvar typ2 in 
    let ap_exp_opt = get_access_path_multiple exp typ2 node in 
    let ap_exp = (match ap_exp_opt with 
                | None -> ap_formal 
                | Some ap -> ap) in 

    let sum_callee_opt = LfaMapSum.find_opt ap_formal summary_map in 
    let sum_callee = (match sum_callee_opt with 
                | Some sum1 -> sum1 
                | None -> Summary.empty) in 

    if (Caml.Option.is_none sum_callee_opt) then 
      astate 
    else 
      let astate' = summary_astate ap_exp astate sum_callee in 
        astate' 




  let apply_summary_members sum_dom_callee ap_exp astate =     
    let sum_map_callee = Domain.get_sum sum_dom_callee in 

    let f key _value = 
      is_this key in 

    let sum_callee_members = LfaMapSum.filter f sum_map_callee in 

    let apply_sum_mem ap_mem sum_mem_callee astate = 
      let (_this, access_list) = ap_mem in 
      let ap = AccessPath.append ap_exp access_list in 
      let astate' = summary_astate ap astate sum_mem_callee in 
        astate'  in    

    let astate' =  LfaMapSum.fold apply_sum_mem sum_callee_members astate in 
        astate'
    


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
      if (not (!is_active)) then 
          astate 
      else 
        let (astate',b) = 
            (match analyze_dependency pn with 
            | Some (callee_proc_desc, callee_summary) ->  
                let callee_sum = Domain.get_sum callee_summary in
                if (LfaMapSum.is_empty callee_sum) then 
                  (astate, false) 
                else 
                  let formals = Procdesc.get_pvar_formals callee_proc_desc in 
                  let formals' = Caml.List.tl formals in 
                  let args' = Caml.List.tl args in 
                  let (exp0, typ0) = Caml.List.hd args in  
                  let ap_exp0_opt = get_access_path_multiple exp0 typ0 node in
                  (match ap_exp0_opt with 
                  | Some ap_exp0 -> 
                    let (_base, access_list) = ap_exp0 in 
                    let offset = List.length access_list + 1 + 1 in 
                    let args_ids = offset--((Caml.List.length formals')+offset-1) in
                    let formals_ids = Caml.List.combine formals' args_ids in 
                    let astate'' = Caml.List.fold_left2 (apply_summary callee_sum node) 
                                  astate formals_ids args' in 
                    let astate''' = apply_summary_members callee_summary ap_exp0 astate'' in
                      (astate''', true)
                  | None -> 
                      (astate, false))
            | None -> (astate, false)) in 
        if (b) then 
          astate' 
      else 
        let proc_name = Procname.to_string pn in 
        let arg0opt =  (List.hd args) in 
        let class_proc = ref true in 
        let (exp1, typ0) = (match arg0opt with 
                              | Some (exp1, typ1) -> (exp1, typ1) 
                              | None -> let () = class_proc := false
                                            in (Exp.zero, ret_typ)) in 
        if (not !class_proc) then 
          astate'
        else 
          let access_path_opt = get_access_path_multiple exp1 typ0 node in 
            if (Caml.Option.is_none access_path_opt) then 
              astate'
            else 
              let ap = Caml.Option.get access_path_opt in
              let lfas_dict = annons2set proc_name in 
              let en_set = lfas_dict.enable in 
              let dis_set = lfas_dict.disable in 
              let pre_set = LfaSet.singleton proc_name in 
              let sum_callee = Summary.empty |> Summary.add_en_set en_set |> Summary.add_dis_set dis_set 
                                |> Summary.add_pre_set pre_set in 
              
              let astaten = summary_astate ap astate' sum_callee in 
                astaten  


      | _ -> let nodekind = CFG.Node.kind node in 
                match nodekind with 
                        | Stmt_node (Call _str) -> 
                              astate
                        | _ -> 
                            Domain.reset2 astate 
                 


  let pp_session_name _node fmt = F.pp_print_string fmt "lfa checker"
end


module Analyzer = AbstractInterpreter.MakeRPO (TransferFunctions)

let checker ({InterproceduralAnalysis.proc_desc; err_log} as analysis_data) =
   (* let counter = ref 0 in  *)
  let proc_name = Procdesc.get_proc_name proc_desc in
  let nodes = Procdesc.get_nodes proc_desc in
  let log_report _astate_pre astate_post loc _ = 
    let ltr = [Errlog.make_trace_element 0 loc "Write of unused value" []] in
    let message =  Domain.report_issue2 ~post:astate_post in 
    Reporting.log_issue proc_desc err_log ~loc ~ltr Lfachecker IssueType.lfachecker_error message in 
  let do_reporting node_id state = if (error_reporting) then 
    let astate_set = state.AbstractInterpreter.State.post in
    let astate_pre = state.AbstractInterpreter.State.pre in 
    if (Domain.has_issue ~post:(astate_set)) then 
      (* should never fail since keys in the invariant map should always be real node id's *)
          (* let () = debug "LFA: HAS ISSUE astate_pre: %a, and astate_post: %a" Domain.pp astate_pre Domain.pp astate_set in  *)
      let node =
        List.find_exn
          ~f:(fun node -> Procdesc.Node.equal_id node_id (Procdesc.Node.get_id node))
          nodes
      in
        log_report astate_pre astate_set (ProcCfg.Exceptional.Node.loc node) proc_name 
    else () 
  (* let do_reporting node_id state = 
    let astate_set = state.AbstractInterpreter.State.post in
    let astate_pre = state.AbstractInterpreter.State.pre in 
    if (Domain.has_issue ~post:(astate_set)) then 
      (* should never fail since keys in the invariant map should always be real node id's *)
          (* let () = debug "LFA: HAS ISSUE astate_pre: %a, and astate_post: %a" Domain.pp astate_pre Domain.pp astate_set in  *)
      let node =
        List.find_exn
          ~f:(fun node -> Procdesc.Node.equal_id node_id (Procdesc.Node.get_id node))
          nodes
      in
        log_report astate_pre astate_set (ProcCfg.Exceptional.Node.loc node) proc_name  *)
  in
  let inv_map = Analyzer.exec_pdesc analysis_data ~initial:Domain.empty proc_desc in
  let result = Analyzer.compute_post analysis_data ~initial:Domain.empty proc_desc in 
  Analyzer.InvariantMap.iter do_reporting inv_map; 
  result 