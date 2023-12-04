FROM kolla/debian-source-nova-base:yoga
MAINTAINER Arnaud Morin "arnaud.morin@gmail.com"
COPY data/sources.list /etc/apt/sources.list

RUN apt-get update && apt-get install -y \
        dosfstools \
        e2fsprogs \
        genisoimage \
        libosinfo-bin \
        libsasl2-modules-gssapi-mit \
        multipath-tools \
        parted \
        python3-guestfs \
        qemu-block-extra \
        qemu-utils \
        qemu-system \
        libvirt-clients \
        libvirt-daemon-system \
        ovmf \
        dmidecode \
        openvswitch-switch \
        pm-utils \
        sasl2-bin \
        sysfsutils

RUN rm -f /etc/libvirt/qemu/networks/default.xml /etc/libvirt/qemu/networks/autostart/default.xml
RUN mkdir -p /var/lib/nova/instances
RUN chown nova:nova /var/lib/nova/instances
COPY data/libvirtd.conf /etc/libvirt/libvirtd.conf
USER root
