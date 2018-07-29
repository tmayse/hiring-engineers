#!/bin/bash

# Build Varnish config adding each Docker container
# selected using Docker's --filter fuctionality
# env: VARNISH_DOCKER_FILTER
#
# usage build_varnish_config.sh > default.vcl

# render file with Bash variable substitution
render_template() {
    eval "echo \"$(cat $1)\""
}

# get all running docker container IDs
container_ids=$(sudo docker ps --filter $VARNISH_DOCKER_FILTER --format '{{.ID}}')

echo
echo '# autogen Varnish config for Docker containers'
echo '# Docker filter: {$VARNISH_DOCKER_FILTER}'
echo

cat build_before.vcl

# create backend for each selected container
for container_id in $containers_ids
do
    BACKEND_NAME = $(sudo docker inspect $container_id --format '{{.Name}}')
    BACKEND_PORTS = $(sudo docker inspect $container_id --format '{{println  .Ports}}')
        for BACKEND_PORT in $BACKEND_PORTS
        do
            # create backend for each container
            # selected with VARNISH_DOCKER_FILTER
            echo render_template(default_backend.vcl)
        done
done

# init creates round_robin routing
cat << QUOTE_STRING
sub vcl_init {
    # Called when VCL is loaded, before any requests pass through it.
    # Typically used to initialize VMODs.\

    new vdir = directors.round_robin();
QUOTE_STRING

# add declaration to vcl_init for each
# selected container
for container_id in $containers_ids
do
    BACKEND_NAME = $(sudo docker inspect $container_id --format '{{.Name}}')
    echo '    vdir.add_backend($BACKEND_NAME);'
done
echo '}'

# complete config
cat << build_after.vcl
