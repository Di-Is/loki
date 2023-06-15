export -n http_proxy
export -n https_proxy
export -n HTTP_PROXY
export -n HTTPS_PROXY

/usr/bin/loki "--config.file=/etc/loki/config.yml"