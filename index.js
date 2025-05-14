const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

const client = new Client({
  authStrategy: new LocalAuth(),
  puppeteer: {
    args: ['--no-sandbox'],
    headless: true,
  }
});

client.on('qr', qr => {
  console.log('QR kód pro WhatsApp:');
  qrcode.generate(qr, { small: true });
});

client.on('ready', () => {
  console.log('✅ WhatsApp klient připraven!');
});

client.initialize();

app.post('/send', async (req, res) => {
  const { groupName, message } = req.body;
  if (!groupName || !message) return res.status(400).send("Chybí groupName nebo message");

  try {
    const chats = await client.getChats();
    const group = chats.find(chat => chat.isGroup && chat.name === groupName);
    if (!group) return res.status(404).send("Skupina nenalezena");

    await client.sendMessage(group.id._serialized, message);
    res.send("Zpráva odeslána");
  } catch (err) {
    console.error(err);
    res.status(500).send("Chyba při odesílání");
  }
});

app.listen(port, () => {
  console.log(`🟢 Server běží na portu ${port}`);
});
