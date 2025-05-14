FROM browserless/chrome:latest

# Volitelně přidej své soubory, např.:
COPY . /app
WORKDIR /app

# Nainstaluj závislosti
RUN npm install

# Spusť aplikaci
CMD ["npm", "start"]
