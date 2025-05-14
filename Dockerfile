FROM puppeteer/puppeteer:latest

# Nastavení pracovní složky
WORKDIR /app

# Kopírování package.json a instalace závislostí
COPY package*.json ./
RUN npm install

# Kopírování zbytku kódu
COPY . .

# Expozice portu
EXPOSE 8080

# Startování aplikace
CMD ["npm", "start"]
