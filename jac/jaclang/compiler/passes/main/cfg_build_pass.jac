"""Control flow graph build pass for the Jac compiler."""

import jaclang.pycore.unitree as uni;
import from jaclang.pycore.passes { UniPass }

"""Jac Symbol table build pass."""
obj CFGBuildPass(UniPass) {
    def init(ir_in: uni.Module, prog: Any, cancel_token: Any = None) -> None;
}
