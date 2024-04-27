#!/bin/bash 
mkdir /tmp/cache
export GOCACHE=/tmp/cache 
go run /usr/local/bin/checksite.go

