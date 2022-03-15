FROM debian:bullseye-slim

ARG VERSION
ARG ARCH

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        libelf1 \
        wget \
        dumb-init \
    && update-ca-certificates \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/*

RUN cd $(mktemp -d) \
    && wget -O ./teleport.tar.gz https://get.gravitational.com/teleport-v${VERSION}-linux-${ARCH}-bin.tar.gz \
    && tar xvf teleport.tar.gz --strip-components=1 teleport/teleport teleport/tctl teleport/tsh \
    && mv teleport tctl tsh /usr/local/bin \
    && mkdir -p /etc/teleport \
    && cd /etc/teleport \
    && rm -rf /tmp/*

ENTRYPOINT ["/usr/bin/dumb-init", "teleport", "start", "-c", "/etc/teleport/teleport.yaml"]