#!/bin/bash

env=fn
server1=
server2=10.0.17.140
#host=$host

cat << EOF > ruibo-sso-ui.conf
resolver 10.43.0.10 valid=5s;

upstream apigateway {
  server feely-apigateway-prod:8097;
}

upstream tb {
  server feely-tb-prod:9090;
}

upstream jd {
  server feely-jd-prod:8089;
}

server {
        listen 34800;
        server_name  _;
        root   /usr/share/nginx/html;
#        root /mnt/work/ruibo-sso-ui/html/dist;
        client_max_body_size 100m;

        location / {
            index index.html index.htm;
            try_files \$uri \$uri/ /index.html;
        }

        location /feely-tb {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://tb/feely-tb;
        }

        location /feely-jd {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://jd/feely-tb;
        }

        location /feely-apigateway {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway;
        }

       location /feely-wms {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-wms;
        }

       location /feely-tms {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-tms;
        }

        location /feely-sys {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-sys;
        }

        location /feely-pms {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-pms;
        }

        location /feely-crm {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-crm;
        }

        location /feely-oms {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-oms;
        }

        location /feely-bms {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-bms;
        }

        location /feely-msg {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-msg;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
EOF