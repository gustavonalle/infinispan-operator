#!/bin/bash

docker exec oc-cluster-up hack/dind-cluster.sh stop
docker rm -f oc-cluster-up openshift-master openshift-node-1
