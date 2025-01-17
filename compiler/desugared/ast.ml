(* This file is part of the Catala compiler, a specification language for tax and social benefits
   computation rules. Copyright (C) 2020 Inria, contributor: Nicolas Chataing
   <nicolas.chataing@ens.fr>

   Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except
   in compliance with the License. You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software distributed under the License
   is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
   or implied. See the License for the specific language governing permissions and limitations under
   the License. *)

(** Abstract syntax tree of the desugared representation *)

open Utils

(** {1 Names, Maps and Keys} *)

module IdentMap : Map.S with type key = String.t = Map.Make (String)

module RuleName : Uid.Id with type info = Uid.MarkedString.info = Uid.Make (Uid.MarkedString) ()

module RuleMap : Map.S with type key = RuleName.t = Map.Make (RuleName)

module RuleSet : Set.S with type elt = RuleName.t = Set.Make (RuleName)

module LabelName : Uid.Id with type info = Uid.MarkedString.info = Uid.Make (Uid.MarkedString) ()

module LabelMap : Map.S with type key = LabelName.t = Map.Make (LabelName)

module LabelSet : Set.S with type elt = LabelName.t = Set.Make (LabelName)

(** Inside a scope, a definition can refer either to a scope def, or a subscope def *)
module ScopeDef = struct
  type t =
    | Var of Scopelang.Ast.ScopeVar.t
    | SubScopeVar of Scopelang.Ast.SubScopeName.t * Scopelang.Ast.ScopeVar.t
        (** In this case, the [Uid.Var.t] lives inside the context of the subscope's original
            declaration *)

  let compare x y =
    match (x, y) with
    | Var x, Var y | Var x, SubScopeVar (_, y) | SubScopeVar (_, x), Var y ->
        Scopelang.Ast.ScopeVar.compare x y
    | SubScopeVar (x', x), SubScopeVar (y', y) ->
        let cmp = Scopelang.Ast.SubScopeName.compare x' y' in
        if cmp = 0 then Scopelang.Ast.ScopeVar.compare x y else cmp

  let get_position x =
    match x with
    | Var x -> Pos.get_position (Scopelang.Ast.ScopeVar.get_info x)
    | SubScopeVar (x, _) -> Pos.get_position (Scopelang.Ast.SubScopeName.get_info x)

  let format_t fmt x =
    match x with
    | Var v -> Scopelang.Ast.ScopeVar.format_t fmt v
    | SubScopeVar (s, v) ->
        Format.fprintf fmt "%a.%a" Scopelang.Ast.SubScopeName.format_t s
          Scopelang.Ast.ScopeVar.format_t v

  let hash x =
    match x with
    | Var v -> Scopelang.Ast.ScopeVar.hash v
    | SubScopeVar (w, v) -> Scopelang.Ast.SubScopeName.hash w * Scopelang.Ast.ScopeVar.hash v
end

module ScopeDefMap : Map.S with type key = ScopeDef.t = Map.Make (ScopeDef)

module ScopeDefSet : Set.S with type elt = ScopeDef.t = Set.Make (ScopeDef)

(** {1 AST} *)

type rule = {
  rule_id : RuleName.t;
  rule_just : Scopelang.Ast.expr Pos.marked Bindlib.box;
  rule_cons : Scopelang.Ast.expr Pos.marked Bindlib.box;
  rule_parameter : (Scopelang.Ast.Var.t * Scopelang.Ast.typ Pos.marked) option;
  rule_exception_to_rules : RuleSet.t Pos.marked;
}

let empty_rule (pos : Pos.t) (have_parameter : Scopelang.Ast.typ Pos.marked option) : rule =
  {
    rule_just = Bindlib.box (Scopelang.Ast.ELit (Dcalc.Ast.LBool false), pos);
    rule_cons = Bindlib.box (Scopelang.Ast.ELit Dcalc.Ast.LEmptyError, pos);
    rule_parameter =
      (match have_parameter with
      | Some typ -> Some (Scopelang.Ast.Var.make ("dummy", pos), typ)
      | None -> None);
    rule_exception_to_rules = (RuleSet.empty, pos);
    rule_id = RuleName.fresh ("empty", pos);
  }

let always_false_rule (pos : Pos.t) (have_parameter : Scopelang.Ast.typ Pos.marked option) : rule =
  {
    rule_just = Bindlib.box (Scopelang.Ast.ELit (Dcalc.Ast.LBool true), pos);
    rule_cons = Bindlib.box (Scopelang.Ast.ELit (Dcalc.Ast.LBool false), pos);
    rule_parameter =
      (match have_parameter with
      | Some typ -> Some (Scopelang.Ast.Var.make ("dummy", pos), typ)
      | None -> None);
    rule_exception_to_rules = (RuleSet.empty, pos);
    rule_id = RuleName.fresh ("always_false", pos);
  }

type assertion = Scopelang.Ast.expr Pos.marked Bindlib.box

type variation_typ = Increasing | Decreasing

type reference_typ = Decree | Law

type meta_assertion =
  | FixedBy of reference_typ Pos.marked
  | VariesWith of unit * variation_typ Pos.marked option

type scope_def = {
  scope_def_rules : rule RuleMap.t;
  scope_def_typ : Scopelang.Ast.typ Pos.marked;
  scope_def_is_condition : bool;
  scope_def_io : Scopelang.Ast.io;
  scope_def_label_groups : RuleSet.t LabelMap.t;
}

type scope = {
  scope_vars : Scopelang.Ast.ScopeVarSet.t;
  scope_sub_scopes : Scopelang.Ast.ScopeName.t Scopelang.Ast.SubScopeMap.t;
  scope_uid : Scopelang.Ast.ScopeName.t;
  scope_defs : scope_def ScopeDefMap.t;
  scope_assertions : assertion list;
  scope_meta_assertions : meta_assertion list;
}

type program = {
  program_scopes : scope Scopelang.Ast.ScopeMap.t;
  program_enums : Scopelang.Ast.enum_ctx;
  program_structs : Scopelang.Ast.struct_ctx;
}

let free_variables (def : rule RuleMap.t) : Pos.t ScopeDefMap.t =
  let add_locs (acc : Pos.t ScopeDefMap.t) (locs : Scopelang.Ast.LocationSet.t) :
      Pos.t ScopeDefMap.t =
    Scopelang.Ast.LocationSet.fold
      (fun (loc, loc_pos) acc ->
        ScopeDefMap.add
          (match loc with
          | Scopelang.Ast.ScopeVar v -> ScopeDef.Var (Pos.unmark v)
          | Scopelang.Ast.SubScopeVar (_, sub_index, sub_var) ->
              ScopeDef.SubScopeVar (Pos.unmark sub_index, Pos.unmark sub_var))
          loc_pos acc)
      locs acc
  in
  RuleMap.fold
    (fun _ rule acc ->
      let locs =
        Scopelang.Ast.LocationSet.union
          (Scopelang.Ast.locations_used (Bindlib.unbox rule.rule_just))
          (Scopelang.Ast.locations_used (Bindlib.unbox rule.rule_cons))
      in
      add_locs acc locs)
    def ScopeDefMap.empty
