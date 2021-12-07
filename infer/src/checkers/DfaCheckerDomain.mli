open! IStd 


module type DomainOptS = sig 
    include AbstractDomain.S 
end 


module DomainOpt (Domain : AbstractDomain.S) : DomainOptS with type t = Domain.t option 


    
    
module type DfaSetS = sig 
    include AbstractDomain.FiniteSetS 
end 

(* module DfaSet (Element : PrettyPrintable.PrintableOrderedType) : sig 
    include AbstractDomain.FiniteSetS with type elt = Element.t
end  *)

module DfaSet (Element : PrettyPrintable.PrintableOrderedType) : 
 DfaSetS with type t = AbstractDomain.FiniteSet(Element).t 
        and type elt = Element.t

(* naming a domain *)
module type DomainS = sig 
    (* domain should be just a set *)
    include AbstractDomain.FiniteSetS

end 



module Domain (State : PrettyPrintable.PrintableOrderedType) : DomainS 



(* map domain  *)
module DfaMap (Key : PrettyPrintable.PrintableOrderedType) 
    (ValueDomain : AbstractDomain.S) :
    AbstractDomain.MapS with type key = Key.t and type value = ValueDomain.t






module type S = sig 
    include AbstractDomain.S 


    (* type state 
    type key 

    module StateSet : DfaSetS with type elt := state 

    module Summary : AbstractDomain.MapS with type key := key 
                        and type value := StateSet.t  *)
    

    
    type dom
    type sum 
    type state 

    

    (* val error_state : state  *)
    val empty : t 
    
    val get_dom : t -> dom 
    val update_dom : dom -> t -> t 

    val get_sum : t -> sum 
    val update_sum : sum -> t -> t 

    (* val is_state_error : state -> bool  *)
    val reset2 : state -> state -> t -> t 
    val has_issue : is_state_error:(state -> bool) -> pre:t -> post:t -> bool 
    val report_issue2 : is_state_error:(state -> bool) -> pre:t -> post:t -> string 
end 




module Make (Key : PrettyPrintable.PrintableOrderedType) 
            (State : PrettyPrintable.PrintableOrderedType) : 
    S with type 
    dom = DfaMap(Key)(DfaSet(State)).t and 
    type state = State.t  
    and type sum = DfaMap(Key)(DfaMap(State)(DfaSet(State))).t 




module DomainSummary : S with type 
    dom = DfaMap(AccessPath)(DfaSet(String)).t and 
    type state = String.t and 
    type sum = DfaMap(AccessPath)(DfaMap(String)(DfaSet(String))).t 
    (* and type label = AccessPath.t*DfaSet(String).t  *)

