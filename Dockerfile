FROM frolvlad/alpine-oraclejdk8

RUN bin/bash -c 'echo This is ....'

ENV myCustomEnvVar = "This is an sample." \
    otherEnvVar = "This is an other sample."

LABEL maintainer "dpjm94@live.ie"




