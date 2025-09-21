#!/bin/bash

# Exit on error
set -e

# Read hostname from the first argument
DOMAIN="$1"

if [ -z "$DOMAIN" ]; then
  echo "Usage: $0 <your-domain>"
  exit 1
fi

echo "Expose Kubernetes to DNS using HTTPS for $DOMAIN"

# Install required packages
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx -y

# Alias kubectl to microk8s
alias kubectl="microk8s kubectl"

# Patch the ArgoCD service to expose it via NodePort
kubectl patch svc argocd-server -n argocd -p '{
  "spec": {
    "type": "NodePort",
    "ports": [
      {
        "port": 443,
        "targetPort": 8080,
        "nodePort": 30443,
        "protocol": "TCP",
        "name": "https"
      }
    ]
  }
}'

# Configure NGINX reverse proxy
sudo tee /etc/nginx/sites-available/$DOMAIN > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass https://$DOMAIN:30443;
    }
}
EOF

# Enable the NGINX site and reload
sudo ln -sf /etc/nginx/sites-available/$DOMAIN /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx

# Obtain TLS certificate
echo "Setting up TLS using Certbot for $DOMAIN"
sudo certbot --nginx -d $DOMAIN

