#!/usr/bin/env bash

set -e

function __is_pod_ready() {
  [[ "$(./oc get po "$1" -o 'jsonpath={.status.conditions[?(@.type=="Ready")].status}')" == 'True' ]]
}

function __pods_ready() {
  local pod

  [[ "$#" == 0 ]] && return 1

  for pod in $pods; do
    __is_pod_ready "$pod" || return 1
  done

  return 0
}

function __wait-until-pods-ready() {
  local period interval i pods

  if [[ $# != 4 ]]; then
    echo "Usage: wait-until-pods-ready PERIOD INTERVAL LABEL-NAME LABEL-VALUE" >&2
    echo "" >&2
    echo "This script waits for a pod to be ready in the current namespace." >&2

    return 1
  fi

  period="$1"
  interval="$2"
  lname="$3"
  lvalue="$4"

  for ((i=0; i<$period; i+=$interval)); do
	  pods="$(./oc get po -o 'jsonpath={.items[?(@.metadata.labels.'"$lname"'=='"'$lvalue'"')].metadata.name}')"
    if __pods_ready $pods; then
      return 0
    fi

    echo "Waiting for pods to be ready..."
    sleep "$interval"
  done

  echo "Waited for $period seconds, but all pods are not ready yet."
  return 1
}

__wait-until-pods-ready $@
