FROM zenika/node:18-chrome

# Přidání dalších knihoven potřebných pro Puppeteer a Chrome
RUN apt-get update && apt-get install -y \
    libgdk-pixbuf2.0-0 libx11-xcb1 libxcomposite1 libxdamage1 \
    libxrandr2 libgobject-2.0-0 libglib2.0-0 libatk1.0-0 \
    libatk-bridge2.0-0 libcups2 libnspr4 libnss3 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Kopírování package.json a instalace závislostí
COPY package.json .
COPY package-lock.json .
RUN npm install

# Kopírování zbytku kódu
COPY . .

# Spuštění aplikace
CMD ["npm", "start"]
