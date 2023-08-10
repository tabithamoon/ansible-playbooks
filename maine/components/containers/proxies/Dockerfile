FROM caddy:2.7.2-builder-alpine AS builder

RUN xcaddy build v2.7.3 \
    --with github.com/caddy-dns/cloudflare

FROM caddy:2.7.2-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy