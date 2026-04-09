# ctx allows build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# os builds the bootc OS image
FROM ghcr.io/ublue-os/bazzite-dx:stable AS os

# Make /opt a real directory so packages (e.g. Edge, 1Password) are baked into the image
# instead of landing in /var/opt via symlink where they'd be wiped on deployment.
RUN rm /opt && mkdir /opt

# Prefer to make modifications in build.sh, not using new RUN commands
RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh

# Verify final image and contents are correct.
RUN bootc container lint
