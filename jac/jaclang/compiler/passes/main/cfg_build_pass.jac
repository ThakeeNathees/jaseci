"""Control flow graph build pass for the Jac compiler."""
import from jaclang.pycore.passes { UniPass }

"""Jac CFG build pass."""
obj CFGBuildPass(UniPass) {
    def init(ir_in: uni.Module, prog: Any, cancel_token: Any = None) -> None;
}
