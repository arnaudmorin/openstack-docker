# openstack-docker
OpenStack docker files

## Images
Images are published on ghcr.io as `ghcr.io/arnaudmorin/openstack-<folder>`.

A GitHub Actions workflow (`.github/workflows/build.yml`) builds the images on every
pull request and every push to a release branch (e.g. `2026.2`).

Only the images whose folder changed are built. Everything is built when the workflow
or `upstream-ref.sh` changed, after a force push, and on manual runs
(`gh workflow run build.yml --ref 2026.2`).

The Dockerfiles clone upstream branches (e.g. `stable/2026.2`). `upstream-ref.sh <folder>`
hashes the current commit of each of these sources and the workflow passes it as the
`UPSTREAM_REF` build arg, so the build cache is reused until upstream moves.
A weekly workflow on `main` triggers a manual run of the latest release branch, so the
images pick up upstream fixes even without changes in this repo.

On a push to a release branch, each image is pushed with two tags:
- the release, e.g. `ghcr.io/arnaudmorin/openstack-nova:2026.2`
- the release and the short sha of the commit, e.g. `ghcr.io/arnaudmorin/openstack-nova:2026.2-0e20d52`

## Manual build
To build and push all images by hand (requires `docker login ghcr.io`):

```bash
$ bash build.sh
```
