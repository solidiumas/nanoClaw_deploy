#!/bin/bash

set -e

echo "🚀 Starting NanoClaw installation..."

# --- VARIABLES ---
REPO_URL="https://github.com/solidiumas/nanoclaw-deploy.git"
DEPLOY_DIR="/root/nanoclaw-deploy"
NANOCLAW_DIR="/root/nanoclaw"

# --- UPDATE SYSTEM ---
echo "📦 Updating system..."
apt update -y && apt upgrade -y

# --- FIX DOCKER CONFLICTS ---
echo "🧹 Removing conflicting Docker packages..."
apt remove -y containerd containerd.io docker docker-engine docker.io || true
apt autoremove -y

# --- INSTALL DOCKER CLEAN ---
echo "🐳 Installing Docker..."
apt install -y docker.io docker-compose git curl

systemctl enable docker
systemctl start docker

# --- VERIFY DOCKER ---
if ! command -v docker &> /dev/null; then
  echo "❌ Docker failed to install"
  exit 1
fi

# --- FIX PERMISSIONS ---
chmod 666 /var/run/docker.sock || true

# --- CLONE DEPLOY REPO ---
echo "📥 Cloning deploy repo..."
if [ ! -d "$DEPLOY_DIR" ]; then
  git clone $REPO_URL $DEPLOY_DIR
else
  echo "Repo exists, pulling latest..."
  cd $DEPLOY_DIR && git pull
fi

cd $DEPLOY_DIR

# --- ENV SETUP ---
if [ ! -f ".env" ]; then
  echo "⚙️ Creating .env file..."
  cp .env.example .env
  echo "⚠️ SET YOUR API KEY:"
  echo "nano $DEPLOY_DIR/.env"
  sleep 10
fi

# --- CLONE NANOCLAW CORE ---
echo "📥 Cloning NanoClaw core..."
if [ ! -d "$NANOCLAW_DIR" ]; then
  git clone https://github.com/qwibitai/nanoclaw.git $NANOCLAW_DIR
else
  echo "NanoClaw already exists"
fi

# --- BUILD AGENT CONTAINER ---
echo "🏗️ Building agent container..."
cd $NANOCLAW_DIR/container
docker build -t nanoclaw-agent:latest .

# --- START SERVICES ---
echo "🚀 Starting NanoClaw..."
cd $DEPLOY_DIR
docker-compose up -d --build

# --- WAIT ---
sleep 5

# --- CHECK STATUS ---
echo "🔍 Checking containers..."
docker ps

# --- FINAL OUTPUT ---
IP=$(curl -s ifconfig.me)

echo ""
echo "✅ NanoClaw installation complete!"
echo "🌐 Access: http://$IP:3000"
echo ""
echo "📌 Debug if needed:"
echo "docker logs nanoclaw"
