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

    (* leq *)
    let leq ~lhs ~rhs = 
        match (lhs, rhs) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> (Domain.leq ~lhs:dom1 ~rhs:dom2) 
        | Caml.Option.None, _ -> false 
        | _, Caml.Option.None -> true 
     (* CHECK THIS, None should be greater than any other *)

    (* join *)
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

    (* leq *)
    let leq ~lhs ~rhs = 
        match (lhs, rhs) with 
        | Caml.Option.Some dom1, Caml.Option.Some dom2 -> (Domain.leq ~lhs:dom1 ~rhs:dom2) 
        | Caml.Option.None, _ -> false 
        | _, Caml.Option.None -> true 
     (* CHECK THIS, None should be greater than any other *)

    (* join *)
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
        (* | _, _ -> Caml.Option.None  *)


end 


(* map domain *)
module LtaMap (Key : PrettyPrintable.PrintableOrderedType) 
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

    (* let join astate1 astate2 = join1  *)
    let join astate1 astate2  =  
        join1 ~f:ValueDomain.join astate1 astate2 

    let widen ~prev ~next ~num_iters =
        join1 prev next 
        ~f:(fun prev next -> ValueDomain.widen ~prev ~next ~num_iters)


end 

module LtaSet (Element :  PrettyPrintable.PrintableOrderedType) = 
struct 
     (* include only functions that are necessary ? *) 
    include AbstractDomain.FiniteSet (Element) 
    (* module Set = AbstractDomain.FiniteSet (Element)  *)

    

    (* override join *)
    let join astate1 astate2 = inter astate1 astate2 
end 

module type DomainS = sig 
    (* module Element : PrettyPrintable.PrintableOrderedType *)

    type eltSet 
    type elt 

    include AbstractDomain.S 

    val init : elt list -> t 

    (* add element to the first set *)
    val add : elt -> t -> t 
    val add_set : eltSet -> t -> t

    (* add element to the second set *)
    val add2 : elt -> t -> t

    (* remove from the first set *)
    val remove : elt -> t -> t 
    val remove_set : eltSet -> t -> t

    (* val is_empty : t -> bool  *)
    
    (* val remove : Element.t -> t -> t *)

    val empty : t 

    val reset2 : t -> t 

    val has_issue : t -> bool  

    val has_issue2 : pre:t -> post:t -> bool 

    val report_issue2 : t -> string  

end 



module Domain (Element : PrettyPrintable.PrintableOrderedType) = 
struct

    module LtaSet1 = LtaSet (Element)
    module DomainSet = LtaSet (Element)  

    type eltSet = LtaSet1.t 
    type elt = Element.t 

    include AbstractDomain.Pair (DomainSet) (LtaSet1)

    (* for constructors *)
    let init alist = (LtaSet1.of_list alist, LtaSet1.empty)

    let add el (aset, bset) = (LtaSet1.add el aset, bset)
    let add_set elset (aset, bset) = (LtaSet1.union elset aset, bset)

    let add2 el (aset,_) = (aset, LtaSet1.singleton el)
    (* add2 *)

    let remove el (aset, bset) = (LtaSet1.remove el aset, bset)
    let remove_set elset (aset, bset) = (LtaSet1.inter aset elset, bset)

    (* let is_empty astate = astate |> fst |> Caml.Option.map LtaSet1.is_empty  *)

    (* let is_empty (aset, _bset) = Caml.Option.map (LtaSet1.is_empty) aset *)

    let empty = (LtaSet1.empty, LtaSet1.empty)
 
    let reset2 (aset, _) = (aset, LtaSet1.empty)

    let has_issue (aset, bset) = 
        LtaSet1.subset bset aset

    let has_issue2 ~pre:(aset1,_) ~post:(_,bset2) = 
            LtaSet1.subset bset2 aset1

    let report_issue2 (_aset, bset) = F.asprintf "Methods are not allowed: %a" LtaSet1.pp bset

end 


