open! IStd 


module type DomainOptS = sig 
    include AbstractDomain.S 
end 


module DomainOpt (Domain : AbstractDomain.S) : DomainOptS with type t = Domain.t option 
module DomainOpt2 (Domain : AbstractDomain.S) : DomainOptS with type t = Domain.t option 



module LfaMap (Key : PrettyPrintable.PrintableOrderedType) (ValueDomain : AbstractDomain.S) :
    AbstractDomain.MapS with type key = Key.t and type value = ValueDomain.t 
    

module LfaSet (Element : PrettyPrintable.PrintableOrderedType) : sig 
    include AbstractDomain.FiniteSetS with type elt = Element.t
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

module Summary (Element : PrettyPrintable.PrintableOrderedType) : 
    SummaryS with type eltSet = LfaSet(Element).t 
                and type elt = Element.t  
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
        (* val has_issue *)
    
        val reset2 : t -> t 
        val report_issue2 :  post:t -> string 

        (* val get_ap_sum :  *)
    end 



module Make (Key : PrettyPrintable.PrintableOrderedType) 
                (Label : PrettyPrintable.PrintableOrderedType) : 
    S with 
     type sum = LfaMap(Key)(Summary(Label)).t 
    and type label = Key.t * LfaSet(Label).t 


module DomainSummary : S with 
    type sum = LfaMap(AccessPath)(Summary(String)).t 
    and type label = AccessPath.t*LfaSet(String).t 

