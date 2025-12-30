<?php

$token = getenv("BOT_TOKEN");
if (!$token) {
    die("❌ BOT_TOKEN غير موجود\n");
}

$api = "https://api.telegram.org/bot$token/";
$offset = 0;

while (true) {
    $response = file_get_contents($api . "getUpdates?timeout=30&offset=$offset");
    $data = json_decode($response, true);

    if (!empty($data["result"])) {
        foreach ($data["result"] as $update) {
            $offset = $update["update_id"] + 1;

            if (isset($update["message"]["text"])) {
                $text = $update["message"]["text"];
                $chat_id = $update["message"]["chat"]["id"];

                if ($text === "/start") {
                    $msg = "مرحبا بك 👋";
                    file_get_contents(
                        $api . "sendMessage?chat_id=$chat_id&text=" . urlencode($msg)
                    );
                }
            }
        }
    }
}