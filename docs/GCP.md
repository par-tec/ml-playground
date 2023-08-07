# Build on GCP

## Prerequisites

Create a [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/quickstart) repository.

Configure project, location and repository name:

```bash
gcloud config set project PROJECT_ID
gcloud config set artifacts/location europe-west12
gcloud config set artifacts/repository docker-test
```

Now create the repository:

```bash
gcloud artifacts
gcloud artifacts repositories create docker-test --repository-format=docker
gcloud artifacts repositories list
```

## Build

Build the image referencing the cloudbuild.yaml.
We use substitutions to avoid hardcoding the registry name.

```bash
gcloud builds submit --config docs/cloudbuild.yaml --substitutions=_REGISTRY_ID=docker-test .
```

Now check the image in the repository. gcloud
uses the information provided in gcloud config to find the image.

```bash
gcloud artifacts docker images list
```

## Using the image

You can use the image from a GCE host configuring access via

```bash
gce-instance$ docker-credential-gcr configure-docker --registries=europe-west12-docker.pkg.dev
```
