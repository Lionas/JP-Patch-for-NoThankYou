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
	NOTYOU_FRIENDS_ACTIVITY = "フレンドステータスアラートのブロック",
	NOTYOU_FRIENDS_ACTIVITY_TOOLTIP = "フレンドがログイン・ログアウトした時のアラートをブロックします:\n- |cFFFFFF[@username] が [character] のキャラクターでログインしました|r\n- |cFFFFFF[@username] が [character] のキャラクターでログアウトしました|r",
	
	NOTYOU_TEXT_ALERTS_HEADER = "テキストアラート",
	NOTYOU_MOB_IMMUNE = "\"ターゲットが免れた\" アラートをブロック",
	NOTYOU_MOB_IMMUNE_TOOLTIP = "ボスと戦っている時に度々表示されるテキストアラートをブロックします:\n- |cFFFFFF".. GetErrorString(162) .."|r\n- |cFFFFFF".. GetErrorString(176) .."|r\n- |cFFFFFF".. GetErrorString(177) .."|r\n- |cFFFFFF空の魂石を持っている必要があります.|r",
	NOTYOU_SCREENSHOT = "\"スクリーンショットを保存した\"アラートをブロック",
	NOTYOU_SCREENSHOT_TOOLTIP = "スクリーンショットを撮った時のアラートをブロックします:\n- |cFFFFFFスクリーンショットは保存されました: <path>|r",
	NOTYOU_ENLIGHTENED = "\"悟りを開いた\" アラートをブロック",
	NOTYOU_ENLIGHTENED_TOOLTIP = "プレイヤーがアクティベートした時の悟りを開いたアラートをブロックします:\n- |cFFFFFFあなたは悟りを開いた|r",
	NOTYOU_CRAFTRESULT = "クラフトの結果アラートをブロック",
	NOTYOU_CRAFTRESULT_TOOLTIP = "クラフトの結果アラートをブロックします:\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_SUCCESS) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_BLACKSMITH_EXTRACTION_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_DECONSTRUCTION_LEVEL_PENALTY) .. "|r\n- |cFFFFFF" .. GetString(SI_ALCHEMY_NO_YIELD) .. "|r\n- |cFFFFFF" .. GetString(SI_ENCHANT_NO_YIELD) .. "|r",
	NOTYOU_REPAIR = "修理アラートをブロック",
	NOTYOU_REPAIR_TOOLTIP = "修理アラートをブロックします:\n- |cFFFFFF<item> が修理されました|r",
	NOTYOU_ALERT_THROTTLING = "同じアラートを遅延",
	NOTYOU_ALERT_THROTTLING_TOOLTIP = "選択した秒数以上同じアラートを表示しません",
	
	NOTYOU_SOUND_HEADER = "サウンドアラート",
	NOTYOU_ULTISOUND = "\"アルティメット準備完了\"サウンドをミュート:",
	NOTYOU_ULTISOUND_TOOLTIP = "\"アルティメットが準備できました\"サウンドをミュートする時を選択します",
	
	NOTYOU_MARKET_HEADER = "マーケットアナウンス",
	NOTYOU_MARKET_ADS = "マーケットアナウンスを隠す",
	NOTYOU_MARKET_ADS_TOOLTIP = "ゲームにログインした時のマーケットアナウンスを隠します",
	
	NOTYOU_MAIL_HEADER = "メールダイアログを削除",
	NOTYOU_MAIL = "\"メールを削除\"ダイアログを除去",
	NOTYOU_MAIL_TOOLTIP = "空のメールを削除する時の確認ダイアログを除去します",
	
	NOTYOU_FENCE_HEADER = "ダイアログを防ぐ",
	NOTYOU_FENCE = "\"盗品商から買い戻しができない\"ダイアログを除去",
	NOTYOU_FENCE_TOOLTIP = "盗品商にレアアイテムを売るときの確認ダイアログを除去します",
	
	NOTYOU_GROUPS_HEADER = "グループダイアログ",
	NOTYOU_GROUPS_DISBAND = "\"グループを解散する\"ダイアログを除去",
	NOTYOU_GROUPS_DISBAND_TOOLTIP = "グループを解散しようとした時の確認ダイアログを除去します",
	NOTYOU_GROUPS_LARGE = "\"大きなグループへの変換\"ダイアログを除去",
	NOTYOU_GROUPS_LARGE_TOOLTIP = "大きなグループを作成しようとした時の確認ダイアログを除去します",
	
	NOTYOU_CRAFT_HEADER = "クラフトダイアログ",
	NOTYOU_CRAFT = "\"アイテムの改良を試みる\"ダイアログを除去",
	NOTYOU_CRAFT_TOOLTIP = "アイテムを改良することを試みた時の確認ダイアログを除去します",
	
	NOTYOU_CHAMELEON_HEADER = "クラウンミミックストーン",
	NOTYOU_CHAMELEON = "クラウンミミックストーンのチェックボックスを隠す",
	NOTYOU_CHAMELEON_TOOLTIP = "アイテムを持っていない時にクラウンミミックストーンのチェックボックスを隠します",
	
	NOTYOU_CHAT_HEADER = "チャットシステムボタン",
	NOTYOU_CHAT = "フレンドボタンをフェードする",
	NOTYOU_CHAT_TOOLTIP = "チャットウィンドウ上のフレンドボタンのフェードアウトを有効にします",
	
	NOTYOU_RETICLE_HEADER = "照準",
	NOTYOU_RETICLE_TAKE = "虫に対する照準を無効にする",
	NOTYOU_RETICLE_TAKE_TOOLTIP = "蝶々の収集などで \"取る\" インタラクションを無効にします",
	
	NOTYOU_GUILDS_HEADER = "ギルド招待",
	NOTYOU_GUILDS = "ギルドの招待を無視する",
	NOTYOU_GUILDS_TOOLTIP = "ギルドの招待メッセージと通知を無視します",
	
	NOTYOU_GROSTER_HEADER = "ギルド名簿アラート",
	NOTYOU_GROSTER_HEADER_TOOLTIP = "ギルド名簿アラートをどのように扱うかを選択",
	NOTYOU_GROSTER = "ブロックオプション:",
	NOTYOU_GROSTER_TOOLTIP = "ギルド名簿アラートをどのように扱うかを選択します:\n|cFFFFFFなし|r - 変更しない\n|cFFFFFFチャットメッセージ|r - アラートをチャットにリダイレクトする\n|cFFFFFFサイレント|r - アラートは完全にブロックされる",
	
	NOTYOU_RAIDSCORE_HEADER = "レイドスコア通知",
	NOTYOU_RAIDSCORE_HEADER_TOOLTIP = "レイドスコア通知をどのように扱うかを選択",
	NOTYOU_RAIDSCORE_ONLYFOR = "表示方法:",
	NOTYOU_RAIDSCORE_ONLYFOR_TOOLTIP = "レイドスコア通知をいつ見るかを選択します:\n|cFFFFFF常に|r - 通知を変更しない\n|cFFFFFFフレンド|r - フレンドによって完了した時のみ\n|cFFFFFFギルドメンバー|r - レイドがギルドメンバーによって完了した時のみ（加えて下記のフィルターも）\n|cFFFFFFなし|r - 全てのレイドスコア通知をブロック",
	NOTYOU_RAIDSCORE_REDIRECT = "チャットに通知をリダイレクト",
	
	NOTYOU_MOTD_HEADER = "本日のギルドメッセージ通知",
	NOTYOU_MOTD_HEADER_TOOLTIP = "本日のギルドメッセージ通知をどのように扱うかを選択",
	NOTYOU_MOTD_BLOCK = "ブロックオプション:",
	NOTYOU_MOTD_BLOCK_TOOLTIP = "本日のギルドメッセージ通知をどのように扱うかを選択:\n|cFFFFFFなし|r - 変更しない\n|cFFFFFFチャットメッセージ|r - 通知はチャットにリダイレクトされます\n|cFFFFFFサイレント|r - 通知は完全にブロックされます",
	
	NOTYOU_GUILDLEAVE_HEADER = "ギルドから脱退の非活性化",
	NOTYOU_GUILDLEAVE_HEADER_TOOLTIP = "ギルドパネルのギルドから脱退するキーバインドをどのように扱うかを選択",
	NOTYOU_GUILDLEAVE_BLOCK = "非活性化方法:",
	NOTYOU_GUILDLEAVE_BLOCK_TOOLTIP = "ギルド脱退のキーバインドをどのように扱うかを選択します:\n|cFFFFFF非活性化しない|r - 変更しない\n|cFFFFFF全てのギルド|r - 全てのギルドで無効\n|cFFFFFFギルド毎|r - キーバインドを無効にすべきギルドを選択します",
	
	NOTYOU_CAMERA_HEADER = "カメラ＆インタラクション",
	NOTYOU_CAMERA_INTERRUPT = "インタラクションを中断しない",
	NOTYOU_CAMERA_INTERRUPT_TOOLTIP = "地図やインベントリを開いた時やその他のシーンで、インタラクション（採集、釣りなど）を中断しません",
	NOTYOU_CAMERA_ROTATE = "カメラを回転しない",
	NOTYOU_CAMERA_ROTATE_TOOLTIP = "地図やインベントリを開いた時やその他のシーンで、カメラを回転しません",
	
	NOTYOU_AUTOLOOTITEMS_HEADER = "自動取得コンテナ",
	NOTYOU_AUTOLOOTITEMS = "自動取得コンテナ",
	NOTYOU_AUTOLOOTITEMS_TOOLTIP = "自動取得が有効な場合に、自動的にコンテナを取得します。関連するオプションを有効にしている場合、コンテナからの盗品も自動的に取得します。",
	
	NOTYOU_NOLOREREADER = "発見済みの本を開かない",
	NOTYOU_NOLOREREADER_TOOLTIP = "図書館を除いて、発見したばかりの本を表示しません",
	
	NOTYOU_LUA_HEADER = "Luaエラー",
	NOTYOU_LUA_MEMORY = "Luaメモリエラーを次にリダイレクト:",
	NOTYOU_LUA_MEMORY_TOOLTIP = "Luaメモリエラーをオリジナルのポップアップの代わりに、通知、または、ダイアログにリダイレクトします",
	NOTYOU_LUA_ERROR = "Luaエラーを次にリダイレクト:",
	NOTYOU_LUA_ERROR_TOOLTIP = "Luaエラーをオリジナルのポップアップの代わりに、通知にリダイレクトします",
	
}

for stringId, stringValue in pairs(strings) do
	ZO_CreateStringId(stringId, stringValue)
	SafeAddVersion(stringId, 1)
end
