#!/bin/bash

# Build Varnish config adding each Docker container
# selected using Docker's --filter fuctionality
# env: VARNISH_DOCKER_FILTER
#
# usage build_varnish_config.sh > default.vcl

echo '# autogen Varnish config for Docker containers'
echo

# get all running docker container IDs
# filtered by VARNISH_DOCKER_FILTER if it's set
if [ -z "$VARNISH_DOCKER_FILTER" ]; then
	echo "# $VARNISH_DOCKER_FILTER is not set"
	container_list=$(docker ps -a --format '{{.ID}}');
else
	echo "# \$VARNISH_DOCKER_FILTER = ${VARNISH_DOCKER_FILTER}"
	container_list=`docker ps --filter $VARNISH_DOCKER_FILTER --format '{{.ID}}'`;
fi

cat /conf.d/build_before.vcl

# create backend for each selected container
for container_id in $container_list; do
    container_ip_list=`docker inspect --format '{{range .NetworkSettings.Networks}}{{println .IPAddress}}{{end}}' ${container_id}`
    container_ips=($container_ip_list)
    container_name=`docker inspect --format '{{ .Name}}' ${container_id}`
    container_name=${container_name//-/_}
    BACKEND_NAME=${container_name#?}
    BACKEND_PORT='80'
    # create backend for each container IP
    # selected with VARNISH_DOCKER_FILTER
    for container_ip in $container_ips; do #this obviously won't work - only 1 ip supported per container for now
      BACKEND_IP=$container_ip
      export BACKEND_NAME
      export BACKEND_IP
      export BACKEND_PORT
      echo
      BACKEND_DEF=`envsubst < /conf.d/build_backend_template.vcl`;
      echo "$BACKEND_DEF"
    done
    echo
done

cat <<QUOTE_STRING
sub vcl_init {
    # Called when VCL is loaded, before any requests pass through it.
    # Typically used to initialize VMODs.\

    new vdir = directors.round_robin();
QUOTE_STRING

# add declaration to vcl_init for each
# selected container
for container_id in $container_list; do
    container_name=`docker inspect --format '{{ .Name}}' ${container_id}`
    container_name=${container_name/-/_}
    BACKEND_NAME=${container_name#?}
    echo "    vdir.add_backend(${BACKEND_NAME});"
done 
echo '}' #closing vcl_init()
echo

# complete config
cat /conf.d/build_after.vcl
