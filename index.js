const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.json());

// Inicializace WhatsApp klienta
const client = new Client({
  authStrategy: new LocalAuth(),
  puppeteer: {
    args: ['--no-sandbox'],
    headless: true,
  }
});

// QR kód pro přihlášení (na vývojovém prostředí)
client.on('qr', qr => {
  console.log('📱 QR kód pro WhatsApp:');
  qrcode.generate(qr, { small: true });
});

// Po připojení klienta
client.on('ready', () => {
  console.log('✅ WhatsApp klient připraven!');
});

// Spuštění klienta
client.initialize();

// POST endpoint pro odesílání zpráv do skupiny
app.post('/send', async (req, res) => {
  const { groupName, message } = req.body;

  // Kontrola požadovaných parametrů
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

// Spuštění serveru
app.listen(port, () => {
  console.log(`🟢 Server běží na portu ${port}`);
});
