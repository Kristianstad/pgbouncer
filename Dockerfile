# =========================================================================
# Init
# =========================================================================
# ARGs (can be passed to Build/Final) <BEGIN>
ARG SaM_REPO=${SaM_REPO:-ghcr.io/kristianstad/secure_and_minimal}
ARG ALPINE_VERSION=${ALPINE_VERSION:-3.23}
ARG APP_VERSION=${APP_VERSION:-1.25.1}
ARG IMAGETYPE="application"
ARG RUNDEPS="pgbouncer"
ARG EXECUTABLES="/usr/bin/pgbouncer"
ARG REMOVEFILES="/etc/pgbouncer/pgbouncer.ini"
# ARGs (can be passed to Build/Final) </END>

# Generic template (don't edit) <BEGIN>
FROM ${CONTENTIMAGE1:-scratch} AS content1
FROM ${CONTENTIMAGE2:-scratch} AS content2
FROM ${CONTENTIMAGE3:-scratch} AS content3
FROM ${CONTENTIMAGE4:-scratch} AS content4
FROM ${CONTENTIMAGE5:-scratch} AS content5
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS base
FROM ${INITIMAGE:-scratch} AS init
# Generic template (don't edit) </END>

# =========================================================================
# Build
# =========================================================================
# Generic template (don't edit) <BEGIN>
FROM ${BUILDIMAGE:-$SaM_REPO:build-${ALPINE_VERSION}} AS build
FROM ${BASEIMAGE:-$SaM_REPO:base-${ALPINE_VERSION}} AS final
COPY --from=build /finalfs /
# Generic template (don't edit) </END>

# =========================================================================
# Final
# =========================================================================
# Re-declare ARGs
ARG ALPINE_VERSION
ARG APP_VERSION

ARG CONFIG_DIR="/etc/pgbouncer"

ENV VAR_LINUX_USER="postgres" \
    VAR_CONFIG_FILE="$CONFIG_DIR/pgbouncer.ini" \
    VAR_DATABASES="*=port=5432" \
    VAR_param_auth_file="$CONFIG_DIR/userlist.txt" \
    VAR_param_auth_hba_file="$CONFIG_DIR/pg_hba.conf" \
    VAR_param_unix_socket_dir="/run/pgbouncer" \
    VAR_param_listen_addr="*" \
    VAR_param_logfile="/dev/stdout" \
    VAR_FINAL_COMMAND="/usr/local/bin/pgbouncer -q \$VAR_CONFIG_FILE" \
    APP_VERSION="${APP_VERSION}"

# Generic template (don't edit) <BEGIN>
USER starter
ONBUILD USER root
# Generic template (don't edit) </END>

LABEL org.opencontainers.image.version="${APP_VERSION}" \
      org.opencontainers.image.title="pgbouncer" \
      org.opencontainers.image.description="PgBouncer ${APP_VERSION} based on secure_and_minimal ${ALPINE_VERSION}"
