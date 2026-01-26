"""Factory for creating image registries."""
import from typing { Any }
import from jac_scale.abstractions.image_registry { ImageRegistry }

"""Factory for creating image registry instances."""
class ImageRegistryFactory {
    static def create(registry_type: str, config: dict[str, Any]) -> ImageRegistry {
        if registry_type == 'dockerhub' {
            import from jac_scale.providers.registry.dockerhub { DockerHubRegistry }
            return DockerHubRegistry(config=config);
        } elif registry_type == 'ecr' {
            raise NotImplementedError("AWS ECR registry not yet implemented") ;
        } elif registry_type == 'gcr' {
            raise NotImplementedError("GCP GCR registry not yet implemented") ;
        } else {
            raise ValueError(f"Unsupported image registry type: {registry_type}") ;
        }
    }
}
