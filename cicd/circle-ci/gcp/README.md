# GCP

This CircleCI config file builds a Docker image for a NodeJS application.
The pipeline is using cache to speed up the build process.

Once the build/push op has completed the pipeline is updating a repository that is tracked by ArgoCD with the new tag. This step will force ArgoCD to "notice" the new build and push the new image to k8s. Back in 2024 this process was common, in 2026 there is ArgoCD Image Updater that accomplishes the same task.

The pipeline also updates the image tag in a few places - this is to allow flexibility for deploying to multiple regional clusters.

Please note that the config was designed, written and tested by a real human in 2024, before AI psychosis.
