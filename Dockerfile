FROM ghcr.io/siderolabs/ca-certificates:v1.6.0 AS image-ca-certificates
FROM ghcr.io/siderolabs/fhs:v1.6.0 AS image-fhs
FROM alpine AS builder

ARG VERSION=0.31.1
ARG TARGETOS
ARG TARGETARCH
WORKDIR /build
RUN wget -q -O omni "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omni-${TARGETOS}-${TARGETARCH}" \
    && chmod +x omni \
    # https://github.com/siderolabs/omni/blob/main/Dockerfile
    # official docker image embeds all platform binaries and strict folder structure required otherwise fails at startup
    && mkdir omnictl \
    && cd omnictl \
    && wget -q "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-darwin-amd64" \
    && wget -q "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-darwin-arm64" \
    && wget -q "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-linux-amd64" \
    && wget -q "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-linux-arm64" \
    && wget -q "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-windows-amd64.exe" \
    && chmod -R +x omnictl-*

FROM scratch
COPY --from=builder /build/omni /omni
COPY --from=builder /build/omnictl /omnictl/
COPY --from=image-fhs / /
COPY --from=image-ca-certificates / /
LABEL org.opencontainers.image.source https://github.com/siderolabs/omni
ENTRYPOINT ["/omni"]


