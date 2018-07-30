#!/bin/bash

# Build Varnish config adding each Docker container
# selected using Docker's --filter fuctionality
# env: VARNISH_DOCKER_FILTER
#
# usage build_varnish_config.sh > default.vcl

echo "# autogen Varnish config for Docker containers"

# get all running docker container IDs
# filtered by VARNISH_DOCKER_FILTER if it's set
if [ -z $VARNISH_DOCKER_FILTER ]; then
	echo '$VARNISH_DOCKER_FILTER is not set'
	container_list=$(sudo docker ps -a --format '{{.ID}}');
else
	echo "$$VARNISH_DOCKER_FILTER = $VARNISH_DOCKER_FILTER"
	container_list=$(sudo docker ps --filter $VARNISH_DOCKER_FILTER --format '{{.ID}}');
fi
echo
 
# init creates round_robin routing
cat <<QUOTE_STRING

sub vcl_init {
    # Called when VCL is loaded, before any requests pass through it.
    # Typically used to initialize VMODs.\

    new vdir = directors.round_robin();

QUOTE_STRING

# add declaration to vcl_init for each
# selected container
for container_id in $container_list; do
    BACKEND_NAME=$(sudo docker inspect $container_id --format '{{.Name}}')
    echo "    vdir.add_backend(${BACKEND_NAME});"
done 
echo '}' #closing vcl_init()
echo

# create backend for each selected container
for container_id in $container_list; do
    BACKEND_NAME=`sudo docker inspect --format='{{.Name}}' $container_id `
    BACKEND_PORTS=`sudo docker inspect --format='{{.NetworkSettings.Ports}}' $container_id `
    KEYS=(${!BACKEND_PORTS[@]})
    for KEY in $KEYS; do
        # create backend for each container
        # selected with VARNISH_DOCKER_FILTER
        BACKEND_PORT=$BACKEND_PORTS[$KEY]
        BACKEND_DEF=`envsubst < build_backend_template.vcl`;
        echo "$BACKEND_DEF"
    done
done

# complete config
cat build_after.vcl
