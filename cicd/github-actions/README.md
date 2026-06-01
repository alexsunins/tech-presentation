# Github Actions

Example of a Github Actions pipeline.
The pipeline builds a Docker image. Before building the image the pipeline cleans up disk space on the GH runner. Once the image is built the pipeline updates a repository that has ArgoCD manifest to trigger auto-rollout to k8s.

For this example the image tag is updated in `kustomize.yaml` but it can be any path.
