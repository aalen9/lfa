(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd


(* val checker : IntraproceduralAnalysis.t -> unit *)

(* val checker : LtaCheckerDomain.S(String).t InterproceduralAnalysis.t -> LtaCheckerDomain.S(String).t option  *)
val checker : LtaCheckerDomain.DomainSummary.t  InterproceduralAnalysis.t -> LtaCheckerDomain.DomainSummary.t option


(* val is_active : unit -> bool  *)