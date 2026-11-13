# openstack-docker
OpenStack docker files

## master branch
The Dockerfiles of this branch build the master branch of each OpenStack project.
Nothing is built nor published on GitHub: the images are built fresh on the k3s node
of [bootstrap-openstack-k8s](https://github.com/arnaudmorin/bootstrap-openstack-k8s)
(master branch), at each deployment.

To build all images and import them in k3s as `ghcr.io/arnaudmorin/openstack-<folder>:master`:

```bash
$ bash build-for-k3s.sh
```

Or only some of them:

```bash
$ bash build-for-k3s.sh nova neutron
```

Logs land in `/var/log/build-<folder>.log`.
