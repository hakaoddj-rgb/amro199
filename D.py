import os
import requests
import time

# ===============================
# جلب التوكن من Termux
# ===============================
TOKEN = os.getenv("BOT_TOKEN")
if not TOKEN:
    print("❌ BOT_TOKEN غير موجود. نفّذ: export BOT_TOKEN=توكنك")
    exit(1)

API_URL = f"https://api.telegram.org/bot{TOKEN}"

# ===============================
# دوال مساعدة
# ===============================
def get_updates(offset=None):
    url = f"{API_URL}/getUpdates?timeout=30"
    if offset:
        url += f"&offset={offset}"
    try:
        r = requests.get(url, timeout=40)
        return r.json()
    except:
        return {}

def send_message(chat_id, text):
    try:
        requests.post(f"{API_URL}/sendMessage", data={"chat_id": chat_id, "text": text})
    except:
        pass

print("🤖 البوت شغال...")

# ===============================
# اللوب الرئيسي
# ===============================
last_update_id = None

while True:
    updates = get_updates(last_update_id)
    if updates.get("ok"):
        for update in updates.get("result", []):
            last_update_id = update["update_id"] + 1
            if "message" in update:
                msg = update["message"]
                chat_id = msg["chat"]["id"]
                text = msg.get("text", "")
                if text == "/start":
                    send_message(chat_id, "✅ البوت شغال")
    time.sleep(1)