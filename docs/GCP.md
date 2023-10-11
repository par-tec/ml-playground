# Build on GCP

To avoid hardcoding the project and region in the cloudbuild.yaml, you can use a .gcp.env file to set the environment variables.

You can then source the file before running the build:

```bash
cat >> .gcp.env <<EOF
CLOUDSDK_CORE_PROJECT=test-project
CLOUDSDK_CORE_REGION=europe-west12
ENV
```

## Prerequisites

Create a [Google Artifact Registry](https://cloud.google.com/artifact-registry/docs/quickstart) repository.

Configure project, location and repository name:

```bash
gcloud config set project "${CLOUDSDK_CORE_PROJECT}"
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
# List images.
gcloud artifacts docker images list

# List images and tags.
gcloud artifacts docker tags list
```

### More on builds

You can pass further variables to builds

```bash
(
COMMIT_SHA=$(git rev-parse --short HEAD)

)

```

## Using the image

You can use the image from a GCE host configuring access via

```bash
gce-instance$ docker-credential-gcr configure-docker --registries=${CLOUDSDK_CORE_REGION}-docker.pkg.dev
```
