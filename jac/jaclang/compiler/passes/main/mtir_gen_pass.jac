"""Jac MTIR Generation Pass.

This module defines the MTIRGenPass class for generating MTIR (Method Type
Information Registry) from JacLang code. The pass extracts type information
from GenAI abilities for use by the LLM runtime.
"""

import jaclang.pycore.unitree as uni;
import from jaclang.pycore.mtp {
    ClassInfo,
    EnumInfo,
    FieldInfo,
    FunctionInfo,
    MethodInfo,
    ParamInfo,
    mk_dict,
    mk_list,
    mk_tuple,
    type_to_str
}

import from jaclang.pycore.passes { UniPass }

glob PRIMITIVE_TYPES: list[str] = [
         'int',
         'float',
         'str',
         'bool',
         'None',
         'bytes',
         'list',
         'dict',
         'set',
         'tuple'
     ];

"""Jac MTIR Generation Pass."""
obj MTIRGenPass(UniPass) {
    has ir_in: uni.Module,
        prog: Any,
        cancel_token: Any = None;

    def postinit -> None;
    def _is_primitive_type(type_expr: uni.Expr | None) -> bool;
    def _parse_type_expr(
        type_expr: uni.Expr | None, scope: uni.UniScopeNode
    ) -> ClassInfo | str | tuple | None;

    def _extract_type_symbol(
        type_expr: uni.Expr | None, scope: uni.UniScopeNode
    ) -> uni.Symbol | None;

    def _extract_enum_info(symbol: uni.Symbol) -> EnumInfo;
    def _extract_class_info(symbol: uni.Symbol) -> ClassInfo | None;
    def _extract_function_info(node: uni.Ability) -> FunctionInfo;
    def _extract_method_info(node: uni.Ability, by_call: bool = False) -> MethodInfo;
    def _get_scope_str(node: uni.UniScopeNode) -> str;
    def _extract_tools_from_expr(
        expr: uni.Expr, scope: uni.UniScopeNode
    ) -> list[FunctionInfo];

    def enter_ability(node: uni.Ability) -> None;
}
