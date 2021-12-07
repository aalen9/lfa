(*
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *)

open! IStd

val parse_infer_deps : build_report_file:string -> string list
(** parse a JSON build report by buck and return all capture DBs found in the [infer_deps.txt]
    format *)
