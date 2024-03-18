FROM ghcr.io/siderolabs/ca-certificates:v1.6.0 AS image-ca-certificates
FROM ghcr.io/siderolabs/fhs:v1.6.0 AS image-fhs
FROM alpine AS builder

ARG VERSION=0.31.1
ARG TARGETOS
ARG TARGETARCH
WORKDIR /build
RUN wget -q -O omni "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omni-${TARGETOS}-${TARGETARCH}" \
    && chmod +x omni \
    && wget -q -O omnictl "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omnictl-${TARGETOS}-${TARGETARCH}" \
    && chmod +x omnictl

FROM scratch
COPY --from=builder /build/omni /omni
COPY --from=builder /build/omnictl /omnictl
COPY --from=image-fhs / /
COPY --from=image-ca-certificates / /
LABEL org.opencontainers.image.source https://github.com/siderolabs/omni
ENTRYPOINT ["/omni"]


