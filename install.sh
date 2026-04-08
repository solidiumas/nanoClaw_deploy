#!/bin/bash
set -e

# Farger for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starter NanoClaw Deployment...${NC}"

# 1. Installer Docker hvis det mangler
if ! [ -x "$(command -v docker)" ]; then
    echo -e "${GREEN}📦 Docker ikke funnet. Installerer nå...${NC}"
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
else
    echo -e "${GREEN}✅ Docker er allerede installert.${NC}"
fi

# 2. Klargjør installasjonsmappe
echo -e "${BLUE}📂 Klargjør /opt/nanoclaw...${NC}"
mkdir -p /opt/nanoclaw
cd /opt/nanoclaw

# 3. Last ned den nyeste docker-compose filen
echo -e "${BLUE}📥 Henter nyeste konfigurasjon...${NC}"
curl -sSL https://raw.githubusercontent.com/solidiumas/nanoclaw-deploy/main/docker-compose.yml -o docker-compose.yml

# 4. Pull de nyeste bildene og start
echo -e "${BLUE}🐳 Starter containere via GitHub Container Registry...${NC}"
docker compose pull
docker compose up -d

echo -e "${GREEN}✨ Installasjonen er fullført!${NC}"
echo "NanoClaw skal nå være tilgjengelig på denne serverens IP-adresse."
