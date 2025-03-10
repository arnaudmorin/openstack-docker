FROM 99cloud/skyline
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
USER root
RUN python -m pip install -c https://releases.openstack.org/constraints/upper/2024.2 --force-reinstall 'skyline-apiserver @ git+https://github.com/openstack/skyline-apiserver/@stable/2024.2' 
RUN python -m pip install -c https://releases.openstack.org/constraints/upper/2024.2 --force-reinstall 'skyline-console @ git+https://github.com/openstack/skyline-console/@stable/2024.2'
# Workarounds until my fix got merged upstream
# See https://review.opendev.org/c/openstack/skyline-apiserver/+/902853
# and https://review.opendev.org/c/openstack/skyline-apiserver/+/902417
# and https://review.opendev.org/c/openstack/skyline-apiserver/+/902813
#COPY data/patches /patches
# Note that p1 is duplicate of p3 done by someone else, which is also valid
#RUN cd /usr/local/lib/python3.8/dist-packages/ && patch -p1 < /patches/p1
#RUN cd /usr/local/lib/python3.8/dist-packages/ && patch -p1 < /patches/p2
#RUN cd /usr/local/lib/python3.8/dist-packages/ && patch -p1 < /patches/p3
# As of 2024.2, let's try without any patch

COPY data/skyline.yaml /etc/skyline/skyline.yaml
