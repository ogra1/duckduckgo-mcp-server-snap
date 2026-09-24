#!/bin/sh
# Wrapper script for duckduckgo-mcp-server
# This script uses snapctl for configuration via snap hooks

# Set default values (matching server defaults from README where possible)
TRANSPORT="streamable-http"
HOST="0.0.0.0"
PORT="8000"
CACHE_MAX_ENTRIES="64"
REF_URL_THRESHOLD="120"
SAFE_SEARCH=""
REGION=""
CA_CERTS=""
RATE_LIMIT_STRATEGY="sliding"
FETCH_RPM="20"
FETCH_HOST_RPM="0"
SEARCH_RPM="30"

# Helper function to get snapctl value or use default
get_snapctl_value() {
    key="$1"
    default="$2"
    
    value=$(snapctl get "$key" 2>/dev/null)
    
    # If value is empty or not set, use default
    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Check for configuration using snapctl
if command -v snapctl >/dev/null 2>&1; then
    # Get configuration values using snapctl
    TRANSPORT=$(get_snapctl_value "transport" "streamable-http")
    HOST=$(get_snapctl_value "host" "0.0.0.0")
    PORT=$(get_snapctl_value "port" "8000")
    CACHE_MAX_ENTRIES=$(get_snapctl_value "cache-max-entries" "64")
    REF_URL_THRESHOLD=$(get_snapctl_value "ref-url-threshold" "120")
    SAFE_SEARCH=$(get_snapctl_value "safe-search" "")
    REGION=$(get_snapctl_value "region" "")
    CA_CERTS=$(get_snapctl_value "ca-certs" "")
    RATE_LIMIT_STRATEGY=$(get_snapctl_value "rate-limit-strategy" "sliding")
    FETCH_RPM=$(get_snapctl_value "fetch-rpm" "20")
    FETCH_HOST_RPM=$(get_snapctl_value "fetch-host-rpm" "0")
    SEARCH_RPM=$(get_snapctl_value "search-rpm" "30")
    ALLOWED_HOSTS=$(get_snapctl_value "allowed-hosts" "")
    ALLOWED_ORIGINS=$(get_snapctl_value "allowed-origins" "")
    NO_SSL_VERIFY=$(get_snapctl_value "no-ssl-verify" "")
fi

# Set environment variables for DDG_ options that don't have command-line switches
export DDG_SAFE_SEARCH="$SAFE_SEARCH"
export DDG_REGION="$REGION"
export DDG_CA_CERTS="$CA_CERTS"
export DDG_RATE_LIMIT_STRATEGY="$RATE_LIMIT_STRATEGY"
export DDG_SEARCH_RPM="$SEARCH_RPM"
export DDG_FETCH_RPM="$FETCH_RPM"
export DDG_FETCH_HOST_RPM="$FETCH_HOST_RPM"
export DDG_CACHE_MAX_ENTRIES="$CACHE_MAX_ENTRIES"
export DDG_REF_URL_THRESHOLD="$REF_URL_THRESHOLD"

# Clear positional parameters to start fresh
set --

set -- "$@" --transport "$TRANSPORT"
set -- "$@" --host "$HOST"
set -- "$@" --port "$PORT"
[ -z "$ALLOWED_HOSTS" ]   || set -- "$@" --allowed-hosts "$ALLOWED_HOSTS"
[ -z "$ALLOWED_ORIGINS" ] || set -- "$@" --allowed-origins "$ALLOWED_ORIGINS"
[ -z "$NO_SSL_VERIFY" ]   || set -- "$@" --no-ssl-verify

# Execute the server safely with perfectly preserved arguments
exec "$SNAP/bin/duckduckgo-mcp-server" "$@"
