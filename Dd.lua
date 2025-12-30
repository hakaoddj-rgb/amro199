-- =========================
-- متطلبات
-- =========================
https = require("ssl.https")
ltn12 = require("ltn12")
json  = require("dkjson")

-- =========================
-- التوكن من Termux
-- =========================
local TOKEN = os.getenv("BOT_TOKEN")
if not TOKEN then
  print("❌ BOT_TOKEN غير موجود")
  os.exit(1)
end

local API = "https://api.telegram.org/bot" .. TOKEN
local offset = 0

-- =========================
-- دالة طلب API
-- =========================
local function apiRequest(method, data)
  local response = {}
  local body = json.encode(data or {})

  https.request{
    url = API .. "/" .. method,
    method = "POST",
    headers = {
      ["Content-Type"]   = "application/json",
      ["Content-Length"] = tostring(#body)
    },
    source = ltn12.source.string(body),
    sink   = ltn12.sink.table(response)
  }

  return json.decode(table.concat(response))
end

-- =========================
-- إرسال رسالة
-- =========================
local function sendMessage(chat_id, text)
  apiRequest("sendMessage", {
    chat_id = chat_id,
    text = text
  })
end

print("🤖 البوت شغال...")

-- =========================
-- اللوب الرئيسي
-- =========================
while true do
  local updates = apiRequest("getUpdates", {
    timeout = 30,
    offset = offset + 1
  })

  if updates and updates.result then
    for _, update in ipairs(updates.result) do
      offset = update.update_id

      if update.message and update.message.text then
        local chat_id = update.message.chat.id
        local text = update.message.text

        if text == "/start" then
          sendMessage(chat_id, "✅ البوت شغال بدون مشاكل")
        end
      end
    end
  end

  os.execute("sleep 1")
end