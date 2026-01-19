#!/bin/bash

# 1. Install Nginx
apt-get update
apt-get install -y nginx
echo "<h1>Financial Ledger - System Online</h1>" > /var/www/html/index.html

# 2. Enable Nginx Status Page (Internal Heartbeat)
# This allows the Ops Agent to "read" Nginx's performance data
cat <<EOF > /etc/nginx/sites-available/status
server {
    listen 80;
    server_name localhost;
    location /nginx_status {
        stub_status on;
        access_log off;
        allow 127.0.0.1;
        deny all;
    }
}
EOF

ln -s /etc/nginx/sites-available/status /etc/nginx/sites-enabled/status
systemctl restart nginx

# 3. Install the Ops Agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
bash add-google-cloud-ops-agent-repo.sh --also-install

# 4. Configure Ops Agent to Scrape Nginx
sudo tee /etc/google-cloud-ops-agent/config.yaml > /dev/null <<EOF
metrics:
  receivers:
    nginx:
      type: nginx
      stub_status_url: http://127.0.0.1:80/nginx_status
      collection_interval: 60s
  service:
    pipelines:
      nginx:
        receivers:
          - nginx
logging:
  receivers:
    nginx_access:
      type: nginx_access
    nginx_error:
      type: nginx_error
  service:
    pipelines:
      nginx:
        receivers:
          - nginx_access
          - nginx_error
EOF

# Restart the agent
sudo systemctl restart google-cloud-ops-agent