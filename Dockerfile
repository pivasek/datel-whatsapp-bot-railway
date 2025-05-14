# Použití oficiálního Node.js image
FROM node:18-slim

# Instalace potřebných knihoven pro Puppeteer a Chromium
RUN apt-get update && apt-get install -y \
    wget ca-certificates fonts-liberation libappindicator3-1 libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils libgbm-dev libgtk-3-0 libxshmfence-dev libgobject-2.0-0 libglib2.0-0 libatk1.0-0 libatk-bridge2.0-0 --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Nastavení pracovní složky
WORKDIR /app

# Kopírování souborů package.json a package-lock.json a instalace závislostí
COPY package.json .
COPY package-lock.json .
RUN npm install

# Kopírování celého kódu
COPY . .

# Spuštění aplikace
CMD ["npm", "start"]
