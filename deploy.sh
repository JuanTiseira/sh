#!/bin/bash
# The first parameter is the action name
action=$1
# build docker image

deploy() {
  if [ "$1" == "test" ]; then
    cp Dockerfile-test Dockerfile
    cp .env.test .env
    gcloud builds submit --tag gcr.io/ [project] / [repository] . --project [project]
    gcloud compute instance-groups managed rolling-action replace [group] --zone [zone] --project [project]
    rm Dockerfile
    rm .env
  fi
  if [ "$1" == "prod" ]; then
    cp Dockerfile-prod Dockerfile
    cp .env.prod .env
    gcloud builds submit --tag gcr.io/ [project] / [repository] . --project [project]
    gcloud compute instance-groups managed rolling-action replace [group] --zone [zone] --project [project]
    rm Dockerfile
    rm .env
  fi
}

case "$action" in
    test)
    deploy test
    ;;

    prod)
    deploy prod
    ;;

    *)
    echo "usage : $0 test|prod
    test     Deploy test version
    prod     Deploy prod version
"
    ;;
esac