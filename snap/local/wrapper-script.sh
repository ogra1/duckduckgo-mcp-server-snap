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

# Check for configuration using snapctl
if command -v snapctl &> /dev/null; then
    # Get configuration values using snapctl
    TRANSPORT=$(snapctl get transport 2>/dev/null || echo "streamable-http")
    HOST=$(snapctl get host 2>/dev/null || echo "127.0.0.1")
    PORT=$(snapctl get port 2>/dev/null || echo "8000")
    SEARCH_TIMEOUT=$(snapctl get search-timeout 2>/dev/null || echo "10")
    MAX_RESULTS=$(snapctl get max-results 2>/dev/null || echo "10")
    ENABLE_SSL=$(snapctl get enable-ssl 2>/dev/null || echo "true")
    USER_AGENT=$(snapctl get user-agent 2>/dev/null || echo "DuckDuckGo MCP Server/0.7.0")
    PROXY=$(snapctl get proxy 2>/dev/null || echo "")
    ENABLE_CACHE=$(snapctl get enable-cache 2>/dev/null || echo "true")
    CACHE_TTL=$(snapctl get cache-ttl 2>/dev/null || echo "300")
    CACHE_MAX_ENTRIES=$(snapctl get cache-max-entries 2>/dev/null || echo "64")
    PARSE_MODE=$(snapctl get parse-mode 2>/dev/null || echo "text")
    REF_URL_THRESHOLD=$(snapctl get ref-url-threshold 2>/dev/null || echo "120")
    SAFE_SEARCH=$(snapctl get safe-search 2>/dev/null || echo "")
    REGION=$(snapctl get region 2>/dev/null || echo "")
    CA_CERTS=$(snapctl get ca-certs 2>/dev/null || echo "")
    RATE_LIMIT_STRATEGY=$(snapctl get rate-limit-strategy 2>/dev/null || echo "sliding")
    FETCH_RPM=$(snapctl get fetch-rpm 2>/dev/null || echo "20")
    FETCH_HOST_RPM=$(snapctl get fetch-host-rpm 2>/dev/null || echo "0")
    SEARCH_RPM=$(snapctl get search-rpm 2>/dev/null || echo "30")
    ENABLE_LOGGING=$(snapctl get enable-logging 2>/dev/null || echo "false")
    LOG_LEVEL=$(snapctl get log-level 2>/dev/null || echo "INFO")
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
