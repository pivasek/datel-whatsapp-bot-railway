# ✅ Použij image s Chrome a Node.js
FROM browserless/chrome:latest

# ✅ Vytvoř pracovní adresář a nastav práva
WORKDIR /app
RUN mkdir -p /app && chown -R chrome:chrome /app

# ✅ Přepni se na uživatele s oprávněním
USER chrome

# ✅ Zkopíruj balíčky a nainstaluj
COPY --chown=chrome:chrome package*.json ./
RUN npm install

# ✅ Zkopíruj zbytek projektu
COPY --chown=chrome:chrome . .

# ✅ Spusť aplikaci
CMD ["npm", "start"]
