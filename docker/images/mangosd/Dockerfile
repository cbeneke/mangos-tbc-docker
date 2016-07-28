FROM pritunl/archlinux
MAINTAINER Christian Beneke <c.beneke@wirelab.org>

RUN pacman -Sy --noconfirm --needed boost libmariadbclient && \
    find /etc/ -type f -name '*.pac*' -exec rm {} \; && \
    rm -rf /var/cache/pacman/pkg/*

ENV LD_LIBRARY_PATH=/opt/lib
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin

ENTRYPOINT ["mangosd", "-c", "/opt/etc/mangosd.conf"]
