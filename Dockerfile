FROM node:20-slim

WORKDIR /app

# Vi kopierer alt først for å være helt sikre på at filene er der
COPY . .

# Sjekker om filen faktisk finnes før vi kjører npm install
RUN if [ ! -f "package.json" ]; then echo "FEIL: package.json ikke funnet i build context!"; exit 1; fi

RUN npm install --omit=dev

EXPOSE 80

CMD ["npm", "start"]