module type SummaryS = 
sig 
    include AbstractDomain.S

    type eltSet 
    type elt 

    val add_pre : elt -> t -> t 
    (* val is_none: t -> bool  *)
    val remove_pre : elt -> t -> t
    val mem_pre_en : elt -> t -> bool 
    val mem_pre_dis : elt -> t -> bool 
    
    (* val add_en : eltSet -> t -> t  *)
    (* val add_en_set : eltSet -> t -> t  *)
    val add_en : elt list -> t -> t  

    (* val add_dis_set : eltSet -> t -> t *)
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

    module EltSet = LtaSet (Element) 

    module StatePre = DomainOpt (EltSet)

    type eltSet = EltSet.t 
    type elt = Element.t 

    module Transf = AbstractDomain.Pair (EltSet) (EltSet) 

    include AbstractDomain.Pair (Transf) (StatePre)
    (* this should include t *)

    (* redefine join *)
    let join ((en1, dis1), pre1) ((en2,dis2), pre2) = 
        let dis = EltSet.union dis1 dis2 in 
        let en = EltSet.diff (EltSet.inter en1 en2) dis in 
        (* let pre = StatePre.join pre1 pre2 in  *)
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


    (* let add_en_set set_labels ((en1,dis1), pre1) = 
        ((EltSet.union set_labels en1, dis1), pre1) *)

    let add_en labels ((en1,dis1), pre1) = 
        ((EltSet.union (EltSet.of_list labels) en1, dis1), pre1) 

    (* let add_dis_set set_labels ((en1,dis1), pre1) = 
        ((en1, EltSet.union set_labels dis1), pre1)  *)

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

    (* let is_none (_, pre1) = 
        match pre1 with 
        | Some _ -> false 
        | None -> true  *)



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
    type dom
    type sum 
    type label 

    val empty : t 
    
    val get_dom : t -> dom 
    val update_dom : dom -> t -> t 

    val get_sum : t -> sum 
    val update_sum : sum -> t -> t 

    val add_error_proc_names: label -> t -> t 

    val check_state: label -> t -> t*bool 

    val check_state2: label -> t -> bool

    val transition_check: label -> t -> t


    val has_issue :  post:t -> bool 
    (* val add2 : label -> t -> t  *)
    (* val add3 : label -> t -> t  *)

    val reset2 : t -> t 
    val report_issue2 :  post:t -> string 
end 

(* module PPair (Fst : PrettyPrintable.PrintableOrderedType) 
            (Snd : PrettyPrintable.PrintableOrderedType) = 
struct 

    type t = Fst.t * Snd.t 

    let pp fmt p = F.fprintf fmt "AP is: %a, Label is: %a" Fst.pp (fst p) Snd.pp (snd p)
    (* let compare _p1 _p2 = 0  *)
end  *)

