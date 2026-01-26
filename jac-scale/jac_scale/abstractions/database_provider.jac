"""Base database provider abstraction for jac_scale.

All database provider implementations should inherit from this class.
"""
import from typing { Any }

"""Base class for all database provider implementations."""
class DatabaseProvider {
    def deploy(self: DatabaseProvider, config: dict[str, Any]) -> dict[str, Any];
    def get_connection_string(self: DatabaseProvider) -> str;
    def is_available(self: DatabaseProvider) -> bool;
    def cleanup(self: DatabaseProvider) -> None;
    def get_init_container(
        self: DatabaseProvider, app_name: str, wait_image: str
    ) -> (dict[(str, Any)] | None);
}
