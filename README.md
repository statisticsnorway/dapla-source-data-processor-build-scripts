# dapla-source-data-processor-build-scripts

This repository contains scripts used to verify, build and deploy containers to cloud run. The containers are used to process source data for Dapla teams.

## Cloud build example yaml
```
steps:
  # Clone dapla-source-data-processor-build-scripts repo
  - name: 'gcr.io/cloud-builders/git'
    args: ['clone', 'https://github.com/statisticsnorway/dapla-source-data-processor-build-scripts']
  # Verify source scripts with pyflakes and pytests
  - name: python
    entrypoint: 'bash'
    args: ['dapla-source-data-processor-build-scripts/analyze_source_files.sh']
    env:
      - 'REPO_NAME=$REPO_NAME'
  # Add a dockerfile for each sub folder in automation/source_data/ not named pipelines or triggers
  # Build and push the images to Artifact registry.
  - name: 'gcr.io/cloud-builders/docker'
    entrypoint: 'bash'
    args: [ 'dapla-source-data-processor-build-scripts/build_docker_images.sh' ]
  # Update image used by cloud run
  - name: 'gcr.io/cloud-builders/gcloud'
    entrypoint: 'bash'
    args: [ 'dapla-source-data-processor-build-scripts/update_cloud_run_images.sh' ]

options:
  logging: CLOUD_LOGGING_ONLY
```

## Verify
Checks Python source files in every source folder to ensure that:
- All source folder contains a .py file
- All source folder names are listed in tfvars.
- Every source folder plugin has main function and accepts the required number of arguments.
- The code passes Pyflakes.

## Build
Builds an image for each source folder in a Dapla team iac repository. The images are pushed to the SSB artifact-registry ssb-docker as shown in the example path below.

```ssb-docker/ssb/statistikktjenester/automation/source_data/example-team/source_folder_name```

## Deploy
Redeploys an image to cloud run, the cloud run instance is named after it`s respective source folder, eg. source-{$source_folder}-processor.

## License

Distributed under the terms of the [MIT license][license],
_dapla-source-data-processor-build-scripts_ is free and open source software.

<!-- github-only -->

[license]: https://github.com/statisticsnorway/ssb-project-cli/blob/main/LICENSE
