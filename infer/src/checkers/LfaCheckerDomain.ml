open! IStd 

module F = Format  
module L = Logging

module type DomainOptS = sig 
    include AbstractDomain.S 
end 

let _debug fmt = L.debug Analysis Verbose fmt

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
                            (* let () = L.d_printfln "IN PP FOR DOMAINOPT2" in  *)
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

    let widen ~prev ~next ~num_iters:_ =  join prev next 


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
    (* let widen  *)
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

    (* new must *)
    val add_must_set : eltSet -> t -> t 
    val add_called_set : eltSet -> t -> t
    (* new must *)

    val get_en : t -> eltSet
    val get_dis : t -> eltSet
    val get_pre : t -> eltSet 
    val get_must : t -> eltSet 
    val get_called : t -> eltSet 

    val remove_en_set : eltSet -> t -> t 
    val remove_en : elt list -> t -> t 

    val remove_dis_set : eltSet -> t -> t 
    val remove_dis : elt list -> t -> t 

    val empty : t
    val is_error : t -> bool 
    val error : t -> t 

     (* MUST *)
     val add_must : elt list -> t -> t 
     val rem_must : elt list -> t -> t 
     val add_called : elt list -> t -> t 
     val rem_called : elt list -> t -> t 
 
     val is_must_empty : t -> bool 
end 


