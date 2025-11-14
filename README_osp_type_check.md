# OSP Typed Connection Type Checking Plan

## Goal
Implement type checking for typed node connection syntax `source +>:EdgeType:+> target` (and directional variants `<+:EdgeType:<+`, `<+:EdgeType:+>`, `+>:EdgeType:<+`) such that:
- `EdgeType` resolves to an edge archetype (`edge EdgeType { ... }`).
- Provide a clear diagnostic if it is not an edge archetype.
- (Future) Validate provided connection assignment kwargs against the edge archetype's `has` members.

## Current Grammar & AST Summary
Grammar rules (excerpt):
```
connect: (connect (connect_op | disconnect_op))? atomic_pipe
connect_op: connect_from | connect_to | connect_any
connect_to: CARROW_R | CARROW_R_P1 expression (COLON kw_expr_list)? CARROW_R_P2
CARROW_R_P1: "+>:"
CARROW_R_P2: ":+>"
```
Typed connect uses `CARROW_*_P1 expression (COLON kw_expr_list)? CARROW_*_P2`.
AST Node: `ConnectOp(conn_type: Expr | None, conn_assign: AssignCompr | None, edge_dir: EdgeDir)` in `unitree.py`.
Normalization shows tokens inserted according to presence of `conn_type` and `conn_assign`.
Type checker currently lacks `exit_connect_op` hook; only `exit_edge_ref_trailer` is implemented for edge references.

## Proposed Implementation Steps (TODOs)
1. Add `exit_connect_op(self, node: uni.ConnectOp)` in `TypeCheckPass`.
2. If `node.conn_type` is present, obtain type via `self.evaluator.get_type_of_expression(node.conn_type)`.
3. Verify returned type is `jtypes.ClassType` and underlying archetype symbol category is `SymbolType.EDGE_ARCH`:
   - `cls.shared.symbol_table` is a `uni.Archetype` whose `sym_category == SymbolType.EDGE_ARCH`.
4. If check fails, emit error: `Connection type must be an edge archetype; got <class X>`.
5. If the type is an instance (`flags & Instance`), optionally allow but emit warning suggesting class reference (Clarify).
6. (Optional/Future) For `conn_assign` (kw_expr_list):
   - Resolve each kw key to a member symbol of the edge archetype; error if not found.
   - Type check value expression assignability to declared `has` var type.
7. (Optional/Future) Support generics on edge archetypes (`edge EdgeType[T]`): ensure provided type arguments are valid; instantiate specialized ClassType.
8. (Optional/Future) Ensure source/target operands are node archetype instances or references convertible to node objects; if not, diagnostic.
9. Add targeted test fixtures under `jac/jaclang/compiler/passes/main/tests/fixtures/`:
   - `connect_typed_valid.jac` (valid edge type)
   - `connect_typed_invalid_non_edge.jac` (uses object/walker/class)
   - `connect_typed_invalid_instance.jac` (if instance disallowed)
   - `connect_typed_assign_invalid_member.jac` (future)
10. Add tests in `test_checker_pass.py` asserting diagnostics and success cases.
11. Update release notes if this changes developer experience.

## Diagnostics Wording (Draft)
- Not edge: `Error: Connection type 'X' is not an edge archetype.`
- Unknown symbol: `Error: Connection type expression does not resolve to a known symbol.`
- Instance used (if discouraged): `Warning: Connection type is an instance; use edge class 'X' instead.`
- Bad kw key (future): `Error: Connection attribute 'k' not found in edge archetype 'EdgeType'.`

## Decisions (Confirmed)
1. Edge type may be class OR instance (no warning).
2. Source and target operands must be NODE INSTANCES (not classes); error otherwise.
3. Ignore generics for now (will add later).
4. Ignore connection assignment kwargs validation for now.
5. Skip value type compatibility for kwargs (ignored entirely for now).
6. Non-edge connection type -> hard error diagnostic.
7. Duplicate edge warnings: keep simple; optional light warning if obviously identical repeated connect in same block (TBD minimal logic, not to complicate PR).
8. All directional variants accepted; treat ANY (`<++>` typed) as undirected.
9. Abstract vs concrete edge both allowed.
10. Release notes: concise entry under "Type Checking Enhancements".

## Minimal Implementation Diff Outline
- Modify `type_checker_pass.py`: add `exit_connect_op` method.
- Import `SymbolType` to check edge category.
- Update tests & fixtures (only after clarifications).

## Next Steps
Implement `exit_connect_op` and add fixture + test.

---
Generated on 2025-11-14 for branch `osp-type-check`.
