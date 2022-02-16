open! IStd 

module F = Format  
module L = Logging

module type DomainOptS = sig 
    include AbstractDomain.S 
end 

let debug fmt = L.debug Analysis Verbose fmt

module DomainOpt (Domain : AbstractDomain.S) : 
    DomainOptS with type t = Domain.t option = 
struct 

    type t = Domain.t option 

    let pp fmt = function Caml.Option.None -> F.pp_print_string fmt "None" |
                            Caml.Option.Some dom1 -> Domain.pp fmt dom1  

    let leq ~lhs ~rhs = 
        match (lhs, rhs) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> (Domain.leq ~lhs:dom1 ~rhs:dom2) 
        | Caml.Option.None, _ -> false 
        | _, Caml.Option.None -> true 

    let join dom1 dom2 = 
        match (dom1, dom2) with 
        | Caml.Option.Some dom1', Some dom2' ->
                Caml.Option.Some (Domain.join dom1' dom2') 
        | _,_ -> Caml.Option.None 

    let widen ~prev ~next ~num_iters = 
        match (prev, next) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> 
                Caml.Option.Some (Domain.widen ~prev:dom1 ~next:dom2 ~num_iters:num_iters) 
        | _, _ -> Caml.Option.None 


end 


module DomainOpt2 (Domain : AbstractDomain.S) : 
    DomainOptS with type t = Domain.t option = 
struct 

    type t = Domain.t option 

    let pp fmt = function Caml.Option.None -> F.pp_print_string fmt "None" |
                        Caml.Option.Some dom1 ->  
                            (* Domain.pp fmt dom1 *)
                            let () = L.d_printfln "IN PP FOR DOMAINOPT2" in 
                            F.fprintf fmt "@Some %a" Domain.pp dom1  

    let leq ~lhs ~rhs = 
        match (lhs, rhs) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> (Domain.leq ~lhs:dom1 ~rhs:dom2) 
        | Caml.Option.None, _ -> false 
        | _, Caml.Option.None -> true 

    let join dom1 dom2 = 
        match (dom1, dom2) with 
        | Caml.Option.Some dom1', Caml.Option.Some dom2' ->
                Caml.Option.Some (Domain.join dom1' dom2') 
        | Caml.Option.Some dom1', None -> Caml.Option.Some dom1' 
        | None, Caml.Option.Some dom2' -> Caml.Option.Some dom2'
        | None, None -> None 

    let widen ~prev ~next ~num_iters = 
        match (prev, next) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> 
                Caml.Option.Some (Domain.widen ~prev:dom1 ~next:dom2 ~num_iters:num_iters) 
        | _, _ -> join prev next 


end 


module LfaMap (Key : PrettyPrintable.PrintableOrderedType) 
    (ValueDomain : AbstractDomain.S) =
struct 
    include AbstractDomain.Map (Key) (ValueDomain) 

    let _increasing_union0 ~f astate1 astate2 = 
        if phys_equal astate1 astate2 then astate1
        else 
            let res = 
                merge 
                    (fun _ v1_opt v2_opt -> 
                        match (v1_opt, v2_opt) with 
                        | Some v1, Some v2 -> 
                            Some (f v1 v2) 
                        | Some _, None -> None 
                        | None, Some _ -> None 
                        | None, None -> None 
                        )
                astate1 astate2 
                in 
                res 
    
    let join1 ~f astate1 astate2 = 
        if phys_equal astate1 astate2 then astate1 
        else 
            let res = 
                union (fun _ v1 v2 -> 
                        Some (f v1 v2)) 
                astate1 astate2 
                in 
                res

    let join astate1 astate2  =  
        join1 ~f:ValueDomain.join astate1 astate2 

    let widen ~prev ~next ~num_iters =
        join1 prev next 
        ~f:(fun prev next -> ValueDomain.widen ~prev ~next ~num_iters)


end 

module LfaSet (Element :  PrettyPrintable.PrintableOrderedType) = 
struct 
    include AbstractDomain.FiniteSet (Element) 
    let join astate1 astate2 = inter astate1 astate2 
end 


