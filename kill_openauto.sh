#! /bin/bash

docker kill $(docker ps | grep -i openauto | awk {'print $1'})
