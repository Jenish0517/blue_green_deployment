#!/bin/bash

echo "Switching traffic to GREEN..."

cat > nginx/nginx.conf <<EOF
events {}

http {
    upstream app {
        server green:80;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://app;
        }
    }
}
EOF

docker exec nginx-lb nginx -s reload

echo "Traffic switched to GREEN"