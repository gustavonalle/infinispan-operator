#!/bin/bash

cd ci

export KUBECONFIG=/tmp/openshift-dind-cluster/openshift/openshift.local.config/master/admin.kubeconfig
docker cp oc-cluster-up:/origin/_output/local/bin/linux/amd64/oc .

./oc new-app jboss/infinispan-server -l app=infinispan
./wait-pods.sh 360 3 app infinispan
