(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd


(* val checker : IntraproceduralAnalysis.t -> unit *)

(* val checker : DfaCheckerDomain.S(String).t InterproceduralAnalysis.t -> DfaCheckerDomain.S(String).t option  *)
val checker : DfaCheckerDomain.DomainSummary.t  InterproceduralAnalysis.t -> DfaCheckerDomain.DomainSummary.t option
