open! IStd 


module type DomainOptS = sig 
    include AbstractDomain.S 
    (* val is_none : t -> bool  *)
    (* val none : t  *)
end 


module DomainOpt (Domain : AbstractDomain.S) : DomainOptS with type t = Domain.t option 
module DomainOpt2 (Domain : AbstractDomain.S) : DomainOptS with type t = Domain.t option 



(* map domain  *)
module LtaMap (Key : PrettyPrintable.PrintableOrderedType) (ValueDomain : AbstractDomain.S) :
    AbstractDomain.MapS with type key = Key.t and type value = ValueDomain.t 
    (* and type t = t  *)
    

module LtaSet (Element : PrettyPrintable.PrintableOrderedType) : sig 
    include AbstractDomain.FiniteSetS with type elt = Element.t
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


    val empty : t 

    val reset2 : t -> t 

    val has_issue : t -> bool  

    val has_issue2 : pre:t -> post:t -> bool 

    val report_issue2 : t -> string  

end 



module Domain (Element : PrettyPrintable.PrintableOrderedType) : 
    DomainS with type elt = Element.t 
                and type eltSet = LtaSet(Element).t 
(* sig 
    include DomainS with type t := 
        and type elt := Element.t 
end  *)

module type SummaryS = 
sig 
    include AbstractDomain.S

    type eltSet 
    type elt 

    val add_pre : elt -> t -> t 
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

module Summary (Element : PrettyPrintable.PrintableOrderedType) : 
    SummaryS with type eltSet = LtaSet(Element).t 
                and type elt = Element.t  


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
            (Snd : PrettyPrintable.PrintableOrderedType) : 
        PrettyPrintable.PrintableType with type t = Fst.t * Snd.t  *)


module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (Label : PrettyPrintable.PrintableOrderedType) : 
    S with type 
    dom = LtaMap(Key)(LtaSet(Label)).t 
    and type sum = LtaMap(Key)(Summary(Label)).t 
    and type label = Key.t * LtaSet(Label).t 




module DomainSummary : S with type 
    dom = LtaMap(AccessPath)(LtaSet(String)).t 
    and type sum = LtaMap(AccessPath)(Summary(String)).t 
    and type label = AccessPath.t*LtaSet(String).t 

