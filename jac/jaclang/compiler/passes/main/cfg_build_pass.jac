"""Control flow graph build pass for the Jac compiler."""

import jaclang.pycore.unitree as uni;
import from jaclang.pycore.passes { UniPass }

"""Jac Symbol table build pass."""
class CFGBuildPass(UniPass) {
    def before_pass(self: CFGBuildPass) -> None;

    # Simple statements
    def exit_assignment(self: CFGBuildPass, node_: uni.UniNode) -> None;
    def exit_expr_stmt(self: CFGBuildPass, node_: uni.UniNode) -> None;

    # Compound statements
    def exit_module_code(self: CFGBuildPass, node_: uni.ModuleCode) -> None;
    def exit_if_stmt(self: CFGBuildPass, node_: uni.UniNode) -> None;

    def exit_module(self: CFGBuildPass, node_: uni.UniNode) -> None;

    # If we have a list of statement in a body block and need the reference to the first node
    # to connect from the higher level node, this method will be the helper to get the first cfg node.
    # the nodes parameter can also be None since the body of certain nodes (if-statement) is None instead
    # of an emtpy list.
    def _get_first_cfg_node_of_list_of_statements(self: CFGBuildPass, nodes: list[uni.UniNode] | None) -> uni.UniCFGNode | None;

    # This will connect a list of statement in a body block one and nother and return all the
    # exit node from the entire sequence.
    def _connect_list_of_stments(self: CFGBuildPass, origin: uni.UniCFGNode, nodes: list[uni.UniNode]) -> list[uni.UniCFGNode];

}
