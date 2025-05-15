const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode'); // ❗ použijeme pouze tento
const fs = require('fs');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
  res.send('WhatsApp bot je aktivní');
});

app.use(bodyParser.json());

const client = new Client({
  authStrategy: new LocalAuth(),
  puppeteer: {
    args: ['--no-sandbox'],
    headless: true,
  }
});

// Generování QR kódu a uložení do souboru
client.on('qr', qr => {
  console.log('🔐 QR kód vygenerován, ukládám jako qr.png...');
  qrcode.toFile('qr.png', qr, (err) => {
    if (err) {
      console.error('❌ Chyba při ukládání QR kódu:', err);
    } else {
      console.log('✅ QR kód uložen jako qr.png');
    }
  });
});

client.on('ready', () => {
  console.log('✅ WhatsApp klient připraven!');
});

client.initialize();

// Endpoint pro odesílání zpráv do skupin
app.post('/send', async (req, res) => {
  const { groupName, message } = req.body;

  if (!groupName || !message) {
    return res.status(400).json({ error: "❗ Chybí groupName nebo message" });
  }

  try {
    const chats = await client.getChats();
    const group = chats.find(chat => chat.isGroup && chat.name === groupName);

    if (!group) {
      return res.status(404).json({ error: `❌ Skupina '${groupName}' nenalezena` });
    }

    await client.sendMessage(group.id._serialized, message);
    console.log(`📤 Zpráva odeslána do skupiny '${groupName}': ${message}`);
    res.json({ status: "✅ Zpráva odeslána" });

  } catch (err) {
    console.error('❌ Chyba při odesílání zprávy:', err);
    res.status(500).json({ error: "Chyba při odesílání zprávy" });
  }
});

app.listen(port, () => {
  console.log(`🟢 Server běží na portu ${port}`);
});