module Summary (Element : PrettyPrintable.PrintableOrderedType) = struct 

    module EltSet = LfaSet (Element) 

    module StatePre = DomainOpt (EltSet)

    type eltSet = EltSet.t 
    type elt = Element.t 

    module Transf = AbstractDomain.Pair (EltSet) (EltSet) 

    module MustPair = AbstractDomain.Pair (EltSet) (EltSet) 

    module MayTriplet = AbstractDomain.Pair (Transf) (StatePre)

    (* include AbstractDomain.Pair (Transf) (StatePre) *)

    include AbstractDomain.Pair (MayTriplet) (MustPair) 

   
    let join_may ((en1, dis1), pre1) ((en2,dis2), pre2) = 
        let dis = EltSet.union dis1 dis2 in 
        let en = EltSet.diff (EltSet.inter en1 en2) dis in 
        let pre = 
            (match (pre1, pre2) with 
            | Caml.Option.Some pre1', Caml.Option.Some pre2' ->  
                        Caml.Option.some (EltSet.union pre1' pre2') 
            | _, _ -> None) in 
        ((en, dis), pre) 

    let join_must (m1, c1) (m2, c2) = 
        (EltSet.union m1 m2, EltSet.inter c1 c2) 
    


    let join (may_triplet1, must_pair1) (may_triplet2, must_pair2) =
        (join_may may_triplet1 may_triplet2, join_must must_pair1 must_pair2)  


    let widen ~prev ~next ~num_iters:_= 
        join prev next 


    let add_pre el (((en1, dis1), pre1), (m1, c1)) = 
        (((en1, dis1), Caml.Option.map (EltSet.add el) pre1), (m1, c1))
    let remove_pre el (((en1,dis1), pre1), (m1, c1)) = 
        (((en1, dis1), Caml.Option.map (EltSet.remove el) pre1), (m1 ,c1)) 
    let mem_pre_en el (((en1, _), _),_) = EltSet.mem el en1 
    let mem_pre_dis el (((_, dis1), _),_) = EltSet.mem el dis1 

    let add_en labels (((en1,dis1), pre1), m) = 
        (((EltSet.union (EltSet.of_list labels) en1, dis1), pre1), m)

    let add_dis labels (((en1,dis1), pre1), m) = 
        (((en1, EltSet.union (EltSet.of_list labels) dis1), pre1), m)

    let add_pre_set pre_set (((en1,dis1), pre1), m) = 
        match pre1 with 
        | Some pre1' -> 
            (((en1,dis1), Caml.Option.some (EltSet.union pre_set pre1')), m)
        | None -> 
            (((en1,dis1), Caml.Option.some pre_set), m) 

    let add_en_set en_set (((en1,dis1), pre1), m) = 
        (((EltSet.union en1 en_set,dis1), pre1), m) 
    let add_dis_set dis_set (((en1,dis1), pre1), m) = 
        (((en1,EltSet.union dis_set dis1), pre1), m) 

    (* new MUST begin *)
    let add_must_set must_set (((en1,dis1), pre1), (must, called)) = 
        (((en1,dis1), pre1), (EltSet.union must_set must, called)) 
    let add_called_set called_set (((en1,dis1), pre1), (must, called)) = 
        (((en1,dis1), pre1), (must, EltSet.union called called_set)) 
    (* new MUST end *)


    let get_en (((en1, _dis1), _pre1), _m) = en1 
    let get_dis (((_en1, dis1), _pre1), _m) = dis1
    let get_pre ((_, pre1), _m) = 
        match pre1 with 
        | Some pre -> pre 
        | None -> EltSet.empty 

    let get_must (((_en1, _dis1), _pre1), (m,_c)) = m 
    let get_called (((_en1, _dis1), _pre1), (_m,c)) = c 


    let remove_en labels (((en1, dis1), pre1), m) = 
        (((EltSet.diff en1 (EltSet.of_list labels), dis1), pre1), m)  
    let remove_dis labels (((en1, dis1), pre1), m) = 
        (((en1, EltSet.diff dis1 (EltSet.of_list labels)), pre1), m)

    let remove_en_set set_labels (((en1, dis1), pre1), m) = 
        (((EltSet.diff en1 set_labels, dis1), pre1), m) 
    let remove_dis_set set_labels (((en1, dis1), pre1), m) = 
        (((en1, EltSet.diff dis1 set_labels), pre1), m)  

    let empty = 
        (((EltSet.empty, EltSet.empty), Caml.Option.some EltSet.empty), 
        (EltSet.empty, EltSet.empty))

    let is_error (((_en1, _dis1), pre1), _m) = Caml.Option.is_none pre1 
    let error (((en1, dis1), _), m) = (((en1,dis1), Caml.Option.None), m) 

    (* MUST functions *)
    let must_map f (((en1, dis1), pre1), (m1, c1)) = 
        (((en1, dis1), pre1), (f m1, c1))

    let called_map f (((en1, dis1), pre1), (m1, c1)) = 
        (((en1, dis1), pre1), (m1, f c1))

    let must_get_f f (_, (m1, _)) = f m1 
    let _called_get_f f (_,(_, c1)) = f c1 

    
    let add_elts labels set = EltSet.union (EltSet.of_list labels) set 
    let rem_elts labels set = EltSet.diff set (EltSet.of_list labels)

    (* public *)
    let add_must labels sum = must_map (add_elts labels) sum 
    
    let rem_must labels sum = must_map (rem_elts labels) sum 

    let add_called labels sum = called_map (add_elts labels) sum 
    let rem_called labels sum = called_map (rem_elts labels) sum 

    let is_must_empty sum = must_get_f EltSet.is_empty sum 

    


end 

module type S = sig 

    include AbstractDomain.S 
    type sum 
    type label 

    val empty : t 

    val get_sum : t -> sum 
    val update_sum : sum -> t -> t 

    val add_error_proc_names: label -> t -> t         
    val add_error_must: label -> t -> t 

    val check_and_error_must: label -> t -> t*bool  


    val check_state: label -> t -> t*bool 

    val check_state2: label -> t -> bool

    val transition_check: label -> t -> t*bool 
    (* val transition_check_desctr: label -> t -> t*bool  *)


    val has_issue :  post:t -> bool 

    val reset2 : t -> t 
    val report_issue2 :  post:t -> string 
end 

module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (Label : PrettyPrintable.PrintableOrderedType) =
struct
    (* module LabelSet = LfaSet (Label)  *)
    module LabelSet = AbstractDomain.FiniteSet (Label) 


    module Sum = Summary (Label)

    module MapSummary = LfaMap (Key) (Summary (Label))

    module SomeLabelSet = DomainOpt2 (LabelSet)
    module ProcMap = LfaMap (Key) (SomeLabelSet)

    module ProcMapPair = AbstractDomain.Pair (ProcMap) (ProcMap) 

    type sum = MapSummary.t 
    type label = Key.t * LabelSet.t 

    (* must: proc map for may and for must *)

    module PairM = AbstractDomain.Pair (MapSummary) (ProcMapPair) 

    include PairM 


    let widen ~prev ~next ~num_iters = 
        if (Int.equal num_iters 1) then         
            join prev next else prev 
        (* join prev next       *)

                
    let pp fmt (summary, (proc_label, proc_label_map)) = 
        F.fprintf fmt "@\nSummary: %a @\nProcLabel: %a @\n ProcLabel: %a @\n" 
            MapSummary.pp summary ProcMap.pp proc_label ProcMap.pp proc_label_map

    let empty = (MapSummary.empty, (ProcMap.empty, ProcMap.empty))

    let get_sum astate = (fst astate) 
    let update_sum sum1 (_, proc_label0) = (sum1, proc_label0)


    let add_error_proc_names (ap, label_set) (sum0, (proc_label0, proc_label_must)) = 
       let proc_label1 = ProcMap.add ap (Caml.Option.Some label_set) proc_label0 in 
        (sum0, (proc_label1, proc_label_must))

    let add_error_must (ap, label_set) (sum0, (proc_label0, proc_label_must)) = 
        let proc_label_must1 = 
            ProcMap.add ap (Caml.Option.Some label_set) proc_label_must in 
        (sum0, (proc_label0, proc_label_must1))


    let check_and_error_must (ap, _label_set) astate =
        let (sum0, (_proc_label0, _proc_label_must)) = astate in  
        let ap_sum_opt = MapSummary.find_opt ap sum0 in 
        match ap_sum_opt with 
            | Some ap_sum -> 
                (* let must_set = Sum.get_must ap_sum in  *)
                (* let b = LabelSet.is_empty must_set in  *)
                let b = Sum.is_must_empty ap_sum in 
                let astate' = 
                    if (b) then 
                    astate 
                else 
                    let must_set = Sum.get_must ap_sum in 
                    add_error_must (ap, must_set) astate in 
                (astate',b) 
            | None -> (astate, true)


    let check_state2 label astate = 
        let (ap, _label_set) = label in 
        (* TODO: check must *)
        let (_, (label_map, _label_map_must)) = astate in
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        (match proc_ap_opt with 
        | None -> 
            true
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  false 
                            | None -> true))



    let check_state label astate = 
        let (ap, _label_set) = label in 
        let (sum0, (label_map, label_map_must)) = astate in
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        let some_label = Caml.Option.Some LabelSet.empty in 
        (match proc_ap_opt with 
        | None -> (astate, true) 
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  
                                let label_map' = ProcMap.add ap some_label label_map in 
                                let astate' = (sum0, (label_map', label_map_must)) in  
                                (astate', false)
                            | None ->  (astate, true))) 


    let transition_check label astate = 
        let (ap, label_set) = label in 
        let (sum0, (label_map, label_map_must)) = astate in
        let sum_ap_opt = MapSummary.find_opt ap sum0 in 
        (match sum_ap_opt with 
            | None -> (astate, true) 
            | Some sum_ap -> 
                let dis_set = Sum.get_dis sum_ap in 
                let diff = LabelSet.inter dis_set label_set in 
                if (LabelSet.is_empty diff) then 
                    let label_set_opt = ProcMap.find_opt ap label_map in 
                    (match label_set_opt with 
                    | None -> (astate, true)
                    | Some _ -> (astate, false))
                else 
                    let some_label =  Caml.Option.Some diff in 
                    let label_map' = ProcMap.add ap some_label label_map in 
                    ((sum0, (label_map', label_map_must)), false))

   


    let has_issue ~post:(_, (label_map, label_map_must)) = 
        if (ProcMap.is_empty label_map && ProcMap.is_empty label_map_must) then 
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
            let b1 = ProcMap.fold f label_map false in 
            let b2 = ProcMap.fold f label_map_must false in 
            b1 || b2 

     

    let reset2 (sum0, (label_map, label_map_must)) = 
        (* DEBUG begin *)
        let () = L.d_printfln "reset2 is called!!" in 
        (* DEBUG end *)
        let f some_label = 
            (match some_label with 
            | None -> None 
            | Some _ -> Some LabelSet.empty) in 
        let label_map1 =  ProcMap.map f label_map in 
            (sum0, (label_map1, label_map_must))

    let report_issue2 ~post:(_, (label_map, label_map_must)) = 
        (* check the difference between label_map and dom_map *)
        let f key some_labelset s = 
           (match some_labelset with 
            | None -> s 
            | Some labelset -> 
                F.asprintf "%s. Methods are not allowed: %a (for var: %a)" s LabelSet.pp labelset 
                Key.pp key) in 
        let must_map key some_labelset s = 
            (match some_labelset with 
            | None -> s 
            | Some labelset ->  F.asprintf "%s. Methods must be called: %a (for var: %a)" s LabelSet.pp labelset 
            Key.pp key) in 
        let s = ProcMap.fold f label_map "" in 
        let s' = ProcMap.fold must_map label_map_must s in s' 
    


end 

module DomainSummary = Make (AccessPath) (String) 