module type SummaryS = 
sig 
    include AbstractDomain.S

    type eltSet 
    type elt 

    val add_pre : elt -> t -> t 
    val remove_pre : elt -> t -> t
    val mem_pre_en : elt -> t -> bool 
    val mem_pre_dis : elt -> t -> bool 
    
    val add_en : elt list -> t -> t  

    val add_dis : elt list -> t -> t 

    val add_pre_set : eltSet -> t -> t
    val add_en_set : eltSet -> t -> t 
    val add_dis_set : eltSet -> t -> t

    val get_en : t -> eltSet
    val get_dis : t -> eltSet
    val get_pre : t -> eltSet 

    val remove_en_set : eltSet -> t -> t 
    val remove_en : elt list -> t -> t 

    val remove_dis_set : eltSet -> t -> t 
    val remove_dis : elt list -> t -> t 

    val empty : t
    val is_error : t -> bool 
    val error : t -> t 
end 


module Summary (Element : PrettyPrintable.PrintableOrderedType) = struct 

    module EltSet = LfaSet (Element) 

    module StatePre = DomainOpt (EltSet)

    type eltSet = EltSet.t 
    type elt = Element.t 

    module Transf = AbstractDomain.Pair (EltSet) (EltSet) 

    include AbstractDomain.Pair (Transf) (StatePre)

    let join ((en1, dis1), pre1) ((en2,dis2), pre2) = 
        let dis = EltSet.union dis1 dis2 in 
        let en = EltSet.diff (EltSet.inter en1 en2) dis in 
        let pre = 
            (match (pre1, pre2) with 
            | Caml.Option.Some pre1', Caml.Option.Some pre2' ->  
                        Caml.Option.some (EltSet.union pre1' pre2') 
            | _, _ -> None) in 
        ((en, dis), pre)

    let add_pre el ((en1,dis1), pre1) = ((en1, dis1), Caml.Option.map (EltSet.add el) pre1)
    let remove_pre el ((en1,dis1), pre1) = ((en1, dis1), Caml.Option.map (EltSet.remove el) pre1) 
    let mem_pre_en el ((en1, _), _) = EltSet.mem el en1 
    let mem_pre_dis el ((_, dis1), _) = EltSet.mem el dis1 

    let add_en labels ((en1,dis1), pre1) = 
        ((EltSet.union (EltSet.of_list labels) en1, dis1), pre1) 

    let add_dis labels ((en1,dis1), pre1) = 
        ((en1, EltSet.union (EltSet.of_list labels) dis1), pre1) 

    let add_pre_set pre_set ((en1,dis1), pre1) = 
        match pre1 with 
        | Some pre1' -> ((en1,dis1), Caml.Option.some (EltSet.union pre_set pre1'))
        | None -> ((en1,dis1), Caml.Option.some pre_set)

    let add_en_set en_set ((en1,dis1), pre1) = ((EltSet.union en1 en_set,dis1), pre1)
    let add_dis_set dis_set ((en1,dis1), pre1) = ((en1,EltSet.union dis_set dis1), pre1)


    let get_en ((en1, _dis1), _pre1) = en1 
    let get_dis ((_en1, dis1), _pre1) = dis1
    let get_pre ((_,_), pre1) = 
        match pre1 with 
        | Some pre -> pre 
        | None -> EltSet.empty 


    let remove_en labels ((en1, dis1), pre1) = 
        ((EltSet.diff en1 (EltSet.of_list labels), dis1), pre1) 
    let remove_dis labels ((en1, dis1), pre1) = 
        ((en1, EltSet.diff dis1 (EltSet.of_list labels)), pre1) 

    let remove_en_set set_labels ((en1, dis1), pre1) = 
        ((EltSet.diff en1 set_labels, dis1), pre1) 
    let remove_dis_set set_labels ((en1, dis1), pre1) = 
        ((en1, EltSet.diff dis1 set_labels), pre1) 

    let empty = ((EltSet.empty, EltSet.empty), Caml.Option.some EltSet.empty)

    let is_error ((_en1,_dis1), pre1) = Caml.Option.is_none pre1 
    let error ((en1, dis1), _) = ((en1,dis1), Caml.Option.None)

