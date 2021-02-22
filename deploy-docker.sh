#!/bin/bash

rm -rf public/
hugo
docker build -t hugo-ning .
process=$(docker ps -q)
if [[ $process ]]
then
    echo "$process"
    docker kill $process
    docker rm $process
fi

docker build -t hugo-ning .
docker run -dit --name hugo-ning -p 9389:80 -v $HOME/hugo/public/:/usr/local/apache2/htdocs/ httpd:2.4