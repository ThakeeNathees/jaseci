"""Tests for type system __str__ methods."""

from pathlib import Path

from jaclang.compiler.type_system import types


def test_unbound_type_str() -> None:
    """Test UnboundType __str__ method."""
    unbound = types.UnboundType()
    assert str(unbound) == "<Unbound>"


def test_unknown_type_str() -> None:
    """Test UnknownType __str__ method."""
    unknown = types.UnknownType()
    assert str(unknown) == "<Unknown>"


def test_never_type_str() -> None:
    """Test NeverType __str__ method."""
    never = types.NeverType()
    assert str(never) == "<Never>"


def test_any_type_str() -> None:
    """Test AnyType __str__ method."""
    any_type = types.AnyType()
    assert str(any_type) == "<Any>"


def test_type_var_type_str() -> None:
    """Test TypeVarType __str__ method."""
    type_var = types.TypeVarType()
    assert str(type_var) == "<TypeVar>"


def test_module_type_str() -> None:
    """Test ModuleType __str__ method."""
    # Test with mod_name
    module1 = types.ModuleType(mod_name="test_module")
    assert str(module1) == "<module test_module>"
    
    # Test with file_uri
    module2 = types.ModuleType(file_uri=Path("/path/to/module.jac"))
    assert str(module2) == "<module /path/to/module.jac>"
    
    # Test with empty/default values
    module3 = types.ModuleType()
    assert str(module3) == "<module>"


def test_function_type_str() -> None:
    """Test FunctionType __str__ method."""
    # Test function with no parameters
    func1 = types.FunctionType(func_name="test_func")
    assert str(func1) == "<function test_func()>"
    
    # Test function with parameters
    param1 = types.Parameter(
        name="x",
        category=types.ParameterCategory.Positional,
        param_type=types.AnyType(),
    )
    param2 = types.Parameter(
        name="y",
        category=types.ParameterCategory.Positional,
        param_type=types.AnyType(),
    )
    func2 = types.FunctionType(
        func_name="add",
        parameters=[param1, param2],
        return_type=types.AnyType(),
    )
    assert str(func2) == "<function add(x: <Any>, y: <Any>) -> <Any>>"
    
    # Test function with return type only
    func3 = types.FunctionType(
        func_name="get_value",
        return_type=types.AnyType(),
    )
    assert str(func3) == "<function get_value() -> <Any>>"
    
    # Test anonymous function
    func4 = types.FunctionType()
    assert str(func4) == "<function <anonymous>()>"


def test_overloaded_type_str() -> None:
    """Test OverloadedType __str__ method."""
    # Test with no overloads
    overload1 = types.OverloadedType()
    assert str(overload1) == "<overload 0 overloads>"
    
    # Test with overloads
    func1 = types.FunctionType(func_name="test")
    func2 = types.FunctionType(func_name="test")
    overload2 = types.OverloadedType(overloads=[func1, func2])
    assert str(overload2) == "<overload 2 overloads>"


def test_union_type_str() -> None:
    """Test UnionType __str__ method."""
    # Test empty union
    union1 = types.UnionType(types=[])
    assert str(union1) == "<Union>"
    
    # Test union with types
    int_type = types.AnyType()  # Using AnyType as placeholder
    str_type = types.AnyType()
    union2 = types.UnionType(types=[int_type, str_type])
    # Since both are AnyType, they'll both stringify to "<Any>"
    assert str(union2) == "<Any> | <Any>"
    
    # Test union with different types
    union3 = types.UnionType(types=[
        types.UnknownType(),
        types.NeverType(),
        types.AnyType(),
    ])
    assert str(union3) == "<Unknown> | <Never> | <Any>"


def test_class_type_str() -> None:
    """Test ClassType __str__ method (already existed)."""
    # Create a minimal ClassType for testing
    # Note: ClassType requires a proper symbol_table (UniScopeNode)
    # We'll use unittest.mock to create a minimal mock
    from unittest.mock import MagicMock
    from jaclang.pycore.unitree import Module
    
    # Create a mock symbol table with required attributes
    mock_module = MagicMock(spec=Module)
    mock_module.names_in_scope = {}
    mock_module.names_in_scope_overload = {}
    
    shared = types.ClassType.ClassDetailsShared(
        class_name="TestClass",
        symbol_table=mock_module,
        mro=[],
    )
    class_type = types.ClassType(shared=shared)
    assert str(class_type) == "<class TestClass>"
