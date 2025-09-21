echo "Expose Kubernetes to dns using HTTPS"

sudo apt install nginx certbot python3-certbot-nginx -y

alias kubectl="microk8s kubectl"

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



sudo tee /etc/nginx/sites-available/argocd.codeota.com > /dev/null <<EOF
server {
    listen 80;
    server_name argocd.codeota.com;

    location / {
        proxy_pass http://127.0.0.1:30443;  # Argo CD NodePort
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
    }
}
EOF

sudo ln -s /etc/nginx/sites-available/argocd.codeota.com /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx



echo "Setup TLS -- manual intervention necessary"

sudo certbot --nginx -d argocd.codeota.com

