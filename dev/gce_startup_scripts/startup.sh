#!/bin/bash

# 1. Clean App Installation
apt-get update
apt-get install -y nginx
echo "<h1>Financial Ledger - System Online</h1>" > /var/www/html/index.html

# 2. Fix Nginx Configuration (The "Mold")
# We remove the default site to prevent it from blocking our status page
rm -f /etc/nginx/sites-enabled/default

cat <<EOF > /etc/nginx/sites-available/status
server {
    listen 80 default_server;
    server_name _;

    location /nginx_status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }

    location / {
        root /var/www/html;
        index index.html;
    }
}
EOF

ln -sf /etc/nginx/sites-available/status /etc/nginx/sites-enabled/status
systemctl restart nginx

# 3. Install/Refresh Ops Agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install

# 4. Explicit Config (Indentation-Proof)
cat <<EOF > /etc/google-cloud-ops-agent/config.yaml
metrics:
  receivers:
    nginx:
      type: nginx
      stub_status_url: http://127.0.0.1:80/nginx_status
  service:
    pipelines:
      nginx:
        receivers: [nginx]
logging:
  receivers:
    nginx_access:
      type: nginx_access
    nginx_error:
      type: nginx_error
  service:
    pipelines:
      nginx:
        receivers: [nginx_access, nginx_error]
EOF

systemctl restart google-cloud-ops-agent