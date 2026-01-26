"""Desktop target implementation.

This target will be implemented in Phase 2.
"""
import from pathlib { Path }
import from typing { Optional }
import from jac_client.plugin.src.targets.registry { ClientTarget }

"""Desktop build target (placeholder for Phase 2)."""
class DesktopTarget(ClientTarget) {
    def init(self: DesktopTarget) {
        self.name = "desktop";
        self.default = False;
        self.requires_setup = True;
        self.config_section = "desktop";
        self.output_dir = Path("src-tauri/target/release/bundle");
    }

    override def setup(self: DesktopTarget, project_dir: Path) -> None;
    override def build(
        self: DesktopTarget,
        entry_file: Path,
        project_dir: Path,
        platform: Optional[str] = None
    ) -> Path;

    override def dev(self: DesktopTarget, entry_file: Path, project_dir: Path) -> None;
    override def start(
        self: DesktopTarget, entry_file: Path, project_dir: Path
    ) -> None;
}
