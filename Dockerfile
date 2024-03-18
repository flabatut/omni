FROM alpine AS builder

ARG VERSION=0.31.1
ARG TARGETOS
ARG TARGETARCH
WORKDIR /build
RUN wget -q -O omni "https://github.com/siderolabs/omni/releases/download/v${VERSION}/omni-${TARGETOS}-${TARGETARCH}" \
    && chmod +x omni 

FROM scratch
COPY --from=builder /build /app
ENTRYPOINT ["/app/omni"]