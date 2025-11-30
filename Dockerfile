FROM nginx:mainline-alpine-slim

RUN set -e; rm /etc/nginx/conf.d/default.conf && cat <<'EOF' > /etc/nginx/conf.d/default.conf
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

COPY site /usr/share/nginx/html
