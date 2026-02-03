"""Target registry for build targets (web, desktop, mobile, etc.).

This module provides a registry system for managing different build targets.
Each target is a class that inherits from the base ClientTarget class.
"""
import from typing { Optional }
import from pathlib { Path }

"""Base class for all build targets.

All targets must inherit from this class and implement the required methods.
"""
class ClientTarget {
    has name: str,
        default: bool = False,
        requires_setup: bool = False,
        config_section: str = "",
        required_dependencies: list[str] = [],
        output_dir: Optional[Path] = None;

    def setup(self: ClientTarget, project_dir: Path) -> None abs;
    def build(
        self: ClientTarget,
        entry_file: Path,
        project_dir: Path,
        platform: Optional[str] = None
    ) -> Path abs;

    def dev(self: ClientTarget, entry_file: Path, project_dir: Path) -> None abs;
    def start(self: ClientTarget, entry_file: Path, project_dir: Path) -> None abs;
}

"""Central registry for build targets.

This is a singleton that collects all build targets registered by plugins.
The CLI uses this registry to delegate build operations to the appropriate target.
"""
obj TargetRegistry {
    has _targets: dict[str, ClientTarget] = {},
        _default_target: Optional[str] = None;

    def register(target: ClientTarget) -> None;
    def get(name: str) -> Optional[ClientTarget];
    def get_default -> Optional[ClientTarget];
    def get_all -> list[ClientTarget];
    def has(name: str) -> bool;
    def set_default(name: str) -> None;
    def clear -> None;
}

# Global singleton instance
glob _registry: TargetRegistry | None = None;

"""Get or create the global target registry."""
def get_target_registry -> TargetRegistry {
    import from jac_client.plugin.src.targets.registry { TargetRegistry }
    global _registry;
    if _registry is None {
        _registry = TargetRegistry();
    }
    return _registry;
}
# Target name: "web", "desktop", "android", "ios"
# Is this the default target?
# Does this target need setup?
# Section in jac.toml (e.g., "desktop")
# Required npm/system dependencies
# Where build outputs go
