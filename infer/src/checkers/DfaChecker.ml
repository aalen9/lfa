(*
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd
module F = Format
module L = Logging
module Json = Yojson
module JsonUtil = Json.Basic.Util 

module Key = AccessPath 
module State = String 

module DomSum = DfaCheckerDomain.DomainSummary 

module StateSet = DfaCheckerDomain.DfaSet(State) 


module Summary = DfaCheckerDomain.DfaMap (State) (DfaCheckerDomain.DfaSet (State))


module DfaMapDom = DfaCheckerDomain.DfaMap (Key) (DfaCheckerDomain.DfaSet(State) ) 

module DfaMapSum = DfaCheckerDomain.DfaMap (Key) (DfaCheckerDomain.DfaMap (State) (DfaCheckerDomain.DfaSet (State))) 




module LabelStateMap = PrettyPrintable.MakePPMonoMap (String) (String) 
module DfaDefMap = PrettyPrintable.MakePPMonoMap (String) (LabelStateMap)

    

(* READ DFA FROM JSON *)
let dfa_properties_path = Config.dfa_properties 
let is_active_c = Config.is_checker_enabled Dfachecker && not (List.is_empty dfa_properties_path)
let is_active = ref is_active_c

(* let error_reporting = Config.lfa_error_reporting  *)

let error_reporting = not Config.dfa_no_error_reporting 

 (* read from file *)
 let dfa_json = 
  if (!is_active) then 
    Caml.Option.some (Json.Basic.from_file (Caml.List.hd dfa_properties_path)) 
  else 
    Caml.Option.none 


  (* DFA read *)
let json_to_dfa dfa_json = 
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

let _debug fmt = L.debug Analysis Verbose fmt

module TransferFunctions = struct
  module CFG = ProcCfg.Normal 
  module Domain = DomSum 

  type analysis_data = Domain.t InterproceduralAnalysis.t



  let dfa0 = dfa

  let get_start_state_dfa = init_state_name
  let get_error_state_dfa = "error"


  let _is_state_error state = Int.equal (String.compare state get_error_state_dfa) 0


  let get_state_dfa state label dfa = 
    let labelStateOpt = DfaDefMap.find_opt state dfa in 
    match labelStateOpt with 
    | None -> get_error_state_dfa  
    | Some map1 -> 
        (match (LabelStateMap.find_opt label map1) with 
          | None -> get_error_state_dfa 
          | Some state -> state)

      let find_class_name x = 
        let split1 = Caml.String.split_on_char '.' x in 
        let s1_opt = List.hd split1 in 
        (match s1_opt with 
        | Some s1 ->   
            let split2 = Caml.String.split_on_char ' ' s1 in 
            let s2_opt = Caml.List.nth_opt split2 ((Caml.List.length split2)-1)  in 
            (match s2_opt with 
              | Some class_name -> class_name 
              | None -> let () = is_active := false in "")
        | None -> let () = is_active := false in "")
      
  let get_some_method = 
    let bind1_opt = DfaDefMap.find_opt init_state_name dfa0 in 
    (match bind1_opt with 
      | Some bind1 -> 
          let method_op = LabelStateMap.min_binding_opt bind1 in 
          (match method_op with 
            | Some (method1, _) -> method1 
            | None -> let () = is_active := false in "")
      | None -> let () = is_active := false in "")


  let get_init_pn = 
    let class_name = find_class_name get_some_method in 
      "void "^class_name^".init()" 

  let init_pn = get_init_pn 


  (* check if ap is this *)
  let is_this ap = 
    match ap with 
    | ((var, _typ), _access) -> Var.is_this var 

  let is_this_ap ap = 
    match ap with 
    | ((var, _typ), access) -> (Var.is_this var) && (phys_equal access [])


  let (--) i j = 
      let rec aux n acc =
        if n < i then acc else aux (n-1) (n :: acc)
      in aux j [] 

  (* return option exp *)
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
              (* add this field here *)
              (match ap_opt with 
              | Some ap -> let access = AccessPath.FieldAccess name in 
                            Some (AccessPath.append ap [access]) 
              | None -> None)
          | None -> 
             (* continue here *)
             let ap_opt = get_ap exp0 (i-1) in 
              ap_opt 
          | _ -> None in 
      get_ap exp0 i 

  let apply_summary2 summary_map node astate ((pvar, _type1), _arg_id) 
                                    (exp, typ2)  = 
      let dom_map = DomSum.get_dom astate in 
      let ap = AccessPath.of_pvar pvar typ2 in 
      let sum1_opt = DfaMapSum.find_opt ap summary_map in 

      let sum1 = (match sum1_opt with 
                  | Some sum1 -> sum1 
                  | None -> Summary.empty) in 
        
      if (Summary.is_empty sum1) then 
        astate
      else 

      (* APPLY SUMMARY *)
      let ap_exp_opt = get_access_path_multiple exp typ2 node in 
      let get_states_in_sum sum state = 
        let stateset_opt = Summary.find_opt state sum in 
        (match stateset_opt with
        | None -> StateSet.singleton get_error_state_dfa 
        | Some stateset -> stateset) in 
      
      (match ap_exp_opt with 
      | Some ap_exp -> 
          let dom_opt = DfaMapDom.find_opt ap_exp dom_map in 
          (match dom_opt with 
          | Some dom -> 
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
                        astate'
          | None -> (* SUMMARY COMPUTATIONS *) 
                if (is_this_ap ap_exp) then 
                  astate
                else 
                  let sum_map0 = DomSum.get_sum astate in 
                  let sum0_opt = DfaMapSum.find_opt ap_exp sum_map0 in 
                  (match sum0_opt with 
                    | Some sum0 -> 
                      if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum0) then 
                          let transition_all_error  _stateset = 
                            StateSet.singleton "all_error" in 
                        let sum' = Summary.map transition_all_error sum0 in 
                        let sum_map' = DfaMapSum.add ap_exp sum' sum_map0 in 
                          DomSum.update_sum sum_map' astate
                      else 
                      if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum1) then 
                        let transition_all_error  _stateset = 
                          StateSet.singleton "all_error" in 
                          let sum' = Summary.map transition_all_error sum0 in 
                          let sum_map' = DfaMapSum.add ap_exp sum' sum_map0 in 
                             DomSum.update_sum sum_map' astate
                      else 
                        let f state stateset' = 
                          if (StateSet.mem "error" stateset') then 
                              StateSet.singleton "error"  
                          else 
                              (let stateset = get_states_in_sum sum1 state in 
                                  StateSet.union stateset stateset') in
                        let error_stop = ref true in 
                        let transition stateset = 
                             if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
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
                        astate'  
                    | None -> 
                        let sum_map' = DfaMapSum.add ap_exp sum1 sum_map0 in 
                        let astate' =  DomSum.update_sum sum_map' astate in 
                          astate'))
      | None -> 
        astate)


  let get_states_in_sum sum state = 
    let stateset_opt = Summary.find_opt state sum in 
    (match stateset_opt with
    | None -> StateSet.singleton get_error_state_dfa 
    | Some stateset -> stateset) 

  let summary_apply_basic dom_caller sum_callee = 

    let f state stateset' = 
      if (StateSet.mem "error" stateset') then 
        StateSet.singleton "error" else 
      if (StateSet.mem "error_handled" stateset') then 
        StateSet.singleton "error_handled" else 

      let stateset = get_states_in_sum sum_callee state in 
      if (StateSet.mem "all_error" stateset) then 
        StateSet.singleton "error" else 
      StateSet.union stateset stateset' in 
  let transition stateset = 
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
  let dom_caller' = transition dom_caller in 
        dom_caller' 


  let summary_compute_basic ~sum_caller:sum_caller ~sum_callee:sum_callee = 
      if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum_caller) then 
        let transition_all_error  _stateset = 
          StateSet.singleton "all_error" in 
      let sum' = Summary.map transition_all_error sum_caller in 
          sum' 
    else 
    if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum_callee) then 
      (* transition all error *)
      let transition_all_error  _stateset = 
        StateSet.singleton "all_error" in 
        let sum' = Summary.map transition_all_error sum_caller in 
          sum' 
    else 
      let f state stateset' = 
        if (StateSet.mem "error" stateset') then 
            StateSet.singleton "error"  
        else 
            (let stateset = get_states_in_sum sum_callee state in 
                StateSet.union stateset stateset') in
      let error_stop = ref true in 
      let transition stateset = 
          if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
          StateSet.empty 
          else 
            let () = error_stop := false in 
            StateSet.fold f stateset StateSet.empty in 
      let sum' = Summary.map transition sum_caller in 
      let transition_all_error  _stateset = 
        StateSet.singleton "all_error" in 
      let sum'' = if (!error_stop) then 
        Summary.map transition_all_error sum_caller else 
        sum' in 
        sum'' 

  (* NEW END *)

  let apply_summary_members sum_dom_callee ap_exp astate = 
    (* exp0 is receiver *)
    let sum_map_callee = Domain.get_sum sum_dom_callee in 
    let dom_map_callee = Domain.get_dom sum_dom_callee in 
  
    (* filter both dom and sum *)
    let f key _value = 
      is_this key in 

    let sum_callee_members = DfaMapSum.filter f sum_map_callee in 
    let dom_callee_members = DfaMapDom.filter f dom_map_callee in 


    let apply_dom_mem ap_mem dom_mem_callee astate = 
      let (_this, access_list) = ap_mem in 
      let ap = AccessPath.append ap_exp access_list in 

      let dom_map_caller = Domain.get_dom astate in 
    
      if (DfaMapDom.mem ap dom_map_caller) then 
        let dom_map' = DfaMapDom.add ap (StateSet.singleton "error") dom_map_caller in 
          Domain.update_dom dom_map' astate
      else 
        let dom_map_caller' = DfaMapDom.add ap dom_mem_callee dom_map_caller in 
          Domain.update_dom dom_map_caller' astate in 


    let apply_sum_mem  ap_mem sum_mem_callee astate = 
      let (_this, access_list) = ap_mem in 
      let ap = AccessPath.append ap_exp access_list in 

      let dom_map = Domain.get_dom astate in 
          if (DfaMapDom.mem ap dom_map) then 
            let dom_ap_opt = DfaMapDom.find_opt ap dom_map in 
            (match dom_ap_opt with 
              | Some dom_caller -> 
                  let dom_caller' = summary_apply_basic dom_caller sum_mem_callee in 
                  let dom_map' = DfaMapDom.add ap dom_caller' dom_map in 
                    Domain.update_dom dom_map' astate 
            | None -> 
                  let dom_map' = DfaMapDom.add ap (StateSet.singleton "error") dom_map in 
                    Domain.update_dom dom_map' astate)
        else 
          let sum_map_caller = Domain.get_sum astate in 
          let sum_ap_opt = DfaMapSum.find_opt ap sum_map_caller in 
          (match sum_ap_opt with 
            | Some sum_caller -> 
                let sum_caller' = 
                  summary_compute_basic ~sum_callee:sum_mem_callee ~sum_caller:sum_caller in 
                  let sum_map_caller' = DfaMapSum.add ap sum_caller' sum_map_caller in 
                    Domain.update_sum sum_map_caller' astate
            | None -> 
                let sum_map' = DfaMapSum.add ap sum_mem_callee sum_map_caller in 
                  Domain.update_sum sum_map' astate) 
          in 
    let astate' = DfaMapSum.fold apply_sum_mem sum_callee_members astate in 
    let astate'' = DfaMapDom.fold apply_dom_mem dom_callee_members astate' in 
          astate'' 



  let summary_compute annotations sum_map proc_name ap _loc =
      (* first check if error *)
      let is_state_error state = Int.equal (String.compare state get_error_state_dfa) 0 in
      if (is_this_ap ap) then 
        sum_map 
      else 
        let sum_ap_opt = DfaMapSum.find_opt ap sum_map in 
        (match sum_ap_opt with 
        | None -> 
            (* initialize in summary *)
            let _sum = Summary.empty in 
            let f key _state map' = 
              Summary.add key (StateSet.singleton key) map' in 
            let init_sum = DfaDefMap.fold f annotations Summary.empty in 
            let f label state = 
              (* let () = incr_counter 1 in  *)
              get_state_dfa state label annotations in 
            let error_stop = ref true in 
          
            let transition label stateset = 
                 if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
                        StateSet.singleton "error" 
                else 
                  let set1 = StateSet.map (f label) stateset in
                  if (StateSet.exists is_state_error set1) then 
                    StateSet.empty 
                else 
                  let () = error_stop := false in
                  set1 in 
            let sum' = Summary.map (transition proc_name) init_sum in 
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
              if (Summary.exists (fun _x -> fun a -> StateSet.mem "all_error" a) sum) then 
                sum_map
              else 
            let f2 label state astate =
              if (StateSet.mem "error" astate) then 
                  astate  
                else 
                  let state' = get_state_dfa state label annotations in 
                  StateSet.add state' astate in 
            let () = error_stop := true in 
            let transition label stateset =
                 if (StateSet.mem "error" stateset || StateSet.is_empty stateset) then 
                 StateSet.empty 
                else 
              let set1 = StateSet.fold (f2 label) stateset StateSet.empty in 
              if (StateSet.mem "error" set1) then 
                  StateSet.empty 
              else 
                let () = error_stop := false in
                set1 in 
            let sum' = Summary.map (transition proc_name) sum in 
                let transition_all_error _label _stateset = 
                  StateSet.singleton "all_error" 
                in 
            let sum' = if (!error_stop) then 
                Summary.map (transition_all_error proc_name) sum' 
            else 
              sum' in 
            DfaMapSum.add ap sum' sum_map) 



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
        let _class_name0_opt = Procname.get_class_name pn in 
       let (astate', b) = 
            (match analyze_dependency pn with 
            | Some (callee_proc_desc, callee_summary) -> 
                let callee_sum = DomSum.get_sum callee_summary in 
                let callee_dom = DomSum.get_dom callee_summary in 
                if (DfaMapSum.is_empty callee_sum && DfaMapDom.is_empty callee_dom) then 
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
                        let astate'' = Caml.List.fold_left2 (apply_summary2 callee_sum node) 
                                      astate formals_ids args' in 
                        let astate''' = apply_summary_members callee_summary ap_exp0 astate'' in
                            (astate''', true)
                    | None -> (astate, false)) 
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
          let access_path_opt =  get_access_path_multiple exp1 typ0 node in 
            if (Caml.Option.is_none access_path_opt) then 
              astate'
            else 
              let ap = Caml.Option.get access_path_opt in
              let dom_map = DomSum.get_dom astate' in 
              (* INITIALIZATION *)
              if (Procname.is_constructor pn || String.equal proc_name init_pn) then 

                (* INITIALIZE DOMAIN FOR THIS ACCESS PATH *)
                let start_state = get_start_state_dfa in 

                (* initialize singleton set *)
                let state_set = StateSet.singleton start_state in 
                let dom_map' = DfaMapDom.add ap state_set dom_map in 
                  DomSum.update_dom dom_map' astate'
              else 
                let dom_ap_opt = DfaMapDom.find_opt ap dom_map in 
                let astaten = (match dom_ap_opt with 
                | None -> 
                    let sum_map = DomSum.get_sum astate' in 
                    let sum_map' = summary_compute dfa0 sum_map proc_name ap (Procdesc.Node.get_loc node) in 
                     DomSum.update_sum sum_map' astate'
                | Some dom -> 
                    let label = proc_name in 
                    let f = fun state -> get_state_dfa state label dfa0 in 
                    let dom' = 
                      if (StateSet.mem "error" dom || StateSet.mem "error_handled" dom) then 
                        StateSet.singleton "error_handled" 
                      else 
                        StateSet.map f dom in
                     let dom_map' = DfaMapDom.add ap dom' dom_map in 
                    DomSum.update_dom dom_map' astate') in 
                astaten

      | _ -> let nodekind = CFG.Node.kind node in 
                match nodekind with 
                        | Stmt_node (Call _str) -> 
                              astate 
                        | _ -> 
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
  let is_all_error2 state = Int.equal (String.compare state "all_error") 0 in 
  let is_all_error_set states = StateSet.exists is_all_error2 states in 
  let is_all_error sum = Summary.exists (fun _key -> fun value -> is_all_error_set value) sum in 
  let log_report astate_pre astate_post loc _ = 
    let ltr = [Errlog.make_trace_element 0 loc "Write of unused value" []] in
    (* let message = 
      DomSum.report_issue2 ~is_state_error:is_state_error 
      ~pre:astate_pre ~post:astate_post in  *)
      let message = 
        DomSum.report_issue2 ~is_state_error:is_state_error 
        ~is_all_error:is_all_error 
        ~pre:astate_pre ~post:astate_post in 
    Reporting.log_issue proc_desc err_log ~loc ~ltr Dfachecker IssueType.dfachecker_error message in 
  (* let do_reporting _node_id _state = () in  *)
  let do_reporting node_id state = if (error_reporting) then 
    let astate_set = state.AbstractInterpreter.State.post in
    let astate_pre = state.AbstractInterpreter.State.pre in 
    if (DomSum.has_issue ~is_state_error:is_state_error 
      ~is_all_error ~pre:(astate_pre) ~post:(astate_set)) then 
    (* if (DomSum.has_issue ~is_state_error:is_state_error ~pre:(astate_pre) ~post:(astate_set)) then  *)
      (* should never fail since keys in the invariant map should always be real node id's *)
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
          if (DomSum.has_issue ~is_state_error:is_state_error 
            ~is_all_error ~pre:(astate_pre) ~post:(astate_set)) then 
          (* if (DomSum.has_issue ~is_state_error:is_state_error ~pre:(astate_pre) ~post:(astate_set)) then  *)
            (* should never fail since keys in the invariant map should always be real node id's *)
            let node =
              List.find_exn
                ~f:(fun node -> Procdesc.Node.equal_id node_id (Procdesc.Node.get_id node))
                nodes
            in
              log_report astate_pre astate_set (ProcCfg.Exceptional.Node.loc node) proc_name  *)
  in
  let inv_map = Analyzer.exec_pdesc analysis_data ~initial:DomSum.empty proc_desc in
  let result = Analyzer.compute_post analysis_data ~initial:DomSum.empty proc_desc in 
  Analyzer.InvariantMap.iter do_reporting inv_map; 
  result 