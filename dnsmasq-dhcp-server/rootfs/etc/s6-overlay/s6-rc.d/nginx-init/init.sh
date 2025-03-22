#!/usr/bin/with-contenv bashio
# shellcheck shell=bash
set -e

##################
# NGINX SETTINGS #
##################

NGINX_INGRESS_CONF=/etc/nginx/servers/ingress.conf

# ==============================================================================
# FUNCTIONS
# ==============================================================================

function log_info() {
    bashio::log.info "nginx-init.sh: $@"
}


#
# MAIN
#

declare ingress_interface
declare ingress_port
declare ingress_entry
declare web_ui_port

ingress_port=$(bashio::addon.ingress_port)
ingress_interface=$(bashio::addon.ip_address)
ingress_entry=$(bashio::addon.ingress_entry)
web_ui_port=$(bashio::config 'web_ui.port')

if [ -z "$ingress_port" ]; then
    ingress_port=8100
fi
if [ -z "$ingress_interface" ]; then
    # we can also provide an IP address as ingress interface and the IP 0.0.0.0
    # means that the server will accept connections from ANY source
    ingress_interface=0.0.0.0
fi
if [ "$web_ui_port" = "null" ]; then
    web_ui_port=8976
fi

log_info "Starting nginx ingress configuration..."
log_info "Settings are: ingress_port=${ingress_port}, ingress_interface=${ingress_interface}, ingress_entry=${ingress_entry}, web_ui_port=${web_ui_port}"

sed -i "s/%%port%%/${ingress_port}/g"           ${NGINX_INGRESS_CONF}
sed -i "s/%%interface%%/${ingress_interface}/g" ${NGINX_INGRESS_CONF}
sed -i "s|%%ingress_entry%%|${ingress_entry}|g" ${NGINX_INGRESS_CONF}
sed -i "s|%%web_ui_port%%|${web_ui_port}|g"     ${NGINX_INGRESS_CONF}

log_info "nginx ingress config complete."
