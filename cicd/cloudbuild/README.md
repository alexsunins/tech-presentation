# Cloudbuild

Cloudbuild pipeline powered by the Bash scripts. This project was done back in 2023. No AI was involved to design the pipeline.

The pipeline builds a Docker image, pushes the image and then scans then image with Trivy.

The pipeline was designed to handle the following complexity:

 - configurable application name
 - configurable country code, e.g. uk, us, etc
 - configurable environment type
 - optionally added commit sha1

The configurable fields to be stored as env variables for the Cloudbuild pipeline - this allows to have multiple CB pipelines for different combinations of the configurable fields.

