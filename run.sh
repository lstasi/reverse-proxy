#!/bin/bash
docker build -t proxy /vagrant
pid=$(docker run -p 80:80 -d proxy)