#!/bin/bash
echo "DOCKER_VARNISH_FILTER=\"${DOCKER_VARNISH_FILTER}\""
echo
echo '##########################################'
source /conf.d/build_varnish_config.sh 
echo '##########################################'
source /conf.d/build_varnish_config.sh > /etc/varnish/default.vcl
varnishd -p vcc_allow_inline_c=on  -F -f /etc/varnish/default.vcl
