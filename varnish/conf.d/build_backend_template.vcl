
backend $BACKEND_NAME { # Define one backend
    .host = $BACKEND_NAME;    # IP or Hostname of backend
    .port = $BACKEND_PORT;    # Port http server is listening on
    .max_connections = 300; # That's it
    .probe = {
        #.url = "/"; # short easy way (GET /)
        # Prefer to only do a HEAD /
        .request =
            "HEAD / HTTP/1.1"
            "Host: localhost"
            "Connection: close"
            "User-Agent: Varnish Health Probe";
        .interval  = 5s; # check the health of each backend every 5 seconds
        .timeout   = 1s; # timing out after 1 second.
        .window    = 5;  # If 3 out of the last 5 polls succeeded the backend is considered healthy, otherwise it will be marked as sick
        .threshold = 3;
    }
    .first_byte_timeout     = 300s;   # How long to wait before we receive a first byte from our backend?
    .connect_timeout        = 5s;     # How long to wait for a backend connection?
    .between_bytes_timeout  = 2s;     # How long to wait between bytes received from our backend?
}