module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (Label : PrettyPrintable.PrintableOrderedType) =
struct
    module LabelSet = LtaSet (Label) 

    module MapDomain = LtaMap (Key) (LtaSet (Label))
    module MapSummary = LtaMap (Key) (Summary (Label))

    module SomeLabelSet = DomainOpt2 (LabelSet)
    module ProcMap = LtaMap (Key) (SomeLabelSet)


    module MS = AbstractDomain.Pair (MapDomain) (MapSummary) 

    type dom = MapDomain.t  
    type sum = MapSummary.t 
    type label = Key.t * LabelSet.t 

    include AbstractDomain.Pair (MS) (ProcMap) 

                
    let pp fmt ((dom, summary), proc_label) = 
        F.fprintf fmt "@\nDom: %a @\nSummary: %a @\nProcLabel: %a @\n" 
                    MapDomain.pp dom MapSummary.pp summary ProcMap.pp proc_label 

    let empty = ((MapDomain.empty, MapSummary.empty), ProcMap.empty)

    let get_dom ((dom1,_),_) = dom1 
    let update_dom dom1 ((_, sum0), proc_label0) = ((dom1, sum0), proc_label0)

    let get_sum astate = snd (fst astate) 
    let update_sum sum1 ((dom0, _), proc_label0) = ((dom0, sum1), proc_label0)

    let add_error_proc_names (ap, label_set) ((dom0, sum0), proc_label0) = 
       let proc_label1 = ProcMap.add ap (Caml.Option.Some label_set) proc_label0 in 
       ((dom0, sum0), proc_label1)


    let check_state2 label astate = 
        let (ap, _label_set) = label in 
        let (_, label_map) = astate in
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        (* let some_label = Caml.Option.Some LabelSet.empty in  *)
        (match proc_ap_opt with 
        | None -> 
            (* let () = L.d_printfln "CHECK_STATE: NONE 1" in  *)
            true
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  false 
                                (* let () = L.d_printfln "CHECK_STATE: SOME 1" in 
                                let label_map' = ProcMap.add ap some_label label_map in 
                                let astate' = ((dom0, sum0), label_map') in  
                                (astate', false) *)
                            | None -> true))


    (* first call this when a method is called *)
    let check_state label astate = 
        let () = L.d_printfln "CHECK_STATE\n" in 
        let (ap, _label_set) = label in 
        let () = L.d_printfln "ASTATE IS: %a\n" pp astate in 
        let ((dom0, sum0), label_map) = astate in
        let () = L.d_printfln "ap is: %a\n" Key.pp ap in 
        let () = L.d_printfln "label_map is: %a" ProcMap.pp label_map in 
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        let some_label = Caml.Option.Some LabelSet.empty in 
        (match proc_ap_opt with 
        | None -> 
            let () = L.d_printfln "CHECK_STATE: NONE 1" in 
            (astate, true) 
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  
                                let () = L.d_printfln "CHECK_STATE: SOME 1" in 
                                let label_map' = ProcMap.add ap some_label label_map in 
                                let astate' = ((dom0, sum0), label_map') in  
                                (astate', false)
                                (* let update some_some_label_set = 
                                    Caml.Option.map (fun _ -> some_label) some_some_label_set in 
                                    let label_map' = 
                                        ProcMap.update ap update label_map in 
                                    let astate'= ((dom0, sum0), label_map') in 
                                    (astate', false) *)
                            | None -> 
                                let () = L.d_printfln "CHECK_STATE: NONE 2" in 
                                (astate, true))) 


    let transition_check label astate = 
        (* this is first thing to do when method is called *)
        let (ap, label_set) = label in 
        (* first check if it is already Some () for this label *)
        (* if it is put Some {} *)
        let ((dom0, sum0), label_map) = astate in
        (* let proc_ap_opt = ProcMap.find_opt ap label_map in 
        let b = (
            match proc_ap_opt with 
            | None -> astate 
            | Some proc_ap -> (match proc_ap with 
                                | Some set -> LabelSet.is_empty set 
                                | None -> false) 
        ) in  *)
        let dom_ap_opt = MapDomain.find_opt ap dom0 in 
        let () =  L.d_printfln "IN TRANSITION CHECK\n" in 
        (match dom_ap_opt with 
        | None -> astate 
        | Some dom_ap -> 
            let diff = LabelSet.diff label_set dom_ap in 
            if (LabelSet.is_empty diff) then 
                astate 
            else
                let () =  L.d_printfln "IN TRANSITION CHECK: ERROR\n" in 
                let some_label =  Caml.Option.Some diff in 
                (* let update some_some_label_set = 
                    (match some_some_label_set with 
                    | None -> Some some_label 
                    | ) *)
                    (* Caml.Option.map (fun _ -> some_label) some_some_label_set in  *)
                (* let label_map' = ProcMap.update ap update label_map in  *)
                let label_map' = ProcMap.add ap some_label label_map in 
                ((dom0, sum0), label_map') 
        )


    let has_issue ~post:((_,_), label_map) = 
        let () = debug "in has_issue\n" in 
        if (ProcMap.is_empty label_map) then 
            false 
        else 
            let f _key some_labelset b = 
                (* check if label_map key has Some non empty set *)
                (match some_labelset with 
                | Some labelset -> 
                    if (LabelSet.is_empty labelset) then 
                        let () = debug "empty label set\n" in 
                        b 
                    else 
                        let () = debug "non empty label set\n" in 
                        true 
                | None -> b
                ) in 
            ProcMap.fold f label_map false 

        
    (* let add2 (ap, label_set) ((dom0, sum0), label_map) = 
        let label_map' = ProcMap.add ap label_set label_map in 
        ((dom0,sum0), label_map') *)
    (* let foo ap astate =  *)
     (* let () = L.d_printfln "CHECK_STATE\n" in 
        let (ap, _label_set) = label in 
        let () = L.d_printfln "ASTATE IS: %a\n" pp astate in 
        let ((dom0, sum0), label_map) = astate in
        let () = L.d_printfln "ap is: %a\n" Key.pp ap in 
        let () = L.d_printfln "label_map is: %a" ProcMap.pp label_map in 
        let proc_ap_opt = ProcMap.find_opt ap label_map in 
        let some_label = Caml.Option.Some LabelSet.empty in 
        (match proc_ap_opt with 
        | None -> 
            let () = L.d_printfln "CHECK_STATE: NONE 1" in 
            (astate, true) 
        | Some proc_ap -> (match proc_ap with 
                            | Some _ ->  
                                let () = L.d_printfln "CHECK_STATE: SOME 1" in 
                                let label_map' = ProcMap.add ap some_label label_map in 
                                let astate' = ((dom0, sum0), label_map') in  
                                (astate', false)
                                (* let update some_some_label_set = 
                                    Caml.Option.map (fun _ -> some_label) some_some_label_set in 
                                    let label_map' = 
                                        ProcMap.update ap update label_map in 
                                    let astate'= ((dom0, sum0), label_map') in 
                                    (astate', false) *)
                            | None -> 
                                let () = L.d_printfln "CHECK_STATE: NONE 2" in 
                                (astate, true)))  *)

    (* let reset2 ((dom0, sum0), _) = ((dom0, sum0), ProcMap.empty) *)
    let reset2 ((dom, sum0), label_map) = 
        let f some_label = 
            (match some_label with 
            | None -> None 
            | Some _ -> Some LabelSet.empty) in 
           let label_map1 =  ProcMap.map f label_map in 
           ((dom, sum0), label_map1)

    let report_issue2 ~post:((_, _), label_map) = 
        (* check the difference between label_map and dom_map *)
        let f key some_labelset s = 
            (* if it has some *)
           (match some_labelset with 
            | None -> s 
            | Some labelset -> 
                F.asprintf "%s. Methods for var: %a are now allowed: %a" s Key.pp key 
                LabelSet.pp labelset) in 
        ProcMap.fold f label_map ""

    (* summary computation *)
    (* TODO *)
    


end 

module DomainSummary = Make (AccessPath) (String) 

