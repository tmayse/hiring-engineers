#!/bin/bash
source /conf.d/build_varnish_config.sh > /etc/varnish/default.vcl
sudo varnish
