#!/bin/bash

echo "Installing NanoClaw..."

apt update -y
apt install -y docker.io docker-compose git

systemctl start docker
systemctl enable docker

git clone https://github.com/YOUR_REPO/nanoclaw-deploy.git
cd nanoclaw-deploy

cp .env.example .env

docker compose up -d --build

echo "Done. NanoClaw running on port 3000"
