FROM node:18

# Instalace potřebných balíčků pro Puppeteer (Chromium)
RUN apt-get update && \
    apt-get install -y wget ca-certificates fonts-liberation libappindicator3-1 \
    libasound2 libatk-bridge2.0-0 libatk1.0-0 libcups2 libdbus-1-3 libgdk-pixbuf2.0-0 \
    libnspr4 libnss3 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 xdg-utils \
    libgbm-dev libgtk-3-0 libxshmfence-dev libglib2.0-0 libgobject-2.0-0 --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

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
