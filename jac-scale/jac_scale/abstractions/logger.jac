"""Base logger abstraction for jac_scale.

All logger implementations should inherit from this class.
"""
import from typing { Any }

"""Base class for all logger implementations."""
class Logger {
    def info(self: Logger, message: str, context: dict[str, Any] = {}) -> None;
    def error(self: Logger, message: str, context: dict[str, Any] = {}) -> None;
    def warn(self: Logger, message: str, context: dict[str, Any] = {}) -> None;
    def debug(self: Logger, message: str, context: dict[str, Any] = {}) -> None;
}
