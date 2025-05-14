# ✅ Použij oficiální Node image
FROM node:18-slim

# ✅ Nastav pracovní složku
WORKDIR /app

# ✅ Zkopíruj package.json a package-lock.json
COPY package*.json ./

# ✅ Instaluj závislosti
RUN npm install

# ✅ Instaluj Chromium a knihovny potřebné pro Puppeteer
RUN apt-get update && apt-get install -y \
    wget \
    ca-certificates \
    fonts-liberation \
    libappindicator3-1 \
    libasound2 \
    libatk-bridge2.0-0 \
    libatk1.0-0 \
    libcups2 \
    libdbus-1-3 \
    libgdk-pixbuf2.0-0 \
    libnspr4 \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxdamage1 \
    libxrandr2 \
    xdg-utils \
    libgbm-dev \
    libgtk-3-0 \
    libxshmfence-dev \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# ✅ Zkopíruj zbytek kódu
COPY . .

# ✅ Exponuj port
EXPOSE 8080

# ✅ Spusť aplikaci
CMD ["npm", "start"]
