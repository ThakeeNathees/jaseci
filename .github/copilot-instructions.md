# Copilot Instructions (General)

## Scope and Priorities

- Primary development happens in `jac/` (compiler, runtime, language server).
- Other packages (`jac-byllm/`, `jac-cloud/`, `jac-streamlit/`, `jac-client/`) are not in scope for this guide.
- For type system work, use the dedicated guide at `.github/agents/type-system-agent.md`.

## Architecture at a Glance

- Grammar and parsing: `jac/jaclang/compiler/jac.lark`, `parser.py`, `larkparse/`.
- Intermediate representation: `unitree.py` (UniTree nodes shared across passes).
- Pass pipeline: `jac/jaclang/compiler/passes/main/` (symbol table, decl/impl match, codegen, type check).
- Codegen: `pyast_gen_pass.py` (emits Python AST), `pybc_gen_pass.py`.

## Core Workflows

- Run compiler tests:
    ```bash
    pytest -n auto jac
    ```
- Run pre-commit checks:
    ```bash
    ./scripts/check.sh
    ```
- Full test sweep:
    ```bash
    ./scripts/tests.sh
    ```

## Conventions

- Passes subclass `Transform`/`UniPass` and implement `enter_*`/`exit_*` hooks.
- Test fixtures live under `jac/jaclang/compiler/**/tests/fixtures/`.
- Jac import syntax differs from Python:
    ```jac
    import from module { symbol, another_symbol }
    import module as alias;
    ```
- Entry point block:
    ```jac
    with entry { /* ... */ }
    ```

## PR and Release Notes

- Every PR that affects Jac developer experience must add a concise, one-line bullet under `## jaclang <version> (Unreleased)` in `docs/docs/communityhub/release_notes/jaclang.md`.
- Group related bullets under sections like “Type Checking Enhancements” when appropriate.

## Useful References

- Pass orchestration: `passes/main/type_checker_pass.py`, `passes/main/pyast_gen_pass.py`.
- Type system entry points: `compiler/type_system/` (see the dedicated agent doc).
- Examples of Jac language features: `jac/examples/reference/` and `jac/examples/*`.

For type system work, open `.github/agents/type-system-agent.md`.
