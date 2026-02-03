"""Base storage abstraction for Jac.

This provides a standard interface for file/blob storage operations that can be
overridden by plugins (like jac-scale) to provide cloud storage backends.
"""
import from typing { Any, BinaryIO, Generator }

"""Abstract base class for storage implementations."""
class Storage {
    def upload(
        self: Storage,
        source: (str | BinaryIO),
        destination: str,
        metadata: (dict[str, str] | None) = None
    ) -> str abs;

    def download(
        self: Storage, source: str, destination: (str | BinaryIO | None) = None
    ) -> (bytes | None) abs;

    def delete(self: Storage, path: str) -> bool abs;
    def exists(self: Storage, path: str) -> bool abs;
    def list_files(
        self: Storage, prefix: str = "", recursive: bool = False
    ) -> Generator[str, None, None] abs;

    def get_metadata(self: Storage, path: str) -> dict[str, Any] abs;
    def copy(self: Storage, source: str, destination: str) -> bool abs;
    def move(self: Storage, source: str, destination: str) -> bool abs;
}
