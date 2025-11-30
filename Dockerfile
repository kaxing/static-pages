FROM nginx:mainline-alpine-slim

RUN cat <<'EOF' >/etc/nginx/conf.d/default.conf
server {
    listen 80 default_server;
    server_name _;
    root /usr/share/nginx/html;

    server_tokens off;

    gzip on;
    gzip_min_length 1024;
    gzip_types
        text/plain
        text/css
        application/json
        application/javascript
        application/xml
        text/javascript;

    client_max_body_size 2M;

    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header Referrer-Policy no-referrer-when-downgrade;
    add_header X-XSS-Protection "1; mode=block";

    location / {
        try_files $uri $uri/ =404;
    }

    location = /healthz {
        return 200;
    }
}
EOF

RUN sed -i 's/worker_processes  auto;/worker_processes  1;/' /etc/nginx/nginx.conf && sed -i 's#error_log  /var/log/nginx/error.log notice;#error_log  /var/log/nginx/error.log warn;#' /etc/nginx/nginx.conf && rm -f /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh

COPY site /usr/share/nginx/html
