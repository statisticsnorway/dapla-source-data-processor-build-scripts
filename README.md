# dapla-source-data-processor-build-scripts

## Kildomaten action

This repository contains actions and scripts used to build, deploy and test images used by `Kildomaten`. The
process is controlled by the composite action `kildomaten.yaml`.

Every team IAC repo has an action that uses this composite action.
This is added
by `terraform-ssb-dapla-teams` [github-initializer](https://github.com/statisticsnorway/terraform-ssb-dapla-teams/tree/main/github/init#github-initializer).
The action is triggered when a `Kildomaten` source is added.

### Test

The action will not proceed unless all tests complete successfully, this is done to prevent deployment of misconfigured sources.
Tests will check if:

- All source folder contains a `.py` file
- All sources have a `config.yaml` file that defines a trigger path
- Every source plugin has main function and accepts the required number of arguments.
- The code passes Pyflakes.
- The `Kildomaten` feature is enabled for at least one project in `infra/projects.yaml`

### Events

The action will perform different tasks based on the event that triggers it.

#### PR (pull_request event)

When a PR event involving changes to `automation/source-data/**` occurs, the action will perform a set of tests on the
user-supplied code and configuration. If the tests finish successfully, it will post a comment on the PR stating that
the tests have passed and that the PR is ready for approval.

#### PR approved (pull_request_review event)

When a PR is approved, the tests are run again. If they succeed, an `atlantis apply` comment is posted by the action,
deploying the infrastructure needed for Kildomaten.

#### Push to main (push event)

On push to the main branch, tests are executed, followed by building and pushing of the image to the team's GAR.
Then each Cloud Run instance will have a new revision created using the newly pushed image.

#### Manually triggered (workflow_dispatch event)

When triggered by workflow dispatch, the action will perform the same operations as a push to the main branch. This
event is primarily used to force an update of the base image version, without making changes to the configuration or
script of a source. The [trigger-kildomaten](https://github.com/statisticsnorway/terraform-ssb-dapla-teams/blob/main/tools/trigger-kildomaten.sh) script can be used to trigger this event for one or more teams.

## Bump version action

This action is triggered on the release
of [terraform-dapla-source-data-processor repo](https://github.com/statisticsnorway/terraform-dapla-source-data-processor)
and is used to update the base image version utilized during the building and testing of new sources. The current base
image version can be found in `version.yaml`.

## License

Distributed under the terms of the [MIT license][license],
_dapla-source-data-processor-build-scripts_ is free and open source software.

<!-- github-only -->

[license]: https://github.com/statisticsnorway/ssb-project-cli/blob/main/LICENSE
