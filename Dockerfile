FROM nginx:1.11.9-alpine

# for htpasswd command
RUN apk add --no-cache --update \
      apache2-utils
RUN rm -f /etc/nginx/conf.d/*

ENV SERVER_NAME nginx-myproject.192.168.42.13.nip.io
ENV PORT 8080
ENV CLIENT_MAX_BODY_SIZE 1m
ENV PROXY_READ_TIMEOUT 60s
ENV WORKER_PROCESSES auto

COPY files/run.sh /
COPY files/nginx.conf.tmpl /

# permission
RUN chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
     && chgrp -R 0 /etc/nginx \
     && chmod -R g+rwX /etc/nginx

# use SIGQUIT for graceful shutdown
# c.f. http://nginx.org/en/docs/control.html
STOPSIGNAL SIGQUIT
EXPOSE 8080
ENTRYPOINT ["/run.sh"]
