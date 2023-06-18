FROM ubuntu:22.04

RUN apt update && apt install -y curl jq

ENTRYPOINT [ "/bin/bash", "/tests/series_curl/entrypoint.sh" ]