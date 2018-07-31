vcl 4.0;

# Based on: 
# https://github.com/mattiasgeniar/varnish-6.0-configuration-templates

import std;
import directors;

# To allow inline-C in VCL start varnishd with -p vcc_allow_inline_c=on
C{
    #include <sys/time.h>
    #include <stdio.h>
    static const struct gethdr_s VGC_HDR_REQ_reqstart = { HDR_REQ, "\020X-Request-Start:" };
}C

acl purge {
    # ACL controlling purge access
    "localhost";
    "127.0.0.1";
    "::1";
}

