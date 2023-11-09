# dapla-source-data-processor-build-scripts

This repository contains scripts used to test containers that are used to process source data for Dapla teams.

## Test
Checks Python files for a source to ensure that:
- All source folder contains a .py file
- All source folder names are listed in tfvars.
- Every source folder plugin has main function and accepts the required number of arguments.
- The code passes Pyflakes.

## License

Distributed under the terms of the [MIT license][license],
_dapla-source-data-processor-build-scripts_ is free and open source software.

<!-- github-only -->

[license]: https://github.com/statisticsnorway/ssb-project-cli/blob/main/LICENSE
