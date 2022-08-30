FROM golang:1.17 as builder
RUN apt-get update && apt-get -y upgrade && apt-get -y install make git
COPY  . /container-diff
RUN cd /container-diff && make cross
RUN cp /container-diff/out/container-diff-linux-amd64 /usr/bin/container-diff-linux-amd64
RUN chmod a+x /usr/bin/container-diff-linux-amd64