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

module type DfaSetS = sig 
    include AbstractDomain.FiniteSetS 
end 

module DfaSet (Element :  PrettyPrintable.PrintableOrderedType) : 
    DfaSetS with type t = AbstractDomain.FiniteSet(Element).t 
        and type elt = Element.t = 
struct 
    include AbstractDomain.FiniteSet (Element) 

    let join astate1 astate2 = 
        if (is_empty astate1 || is_empty astate2) then 
                empty 
            else  
        union astate1 astate2 
end 


module type DomainS = sig 
    include AbstractDomain.FiniteSetS

end 


module Domain (State : PrettyPrintable.PrintableOrderedType)  = 
struct
    include DfaSet (State) 
end 


module DfaMap (Key : PrettyPrintable.PrintableOrderedType) 
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


module type S = sig 
    include AbstractDomain.S 
    type dom
    type sum 
    type sum_elt 
    type state 

    val empty : t 
    
    val get_dom : t -> dom 
    val update_dom : dom -> t -> t 

    val get_sum : t -> sum 
    val update_sum : sum -> t -> t 

    val reset2 : state -> state -> t -> t 
    val has_issue : is_state_error:(state -> bool) -> is_all_error:(sum_elt -> bool) -> pre:t -> post:t -> bool 
    val has_issue2 : is_state_error:(state -> bool) -> pre:t -> post:t -> bool 
    val report_issue2 : is_state_error:(state -> bool) -> is_all_error:(sum_elt -> bool) -> pre:t -> post:t -> string 
    val report_issue3 : is_state_error:(state -> bool) -> pre:t -> post:t -> string 
end 


module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (State : PrettyPrintable.PrintableOrderedType) =
struct

    module Domain = DfaSet (State)

    module MapDomain = DfaMap (Key) (DfaSet (State))
    module MapSummary = DfaMap (Key) (DfaMap (State) (DfaSet (State)))

    type dom = MapDomain.t  
    type sum = MapSummary.t 
    type state = Domain.elt 
    type sum_elt = MapSummary.value 


    include AbstractDomain.Pair (MapDomain) (MapSummary) 

                
    let pp fmt (dom, summary) = 
        F.fprintf fmt "@\nDom: %a @\nSummary: %a\n" 
            MapDomain.pp dom MapSummary.pp summary 

    let empty = (MapDomain.empty, MapSummary.empty)

    let get_dom (dom, _) = dom
    let update_dom dom (_, sum0) = (dom, sum0)

    let get_sum astate = snd astate
    let update_sum sum1 (dom0, _) = (dom0, sum1)


    let has_issue ~is_state_error:f ~is_all_error:f2 ~pre:(_, _) ~post:(dom_map, sum_map) =   
        let fmap _key dom = Domain.exists f dom in  
        let fsum _key sum = f2 sum in 
        if (MapSummary.is_empty sum_map) then 
            MapDomain.exists fmap dom_map 
        else 
            MapSummary.exists fsum sum_map
        (* MapDomain.exists fmap dom_map || MapSummary.exists fsum sum_map *)

    let has_issue2 ~is_state_error:f ~pre:(_, _) ~post:(dom_map, _) =   
        let fmap _key dom = Domain.exists f dom in  
        MapDomain.exists fmap dom_map 

    let reset2 state_error state_handled astate = 
        let (dom_map, sum_map) = astate in 
        let f set = 
            if (Domain.mem state_error set) then 
                Domain.singleton state_handled else 
                set in 
        let dom_map' = MapDomain.map f dom_map in 
         (dom_map', sum_map) 
             

    let report_issue2 ~is_state_error:f ~is_all_error:f2 ~pre:(_dom_map0, _) 
    ~post:(dom_map1, sum_map1) =
        let fmap key dom s = 
            if (Domain.exists f dom) then 
                F.asprintf "%s. Var: %a is in error state" s Key.pp key 
            else 
                s in
        let fmap_sum key sum s = 
            if (f2 sum) then 
                F.asprintf "%s. Var: %a is in error state" s Key.pp key  
        else 
            s in 
        let s' = MapDomain.fold fmap dom_map1 "" in 
            MapSummary.fold fmap_sum sum_map1 s' 

    let report_issue3 ~is_state_error:f ~pre:(_dom_map0, _) 
    ~post:(dom_map1, _sum_map1) =
        let fmap key dom s = 
            if (Domain.exists f dom) then 
                F.asprintf "%s. Var: %a is in error state" s Key.pp key 
            else 
                s in
        MapDomain.fold fmap dom_map1 ""   
end 

module DomainSummary = Make (AccessPath) (String) 

