"""Control flow graph build pass for the Jac compiler."""

import jaclang.pycore.unitree as uni;
import from jaclang.pycore.passes { UniPass }

"""Jac Symbol table build pass."""
obj CFGBuildPass(UniPass) {
    def init(ir_in: uni.Module, prog: Any, cancel_token: Any = None) -> None;

    def before_pass -> None;

    def exit_assignment(self, node_: uni.UniNode) -> None;
    def exit_expr_stmt(self, node_: uni.UniNode) -> None;

    def exit_module(self, node_: uni.UniNode) -> None;

    def _connect_list_of_stments(self, nodes: list[uni.UniNode]) -> None;

}
