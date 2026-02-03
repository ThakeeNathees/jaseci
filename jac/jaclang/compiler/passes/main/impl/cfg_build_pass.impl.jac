impl CFGBuildPass.before_pass(self: CFGBuildPass) -> None {
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
    super.before_pass();
}

impl CFGBuildPass.exit_assignment(self: CFGBuildPass, node_: uni.UniNode) -> None {
    self.exit_nodes_of[node_] = [node_];
}

impl CFGBuildPass.exit_expr_stmt(self: CFGBuildPass, node_: uni.UniNode) -> None {
    self.exit_nodes_of[node_] = [node_];
}

impl CFGBuildPass.exit_module_code(self: CFGBuildPass, node_: uni.ModuleCode) -> None {
    exit_nodes = self._connect_list_of_stments(node_, node_.body);
    self.exit_nodes_of[node_] = exit_nodes;
}

impl CFGBuildPass.exit_if_stmt(self: CFGBuildPass, node_: uni.UniNode) -> None {
    # TODO: Check if the condition has type guards.
    next_true = self._get_first_cfg_node_of_list_of_statements(node_.body)
    or uni.CFGPatchNode(node_);
    next_false = self._get_first_cfg_node_of_list_of_statements(node_.else_body?.body)
    or uni.CFGPatchNode(node_);
    node_.set_next_conditional(next_true, next_false);
    if_body_exit_nodes = self._connect_list_of_stments(node_, node_.body);
    if isinstance(node_.else_body, (uni.ElseIf, uni.ElseStmt)) {
        else_body_exit_nodes = self._connect_list_of_stments(
            node_, node_.else_body?.body
        );
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

impl CFGBuildPass.exit_module(self: CFGBuildPass, node_: uni.UniNode) -> None {
    exit_of_module = self._connect_list_of_stments(node_, node_.body);
    self.exit_nodes_of[node_] = exit_of_module;
}

impl CFGBuildPass._get_first_cfg_node_of_list_of_statements(
    self: CFGBuildPass, nodes: list[uni.UniNode] | None
) -> uni.UniCFGNode | None {
    if nodes is None {
        return None;
    }
    for stmt in nodes {
        if isinstance(stmt, uni.UniCFGNode) {
            return stmt;
        }
    }
    return None;
}

impl CFGBuildPass._connect_list_of_stments(
    self: CFGBuildPass, origin: uni.UniCFGNode, nodes: list[uni.UniNode]
) -> list[uni.UniCFGNode] {
    # TODO: Handle return, break, continue, assert, raise, yield, await and jac specific control flows.
    _empty_list = [];
    for stmt in nodes {
        if not isinstance(stmt, uni.UniCFGNode) {
            continue;
        }
        for exit_node in self.exit_nodes_of.get(origin, _empty_list) {
            # Rewire the patch node.
            if isinstance(exit_node, uni.CFGPatchNode) {
                exit_node.patch_with(stmt);
                continue;
            }

            # Return or break
            if (
                isinstance(exit_node, uni.ReturnStmt)
                or (
                    isinstance(exit_node, uni.CtrlStmt) and (exit_node.is_break_stmt())
                )
            ) {
                # TODO: Mark all the other statements in this list as unreachable.
                return [exit_node];
            }

            exit_node.set_next(stmt);
        }
        origin = stmt;
    }
    return self.exit_nodes_of.get(origin, _empty_list);
}