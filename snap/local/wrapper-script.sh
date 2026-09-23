#!/bin/bash
# Wrapper script for duckduckgo-mcp-server
# This script uses snapctl for configuration via snap hooks

# Set default values (matching server defaults from README where possible)
TRANSPORT="streamable-http"
HOST="127.0.0.1"
PORT="8000"
SEARCH_TIMEOUT="10"
MAX_RESULTS="10"
ENABLE_SSL="true"
USER_AGENT="DuckDuckGo MCP Server/0.7.0"
PROXY=""
ENABLE_CACHE="true"
CACHE_TTL="300"
CACHE_MAX_ENTRIES="64"
PARSE_MODE="text"
REF_URL_THRESHOLD="120"
SAFE_SEARCH=""
REGION=""
CA_CERTS=""
RATE_LIMIT_STRATEGY="sliding"
FETCH_RPM="20"
FETCH_HOST_RPM="0"
SEARCH_RPM="30"
ENABLE_LOGGING="false"
LOG_LEVEL="INFO"

# Helper function to get snapctl value or use default
get_snapctl_value() {
    local key="$1"
    local default="$2"
    local value
    
    value=$(snapctl get "$key" 2>/dev/null)
    
    # If value is empty or not set, use default
    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Check for configuration using snapctl
if command -v snapctl &> /dev/null; then
    # Get configuration values using snapctl
    TRANSPORT=$(get_snapctl_value "transport" "streamable-http")
    HOST=$(get_snapctl_value "host" "127.0.0.1")
    PORT=$(get_snapctl_value "port" "8000")
    SEARCH_TIMEOUT=$(get_snapctl_value "search-timeout" "10")
    MAX_RESULTS=$(get_snapctl_value "max-results" "10")
    ENABLE_SSL=$(get_snapctl_value "enable-ssl" "true")
    USER_AGENT=$(get_snapctl_value "user-agent" "DuckDuckGo MCP Server/0.7.0")
    PROXY=$(get_snapctl_value "proxy" "")
    ENABLE_CACHE=$(get_snapctl_value "enable-cache" "true")
    CACHE_TTL=$(get_snapctl_value "cache-ttl" "300")
    CACHE_MAX_ENTRIES=$(get_snapctl_value "cache-max-entries" "64")
    PARSE_MODE=$(get_snapctl_value "parse-mode" "text")
    REF_URL_THRESHOLD=$(get_snapctl_value "ref-url-threshold" "120")
    SAFE_SEARCH=$(get_snapctl_value "safe-search" "")
    REGION=$(get_snapctl_value "region" "")
    CA_CERTS=$(get_snapctl_value "ca-certs" "")
    RATE_LIMIT_STRATEGY=$(get_snapctl_value "rate-limit-strategy" "sliding")
    FETCH_RPM=$(get_snapctl_value "fetch-rpm" "20")
    FETCH_HOST_RPM=$(get_snapctl_value "fetch-host-rpm" "0")
    SEARCH_RPM=$(get_snapctl_value "search-rpm" "30")
    ENABLE_LOGGING=$(get_snapctl_value "enable-logging" "false")
    LOG_LEVEL=$(get_snapctl_value "log-level" "INFO")
fi

# Set environment variables for DDG_ options that don't have command-line switches
export DDG_SEARCH_RPM="$SEARCH_RPM"
export DDG_FETCH_RPM="$FETCH_RPM"
export DDG_FETCH_HOST_RPM="$FETCH_HOST_RPM"
export DDG_CACHE_TTL="$CACHE_TTL"
export DDG_CACHE_MAX_ENTRIES="$CACHE_MAX_ENTRIES"
export DDG_PARSE_MODE="$PARSE_MODE"
export DDG_REF_URL_THRESHOLD="$REF_URL_THRESHOLD"
export DDG_SAFE_SEARCH="$SAFE_SEARCH"
export DDG_REGION="$REGION"
export DDG_CA_CERTS="$CA_CERTS"
export DDG_RATE_LIMIT_STRATEGY="$RATE_LIMIT_STRATEGY"

# For the options that are actually command-line arguments, we'll build the command
CMD_ARGS=""

# Add transport (CLI option)
CMD_ARGS="$CMD_ARGS --transport \"$TRANSPORT\""

# Add host (CLI option)
CMD_ARGS="$CMD_ARGS --host \"$HOST\""

# Add port (CLI option)
CMD_ARGS="$CMD_ARGS --port \"$PORT\""

# Add search timeout (CLI option)
CMD_ARGS="$CMD_ARGS --search-timeout \"$SEARCH_TIMEOUT\""

# Add max results (CLI option)
CMD_ARGS="$CMD_ARGS --max-results \"$MAX_RESULTS\""

# Add enable ssl (CLI option)
CMD_ARGS="$CMD_ARGS --enable-ssl \"$ENABLE_SSL\""

# Add proxy (CLI option)
if [ -n "$PROXY" ]; then
    CMD_ARGS="$CMD_ARGS --proxy \"$PROXY\""
fi

# Add enable cache (CLI option)
CMD_ARGS="$CMD_ARGS --enable-cache \"$ENABLE_CACHE\""

# Add enable logging (CLI option)
CMD_ARGS="$CMD_ARGS --enable-logging \"$ENABLE_LOGGING\""

# Add log level (CLI option)
CMD_ARGS="$CMD_ARGS --log-level \"$LOG_LEVEL\""

# Add user agent (CLI option)
CMD_ARGS="$CMD_ARGS --user-agent \"$USER_AGENT\""

# Execute the actual server with command line arguments
exec "$SNAP/bin/duckduckgo-mcp-server" $CMD_ARGS

