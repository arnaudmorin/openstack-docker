#!/bin/bash
# Print a short hash of the upstream sources an image is built from:
#   ./upstream-ref.sh nova
#
# The hash changes as soon as one of these sources moves upstream. It is passed
# as the UPSTREAM_REF build arg, so the build cache is reused while upstream does
# not move, and invalidated when it does.
#
# Sources are read from the Dockerfile:
#   git clone <url> . -b <branch>
#   pip install git+<url>[@<branch>]
#   https://opendev.org/openstack/requirements/raw/branch/<branch>/upper-constraints.txt
#   https://tarballs.opendev.org/openstack/<project>/<project>-stable-<release>.tar.gz
#   https://github.com/<owner>/<repo>/archive/refs/heads/<branch>.tar.gz
set -eo pipefail

DOCKERFILE=${1:?usage: $0 <image folder>}/Dockerfile

# Replace ${VAR} with the default value of ARG VAR=default
dockerfile() {
    local content
    content=$(cat "$DOCKERFILE")
    while IFS='=' read -r name value; do
        content=${content//\$\{$name\}/$value}
    done < <(grep -oP '^ARG \K\w+=\S+' "$DOCKERFILE")
    echo "$content"
}

# One "<git url> <ref>" per line
sources() {
    local d
    d=$(dockerfile)
    grep -oP 'git clone \K\S+ \. -b \S+' <<< "$d" | awk '{print $1, "refs/heads/"$4}' || true
    grep -oP 'git\+\Khttps://[^ @"]+(@[^ "]+)?' <<< "$d" | awk -F@ '{print $1, ($2 ? "refs/heads/"$2 : "HEAD")}' || true
    grep -oP 'opendev\.org/openstack/requirements/raw/branch/\K\S+(?=/upper-constraints\.txt)' <<< "$d" \
        | awk '{print "https://opendev.org/openstack/requirements", "refs/heads/"$1}' || true
    grep -oP 'tarballs\.opendev\.org/openstack/\K[^/]+/[^/ ]+-stable-[^/ ]+(?=\.tar\.gz)' <<< "$d" \
        | sed -E 's#^([^/]+)/.*-stable-(.*)$#https://opendev.org/openstack/\1 refs/heads/stable/\2#' || true
    grep -oP 'https://github\.com/[^/]+/[^/]+/archive/refs/heads/[^ "]+(?=\.tar\.gz)' <<< "$d" \
        | sed -E 's#^(https://github\.com/[^/]+/[^/]+)/archive/(refs/heads/.*)$#\1 \2#' || true
}

refs=$(sources | sort -u | while read -r url ref; do
    sha=$(git ls-remote "$url" "$ref" | cut -f1 | head -1)
    if [ -z "$sha" ]; then
        echo "ERROR: $ref not found in $url" >&2
        exit 1
    fi
    echo "$url $ref $sha"
done)
# Details on stderr, the hash alone on stdout
echo "$refs" >&2
echo "$refs" | sha256sum | cut -c1-12
