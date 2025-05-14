FROM zenika/node:18-chrome

WORKDIR /app
COPY . .

RUN npm install
EXPOSE 8080
CMD ["npm", "start"]
