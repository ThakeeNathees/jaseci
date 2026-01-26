impl CFGBuildPass.init(ir_in: uni.Module, prog: Any, cancel_token: Any = None) -> None {
    super.init(ir_in, prog, cancel_token);
}

impl CFGBuildPass.before_pass() -> None {

    # This is the registry of all the nodes that would exit
    # from the given node, while we're processing the node we never
    # know where all the exit pointers are connected while a higher
    # level node is processed, we use this registry to keep track of that.
    #
    #        The node
    #          |
    #          V
    #     +------------------------+
    # --> |                        | --> \
    # --> | if [cond] ... else ... | -->  > --> All the exit nodes that
    # --> |                        | --> /     we need the references of.
    #     +------------------------+
    #
    # exit_nodes = self.exit_nodes_of[if_node]
    #
    self.exit_nodes_of: dict[uni.UniNode, list[uni.UniCFGNode]] = {};
}


impl CFGBuildPass.exit_assignment(self, node_: uni.UniNode) -> None {
    self.exit_nodes_of[node_] = [node_];
}


impl CFGBuildPass.exit_expr_stmt(self, node_: uni.UniNode) -> None {
    self.exit_nodes_of[node_] = [node_];
}


impl CFGBuildPass.exit_if_stmt(self, node_: uni.UniNode) -> None {
    # TODO: Check if the condition has type guards.
    if_body_exit_nodes = self._connect_list_of_stments(node_, node_.body);
    if isinstance(node_.else_body, (uni.ElseIf, uni.ElseStmt)) {
        else_body_exit_nodes = self._connect_list_of_stments(node_, node_.else_body.body);
    } else {
        else_body_exit_nodes = [];
    }

    #
    # +-------------------------------------------+
    # | [if_body]   ==> if_body_exit_nodes =====\ |
    # |                                          |===> Combined exit nodes.
    # | [else_body] ==> else_body_exit_nodes ===/ |
    # +-------------------------------------------+
    #
    self.exit_nodes_of[node_] = [*if_body_exit_nodes, *else_body_exit_nodes];
}


impl CFGBuildPass.exit_module(self, node_: uni.UniNode) -> None {
    exit_of_module = self._connect_list_of_stments(node_, node_.body);
    self.exit_nodes_of[node_] = exit_of_module;
}


impl CFGBuildPass._connect_list_of_stments(self, origin: uni.UniCFGNode, nodes: list[uni.UniNode]) -> list[uni.UniCFGNode] {
    # TODO: Handle return, break, continue, assert, raise, yield, await and jac specific control flows.
    _empty_list = [];
    for stmt in nodes {
        if not isinstance(stmt, uni.UniCFGNode) {
            continue;
        }
        for exit_node in self.exit_nodes_of.get(origin, _empty_list) {
            exit_node.set_next(stmt);
        }
        origin = stmt;
    }
    return self.exit_nodes_of.get(origin, _empty_list);
}
