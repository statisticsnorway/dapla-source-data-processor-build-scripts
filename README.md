# dapla-source-data-processor-build-scripts

This repository contains scripts used to verify, build and deploy containers to cloud run. The containers are used to process source data for Dapla teams.

## Verify
Checks Python files for a source to ensure that:
- All source folder contains a .py file
- All source folder names are listed in tfvars.
- Every source folder plugin has main function and accepts the required number of arguments.
- The code passes Pyflakes.

## Build
Builds an image for a source folder in a Dapla team iac repository. The images are pushed to the SSB artifact-registry ssb-docker as shown in the example path below.

```ssb-docker/ssb/statistikktjenester/automation/source_data/example-team/source_folder_name```

## Deploy
Redeploys an image to cloud run, the cloud run instance is named after it`s respective source folder, eg. source-{$source_folder}-processor.

## License

Distributed under the terms of the [MIT license][license],
_dapla-source-data-processor-build-scripts_ is free and open source software.

<!-- github-only -->

[license]: https://github.com/statisticsnorway/ssb-project-cli/blob/main/LICENSE
