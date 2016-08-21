--------------------------------------
-- English localization for No Thank You! --
--------------------------------------

--addon menu
local strings = {
	
	NOTY_INTERACTION_TAKE = "Take", -- Don't change
	NOTY_INSECT_BUTTERFLY = "Butterfly", -- Don't change
	NOTY_INSECT_TORCHBUG = "Torchbug", -- Don't change
	NOTY_INSECT_WASP = "Wasp", -- Don't change
	NOTY_INSECT_FLESHFLIES = "Fleshflies", -- Don't change
	
	NOTY_RAID_COMPLETE = " 完了",
	NOTY_RAID_OTHERS = "と <<1>> その他",
	
	NOTY_GUILD_INV_OPTION_0 = "なし",
	NOTY_GUILD_INV_OPTION_1 = "常に",
	NOTY_GUILD_INV_OPTION_2 = "ギルドが一杯の時",
	
	NOTY_AVA_MODE_OPTION_0 = "なし",
	NOTY_AVA_MODE_OPTION_1 = "チャットメッセージ",
	NOTY_AVA_MODE_OPTION_2 = "サイレント",
	
	NOTY_SOUND_MODE_OPTION_0 = "なし",
	NOTY_SOUND_MODE_OPTION_1 = "戦闘外",
	NOTY_SOUND_MODE_OPTION_2 = "戦闘中",
	NOTY_SOUND_MODE_OPTION_3 = "常に",
	
	NOTY_GALERTS_OPTION_0 = "なし",
	NOTY_GALERTS_OPTION_1 = "チャットメッセージ",
	NOTY_GALERTS_OPTION_2 = "サイレント",
	
	NOTY_RAID_OPTION_0 = "常に",
	NOTY_RAID_OPTION_1 = "フレンド",
	NOTY_RAID_OPTION_2 = "ギルドメンバー",
	NOTY_RAID_OPTION_3 = "なし",
	
	NOTY_MOTD_OPTION_0 = "なし",
	NOTY_MOTD_OPTION_1 = "チャットメッセージ",
	NOTY_MOTD_OPTION_2 = "サイレント",
	
	NOTY_GUILDLEAVE_OPTION_0 = "非活性化しない",
	NOTY_GUILDLEAVE_OPTION_1 = "全てのギルド",
	NOTY_GUILDLEAVE_OPTION_2 = "ギルド毎",
	
	NOTY_LUAMEM_OPTION_0 = "通知",
	NOTY_LUAMEM_OPTION_1 = "ダイアログ",
	
	NOTY_LUAERR_OPTION_0 = "なし",
	NOTY_LUAERR_OPTION_1 = "通知",
	
	NOTYOU_LUAERR_MESSAGE = "Luaエラー発生",
	NOTYOU_LUAERR_HEADING = "Luaエラー",
	NOTYOU_LUAERR_SHORT = "Luaエラー",
	
	NOTYOU_LUAMEM_MESSAGE = "アドオンがメモリの上限に達しました",
	NOTYOU_LUAMEM_HEADING = "Luaメモリエラー",
	NOTYOU_LUAMEM_SHORT = "Luaメモリエラー",
	
	NOTYOU_LUADIALOG_TITLE = "Luaがメモリの上限に達しています.",
	NOTYOU_LUADIALOG_TEXT = "Luaのメモリ上限を|cFFFFFF<<1>>|rからcFFFFFF<<2>>|r MBへ増加しますか？（UIがリロードされます）",
	
	NOTYOU_AVA_HEADER = "AvAメッセージ",
	NOTYOU_AVA = "ブロックオプション:",
	NOTYOU_AVA_TOOLTIP = "AvAの世界外でAvAメッセージの制御方法を選択してください:\n|cFFFFFFなし|r - AvAメッセージについて何も変更しません\n|cFFFFFFチャットメッセージ|r - メッセージはチャットにリダイレクトされます\n|cFFFFFFサイレント|r - メッセージは完全に削除されます",
	
	NOTYOU_FRIENDS_HEADER = "フレンドステータスメッセージ",
	NOTYOU_FRIENDS_ACTIVITY = "フレンドステータス警告のブロック",
	NOTYOU_FRIENDS_ACTIVITY_TOOLTIP = "フレンドがログイン・ログアウトした時の警告をブロックします:\n- |cFFFFFF[@username] が [character] のキャラクターでログインしました|r\n- |cFFFFFF[@username] が [character] のキャラクターでログアウトしました|r",
	
	NOTYOU_TEXT_ALERTS_HEADER = "Text Alerts",
	NOTYOU_MOB_IMMUNE = "Block \"target immune\" alerts",
	NOTYOU_MOB_IMMUNE_TOOLTIP = "Block text alerts which are often spammed during the boss fight:\n- |cFFFFFF".. GetErrorString(162) .."|r\n- |cFFFFFF".. GetErrorString(176) .."|r\n- |cFFFFFF".. GetErrorString(177) .."|r\n- |cFFFFFFYou must have a valid empty soul gem.|r",
	NOTYOU_SCREENSHOT = "Block \"screenshot saved\" alerts",
	NOTYOU_SCREENSHOT_TOOLTIP = "Block alerts when you take a screenshot:\n- |cFFFFFFScreenshot saved as: <path>|r",
	NOTYOU_ENLIGHTENED = "Block \"enlightened\" alert",
	NOTYOU_ENLIGHTENED_TOOLTIP = "Block enlightened alert when player is activated:\n- |cFFFFFFYou are enlightened|r",
	NOTYOU_CRAFTRESULT = "Block crafting result alerts",
	NOTYOU_CRAFTRESULT_TOOLTIP = "Block crafting result alerts:\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_SUCCESS) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_BLACKSMITH_EXTRACTION_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_DECONSTRUCTION_LEVEL_PENALTY) .. "|r\n- |cFFFFFF" .. GetString(SI_ALCHEMY_NO_YIELD) .. "|r\n- |cFFFFFF" .. GetString(SI_ENCHANT_NO_YIELD) .. "|r",
	NOTYOU_REPAIR = "Block repair alerts",
	NOTYOU_REPAIR_TOOLTIP = "Block repair alerts:\n- |cFFFFFF<item> repaired.|r",
	NOTYOU_ALERT_THROTTLING = "Delay between the same alerts",
	NOTYOU_ALERT_THROTTLING_TOOLTIP = "Don't show the same alert more often then selected (seconds)",
	
	NOTYOU_SOUND_HEADER = "Sound Alerts",
	NOTYOU_ULTISOUND = "Mute \"ultimate ready\" sound:",
	NOTYOU_ULTISOUND_TOOLTIP = "Select when you want to mute \"ultimate ready\" sound.",
	
	NOTYOU_MARKET_HEADER = "Market Announcement",
	NOTYOU_MARKET_ADS = "Hide market annoucement",
	NOTYOU_MARKET_ADS_TOOLTIP = "Hide market announcement when you log into the game.",
	
	NOTYOU_MAIL_HEADER = "Delete Mail dialog",
	NOTYOU_MAIL = "Remove \"Delete Mail\" dialog",
	NOTYOU_MAIL_TOOLTIP = "Remove confirmation dialog when deleting empty mail.",
	
	NOTYOU_FENCE_HEADER = "Fence dialog",
	NOTYOU_FENCE = "Remove \"Can't buyback from fence\" dialog",
	NOTYOU_FENCE_TOOLTIP = "Remove confirmation dialog when selling rare items to fence.",
	
	NOTYOU_GROUPS_HEADER = "Group dialogs",
	NOTYOU_GROUPS_DISBAND = "Remove \"Disband Group\" dialog",
	NOTYOU_GROUPS_DISBAND_TOOLTIP = "Remove confirmation dialog when trying to disband a group.",
	NOTYOU_GROUPS_LARGE = "Remove \"Large group conversion\" dialog",
	NOTYOU_GROUPS_LARGE_TOOLTIP = "Remove confirmation dialog when trying to create a large group.",
	
	NOTYOU_CRAFT_HEADER = "Crafting dialogs",
	NOTYOU_CRAFT = "Remove \"Attempt Item Improvement\" dialog",
	NOTYOU_CRAFT_TOOLTIP = "Remove confirmation dialog when trying to improve an item.",
	
	NOTYOU_CHAMELEON_HEADER = "Crown Mimic Stones",
	NOTYOU_CHAMELEON = "Hide the Crown Mimic Stones checkbox",
	NOTYOU_CHAMELEON_TOOLTIP = "Hide the Crown Mimic Stones checkbox when you don't have any of them",
	
	NOTYOU_CHAT_HEADER = "Chat System Button",
	NOTYOU_CHAT = "Fade friends button",
	NOTYOU_CHAT_TOOLTIP = "Enable fade out for friend button above chat window.",
	
	NOTYOU_RETICLE_HEADER = "Reticle",
	NOTYOU_RETICLE_TAKE = "Disable reticle for insects",
	NOTYOU_RETICLE_TAKE_TOOLTIP = "Disable the \"Take\" interaction for collecting butterflies, etc.",
	
	NOTYOU_GUILDS_HEADER = "Guild invites",
	NOTYOU_GUILDS = "Ignore guild invites",
	NOTYOU_GUILDS_TOOLTIP = "Ignore guild invites messages and notifications.",
	
	NOTYOU_GROSTER_HEADER = "Guild Roster Alerts",
	NOTYOU_GROSTER_HEADER_TOOLTIP = "Select how you want to handle guild roster alerts.",
	NOTYOU_GROSTER = "Blocking options:",
	NOTYOU_GROSTER_TOOLTIP = "Select how you want to handle guild roster alerts:\n|cFFFFFFnone|r - no changes\n|cFFFFFFchat message|r - alerts are redirected to the chat\n|cFFFFFFsilent|r - alerts are completely blocked",
	
	NOTYOU_RAIDSCORE_HEADER = "Raid Score Notifications",
	NOTYOU_RAIDSCORE_HEADER_TOOLTIP = "Select how you want to handle Raid Score notifications",
	NOTYOU_RAIDSCORE_ONLYFOR = "Show only for:",
	NOTYOU_RAIDSCORE_ONLYFOR_TOOLTIP = "Select when do you want to see Raid Score Notifications:\n|cFFFFFFalways|r - no changes to notification\n|cFFFFFFfriends|r - only when raid was finished by a friend\n|cFFFFFFguild members|r - only when raid was finished by a guild member (additional filters below)\n|cFFFFFFnever|r - block all Raid Score Notifications",
	NOTYOU_RAIDSCORE_REDIRECT = "Redirect notifications to the chat",
	
	NOTYOU_MOTD_HEADER = "Guild MotD Notifications",
	NOTYOU_MOTD_HEADER_TOOLTIP = "Select how you want to handle Guild Message of the Day notifications",
	NOTYOU_MOTD_BLOCK = "Blocking options:",
	NOTYOU_MOTD_BLOCK_TOOLTIP = "Select how you want to handle Guild MotD Notifications:\n|cFFFFFFnone|r - no changes\n|cFFFFFFchat message|r - notifications are redirected to the chat\n|cFFFFFFsilent|r - notifications are completely blocked",
	
	NOTYOU_GUILDLEAVE_HEADER = "Guild Leave Desactivation",
	NOTYOU_GUILDLEAVE_HEADER_TOOLTIP = "Select how you want to handle the Guild Leave Keybind in Guild Panel",
	NOTYOU_GUILDLEAVE_BLOCK = "Desactivation for:",
	NOTYOU_GUILDLEAVE_BLOCK_TOOLTIP = "Select how you want to handle the Guild Leave keybind:\n|cFFFFFFNo desactivation|r - no changes\n|cFFFFFFAll Guilds|r - Disabled for all guilds\n|cFFFFFFPer Guild|r - Select which guild should have this keybind disabled",
	
	NOTYOU_CAMERA_HEADER = "Camera & Interaction",
	NOTYOU_CAMERA_INTERRUPT = "Don't interrupt interactions",
	NOTYOU_CAMERA_INTERRUPT_TOOLTIP = "Don't interrupt interactions (harvesting, fishing, ...) when you open map, inventory or other scenes.",
	NOTYOU_CAMERA_ROTATE = "Don't rotate game camera",
	NOTYOU_CAMERA_ROTATE_TOOLTIP = "Don't rotate game camera when you open map, inventory or other scenes.",
	
	NOTYOU_AUTOLOOTITEMS_HEADER = "Auto-Loot Containers",
	NOTYOU_AUTOLOOTITEMS = "Auto-Loot Containers",
	NOTYOU_AUTOLOOTITEMS_TOOLTIP = "Auto-Loot Containers if Auto-Loot is activated. Stolen items from containers are auto-looted if the associated option is activated.",
	
	NOTYOU_NOLOREREADER = "Don't read discovered books",
	NOTYOU_NOLOREREADER_TOOLTIP = "Won't display the book you just discovered, except in the library",
	
	NOTYOU_LUA_HEADER = "Lua errors",
	NOTYOU_LUA_MEMORY = "Redirect Lua Memory error to:",
	NOTYOU_LUA_MEMORY_TOOLTIP = "Redirect Lua Memory error to a notification or a dialog instead than the original popup",
	NOTYOU_LUA_ERROR = "Redirect Lua error to:",
	NOTYOU_LUA_ERROR_TOOLTIP = "Redirect Lua errors to a notification instead than the original popup",
	
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
