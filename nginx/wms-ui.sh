#!/bin/bash

env=fn
#host=$host

cat << EOF > feely-wms-ui.conf
#resolver 10.43.0.10 valid=5s;

upstream apigateway {
  server feely-apigateway-prod:8097;
}

upstream msg {
  server feely-msg-prod:9090;
}

upstream editor {
  server ueditor-prod:8089;
}

server {
        listen 33800;
        server_name  _;
        root   /usr/share/nginx/html;
#        root /mnt/work/ruibo-sso-ui/html/dist;
        client_max_body_size 100m;

        #charset koi8-r;
#        access_log  /var/log/nginx/host.access.log  main;
#        error_log  /var/log/nginx/error.log  error;

        location / {
            index index.html index.htm;
            try_files \$uri \$uri/ /index.html;
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

        location /feely-tb {
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
            proxy_pass http://apigateway/feely-apigateway/feely-tb;
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

        location /msg {
           proxy_pass http://msg/msg;
           proxy_http_version 1.1;
           proxy_read_timeout 300s;
           proxy_send_timeout 300s;
           proxy_set_header Host \$http_host;
           proxy_set_header X-Real-IP \$remote_addr;
		   proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
           proxy_set_header X-Scheme \$scheme;
           proxy_set_header Upgrade \$http_upgrade;
           proxy_set_header Connection "upgrade";
        }

        location /editor {
            proxy_pass http://editor/editor;
			proxy_set_header Host \$host:\$server_port;
			proxy_set_header X-Real-PORT \$remote_port;
			proxy_set_header X-Real-IP \$remote_addr;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
EOF