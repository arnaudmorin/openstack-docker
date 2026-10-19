# openstack-docker
OpenStack docker files

## Images
Images are published on ghcr.io as `ghcr.io/arnaudmorin/openstack-<folder>`.

A GitHub Actions workflow (`.github/workflows/build.yml`) builds every image on every
pull request and every push to a release branch (e.g. `2026.2`).

On a push to a release branch, each image is pushed with two tags:
- the release, e.g. `ghcr.io/arnaudmorin/openstack-nova:2026.2`
- the release and the short sha of the commit, e.g. `ghcr.io/arnaudmorin/openstack-nova:2026.2-0e20d52`

## Manual build
To build and push all images by hand (requires `docker login ghcr.io`):

```bash
$ bash build.sh
```
