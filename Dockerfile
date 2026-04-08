FROM node:20-slim

WORKDIR /app

# Kopier avhengigheter
COPY package*.json ./
RUN npm install --omit=dev

# Kopier resten av koden (server.js osv)
COPY . .

# Sjekk at server.js faktisk ble med
RUN ls -l /app

EXPOSE 80

CMD ["node", "server.js"]