end 

module type S = sig 

    include AbstractDomain.S 
    type sum 
    type label 

    val empty : t 

    val get_sum : t -> sum 
    val update_sum : sum -> t -> t 

    val add_error_proc_names: label -> t -> t 

    val check_state: label -> t -> t*bool 

    val check_state2: label -> t -> bool

    val transition_check: label -> t -> t*bool 


    val has_issue :  post:t -> bool 

    val reset2 : t -> t 
    val report_issue2 :  post:t -> string 
end 

module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (Label : PrettyPrintable.PrintableOrderedType) =
struct
    module LabelSet = LfaSet (Label) 


    module Sum = Summary (Label)

    module MapSummary = LfaMap (Key) (Summary (Label))

    module SomeLabelSet = DomainOpt2 (LabelSet)
    module ProcMap = LfaMap (Key) (SomeLabelSet)

    type sum = MapSummary.t 
    type label = Key.t * LabelSet.t 

    include AbstractDomain.Pair (MapSummary) (ProcMap) 

                
    let pp fmt (summary, proc_label) = 
        F.fprintf fmt "@\nSummary: %a @\nProcLabel: %a @\n" 
                   MapSummary.pp summary ProcMap.pp proc_label 

    let empty = (MapSummary.empty, ProcMap.empty)

    let get_sum astate = (fst astate) 
    let update_sum sum1 (_, proc_label0) = (sum1, proc_label0)


    let add_error_proc_names (ap, label_set) (sum0, proc_label0) = 
       let proc_label1 = ProcMap.add ap (Caml.Option.Some label_set) proc_label0 in 
        (sum0, proc_label1)


    let check_state2 label astate = 
        let (ap, _label_set) = label in 
        let (_, label_map) = astate in
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        (match proc_ap_opt with 
        | None -> 
            true
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  false 
                            | None -> true))


    let check_state label astate = 
        let (ap, _label_set) = label in 
        let (sum0, label_map) = astate in
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        let some_label = Caml.Option.Some LabelSet.empty in 
        (match proc_ap_opt with 
        | None -> (astate, true) 
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  
                                let label_map' = ProcMap.add ap some_label label_map in 
                                let astate' = (sum0, label_map') in  
                                (astate', false)
                            | None ->  (astate, true))) 


    let transition_check label astate = 
        let (ap, label_set) = label in 
        let (sum0, label_map) = astate in
        let sum_ap_opt = MapSummary.find_opt ap sum0 in 
        (match sum_ap_opt with 
            | None -> (astate, true) 
            | Some sum_ap -> 
                let dis_set = Sum.get_dis sum_ap in 
                let diff = LabelSet.inter dis_set label_set in 
                if (LabelSet.is_empty diff) then 
                    (astate, true) 
                else 
                    let some_label =  Caml.Option.Some diff in 
                    let label_map' = ProcMap.add ap some_label label_map in 
                    ((sum0, label_map'), false))



    let has_issue ~post:(_, label_map) = 
        let () = debug "in has_issue\n" in 
        if (ProcMap.is_empty label_map) then 
            false 
        else 
            let f _key some_labelset b = 
                (match some_labelset with 
                | Some labelset -> 
                    if (LabelSet.is_empty labelset) then 
                        b 
                    else 
                        true 
                | None -> b
                ) in 
            ProcMap.fold f label_map false 

     

    let reset2 (sum0, label_map) = 
        let f some_label = 
            (match some_label with 
            | None -> None 
            | Some _ -> Some LabelSet.empty) in 
           let label_map1 =  ProcMap.map f label_map in 
           (sum0, label_map1)

    let report_issue2 ~post:(_, label_map) = 
        (* check the difference between label_map and dom_map *)
        let f key some_labelset s = 
           (match some_labelset with 
            | None -> s 
            | Some labelset -> 
                F.asprintf "%s. Methods are not allowed: %a (for var: %a)" s LabelSet.pp labelset 
                Key.pp key) in 
        ProcMap.fold f label_map ""
    


end 

module DomainSummary = Make (AccessPath) (String) 

