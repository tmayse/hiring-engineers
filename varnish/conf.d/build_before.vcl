
vcl 4.1;
# Based on: 
# https://github.com/mattiasgeniar/varnish-6.0-configuration-templates

import std;
import directors;

declare local var.HTTP_HEADER_TRACE_ID STRING;
declare local var.HTTP_HEADER_PARENT_ID STRING;
declare local var.HTTP_HEADER_SAMPLING_PRIORITY STRING;
declare local var.HTTP_HEADER_VARNISH_START STRING;
declare local var.NOW_NANOSEC TIME;
declare local var.VARNISH_TRACE_DURATION RTIME;

var.HTTP_HEADER_TRACE_ID = 'x-datadog-trace-id';
var.HTTP_HEADER_PARENT_ID = 'x-datadog-parent-id';
var.HTTP_HEADER_SAMPLING_PRIORITY = 'x-datadog-sampling-priority'; # 1 or 2 = keep
var.HTTP_HEADER_VARNISH_START = 'x-datadog-varnish-start';

# String concatenation on RHS
set var.restarted = "Request " if(req.restarts > 0, "has", "has not") " restarted.";

acl purge {
    # ACL controlling purge access
    "localhost";
    "127.0.0.1";
    "::1";
}

