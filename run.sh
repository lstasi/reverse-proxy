#!/bin/bash
docker build -t proxy .
pid=$(docker run -p 80:80 -d proxy)