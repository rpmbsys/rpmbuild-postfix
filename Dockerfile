ARG repo=ghcr.io/aursu/rpmbuild
ARG os=8.10.20240528
ARG image=build
FROM ${repo}:${os}-${image}

USER root
RUN dnf -y --enablerepo=bintray-custom install \
        libicu-devel \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

RUN dnf -y install \
        cyrus-sasl-devel \
        libdb-devel \
        libnsl2-devel \
        libpq-devel \
        lmdb-devel \
        mariadb-connector-c-devel \
        openldap-devel \
        openssl-devel \
        pcre2-devel \
        perl-generators \
        sqlite-devel \
        systemd-rpm-macros \
        systemd-units \
        tinycdb-devel \
        zlib-devel \
    && dnf clean all && rm -rf /var/cache/dnf /var/lib/rpm/__db*

COPY SOURCES ${BUILD_TOPDIR}/SOURCES
COPY SPECS ${BUILD_TOPDIR}/SPECS

RUN chown -R $BUILD_USER ${BUILD_TOPDIR}/{SOURCES,SPECS}

USER $BUILD_USER
ENTRYPOINT ["/usr/bin/rpmbuild", "postfix.spec"]
CMD ["-ba"]
