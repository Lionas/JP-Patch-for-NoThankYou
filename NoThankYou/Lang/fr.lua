-------------------------------------
-- French localization for No, Thank You --
-------------------------------------

SafeAddString(NOTY_INTERACTION_TAKE,				"Prendre", 1) -- Don't change
SafeAddString(NOTY_INSECT_BUTTERFLY,				"Papillon", 1) -- Don't change
SafeAddString(NOTY_INSECT_TORCHBUG,					"Flammouche", 1) -- Don't change
SafeAddString(NOTY_INSECT_WASP,						"Guêpe", 1) -- Don't change
SafeAddString(NOTY_INSECT_FLESHFLIES,				"Mouches à viande", 1) -- Don't change

SafeAddString(NOTY_RAID_COMPLETE,					" ont", 1) -- Don't change
SafeAddString(NOTY_RAID_OTHERS,						"et <<1>> autres", 1) -- Don't change

SafeAddString(NOTY_GUILD_INV_OPTION_0,				"Jamais", 1)
SafeAddString(NOTY_GUILD_INV_OPTION_1,				"Toujours", 1)
SafeAddString(NOTY_GUILD_INV_OPTION_2,				"Si 5 Guildes", 1)

SafeAddString(NOTY_AVA_MODE_OPTION_0,				"Aucune", 1)
SafeAddString(NOTY_AVA_MODE_OPTION_1,				"Chat", 1)
SafeAddString(NOTY_AVA_MODE_OPTION_2,				"Silencieux", 1)

SafeAddString(NOTY_SOUND_MODE_OPTION_0,			"Jamais", 1)
SafeAddString(NOTY_SOUND_MODE_OPTION_1,			"Hors-combat", 1)
SafeAddString(NOTY_SOUND_MODE_OPTION_2,			"En combat", 1)
SafeAddString(NOTY_SOUND_MODE_OPTION_3,			"Toujours", 1)

SafeAddString(NOTY_GALERTS_OPTION_0,				"Aucune", 1)
SafeAddString(NOTY_GALERTS_OPTION_1,				"Chat", 1)
SafeAddString(NOTY_GALERTS_OPTION_2,				"Silencieux", 1)

SafeAddString(NOTY_RAID_OPTION_0,					"Toujours", 1)
SafeAddString(NOTY_RAID_OPTION_1,					"Amis", 1)
SafeAddString(NOTY_RAID_OPTION_2,					"Membres de guildes", 1)
SafeAddString(NOTY_RAID_OPTION_3,					"Jamais", 1)

SafeAddString(NOTY_MOTD_OPTION_0,					"Aucune", 1)
SafeAddString(NOTY_MOTD_OPTION_1,					"Chat", 1)
SafeAddString(NOTY_MOTD_OPTION_2,					"Silencieux", 1)

SafeAddString(NOTY_GUILDLEAVE_OPTION_0,			"Aucune", 1)
SafeAddString(NOTY_GUILDLEAVE_OPTION_1,			"Toutes les guildes", 1)
SafeAddString(NOTY_GUILDLEAVE_OPTION_2,			"Par guilde", 1)

SafeAddString(NOTY_MOTD_OPTION_0,					"Aucune", 1)
SafeAddString(NOTY_MOTD_OPTION_1,					"Chat", 1)
SafeAddString(NOTY_MOTD_OPTION_2,					"Silencieux", 1)
	
SafeAddString(NOTY_LUAMEM_OPTION_0,					"Notification", 1)
SafeAddString(NOTY_LUAMEM_OPTION_1,					"Fenêtre de mise à jour", 1)
	
SafeAddString(NOTY_LUAERR_OPTION_0,					"Aucune", 1)
SafeAddString(NOTY_LUAERR_OPTION_1,					"Notification", 1)
	
SafeAddString(NOTYOU_LUAERR_MESSAGE,				"Erreur Lua survenue", 1)
SafeAddString(NOTYOU_LUAERR_HEADING,				"Erreur Lua", 1)
SafeAddString(NOTYOU_LUAERR_SHORT,					"Erreur Lua", 1)
	
SafeAddString(NOTYOU_LUAMEM_MESSAGE,				"Les Addons saturent leur mémoire allouée", 1)
SafeAddString(NOTYOU_LUAMEM_HEADING,				"Erreur mémoire Lua", 1)
SafeAddString(NOTYOU_LUAMEM_SHORT,					"Erreur mémoire Lua", 1)

SafeAddString(NOTYOU_LUADIALOG_TITLE,				"Lua atteint sa limite de mémoire", 1)
SafeAddString(NOTYOU_LUADIALOG_TEXT,				"Souhaitez-vous augmenter la limite de mémoire allouée de |cFFFFFF<<1>>|r à |cFFFFFF<<2>>|r MB ? (Cela va reloader votre UI)", 1)

SafeAddString(NOTYOU_AVA_HEADER,						"Messages AvA", 1)
SafeAddString(NOTYOU_AVA,								"Options de bloquage :", 1)
SafeAddString(NOTYOU_AVA_TOOLTIP,					"Sélectionnez le type de redirection à effectuer lors d'une réception d'un message AvA dans le monde PvE :\n|cFFFFFFAucune|r - Pas de modifications\n|cFFFFFFChat|r - Messages redirigés dans le Chat\n|cFFFFFFSilencieux|r - Les messages sont complètement supprimés", 1)

SafeAddString(NOTYOU_FRIENDS_HEADER,				"Message d'activité des amis", 1)
SafeAddString(NOTYOU_FRIENDS_ACTIVITY,				"Bloquer les alertes de connexion / déconnexion", 1)
SafeAddString(NOTYOU_FRIENDS_ACTIVITY_TOOLTIP,	"Supprime les alertes lorsqu'un ami se connecte ou se déconnecte de type:\n- |cFFFFFF[@username] s'est connecté avec [character]|r\n- |cFFFFFF[@username] s'est déconnecté avec [character]|r", 1)

SafeAddString(NOTYOU_TEXT_ALERTS_HEADER,			"Alertes textuelles", 1)
SafeAddString(NOTYOU_MOB_IMMUNE,						"Bloquer \"Cible immunisée\"", 1)
SafeAddString(NOTYOU_MOB_IMMUNE_TOOLTIP,			"Supprimer les alertes fréquemment affichées lors des combats contr les cibles immunisées :\n- |cFFFFFF".. GetErrorString(162) .."|r\n- |cFFFFFF".. GetErrorString(176) .."|r\n- |cFFFFFF".. GetErrorString(177) .."|r\n- |cFFFFFFVous devez posséder une pierre d'âme valide remplie.|r", 1)
SafeAddString(NOTYOU_SCREENSHOT,						"Bloquer \"Capture d'écran sauvegardée\"", 1)
SafeAddString(NOTYOU_SCREENSHOT_TOOLTIP,			"Supprimer le message lors d'ue capture d'écran :\n- |cFFFFFFCapture d'écran sauvegardée : <chemin>|r", 1)
SafeAddString(NOTYOU_ENLIGHTENED,					"Bloquer \"Vous êtes éclairé\"", 1)
SafeAddString(NOTYOU_ENLIGHTENED_TOOLTIP,			"Supprimer le message à la connexion :\n- |cFFFFFFVous êtes éclairé|r", 1)
SafeAddString(NOTYOU_CRAFTRESULT,					"Bloquer les alertes de résultat de craft", 1)
SafeAddString(NOTYOU_CRAFTRESULT_TOOLTIP,			"Supprimer les alertes de création de craft :\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_SUCCESS) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_IMPROVEMENT_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_BLACKSMITH_EXTRACTION_FAILED) .."|r\n- |cFFFFFF" .. GetString(SI_SMITHING_DECONSTRUCTION_LEVEL_PENALTY) .. "|r\n- |cFFFFFF" .. GetString(SI_ALCHEMY_NO_YIELD) .. "|r\n- |cFFFFFF" .. GetString(SI_ENCHANT_NO_YIELD) .. "|r", 1)
SafeAddString(NOTYOU_REPAIR,							"Bloquer les alertes de réparation", 1)
SafeAddString(NOTYOU_REPAIR_TOOLTIP,				"Supprimer les alertes de réparation :\n- |cFFFFFF<objet> réparé.|r", 1)
SafeAddString(NOTYOU_ALERT_THROTTLING,				"Délai entre deux alertes identiques", 1)
SafeAddString(NOTYOU_ALERT_THROTTLING_TOOLTIP,	"Fréquence minimum d'alertes identiques en secondes", 1)

SafeAddString(NOTYOU_SOUND_HEADER,					"Alertes sonores", 1)
SafeAddString(NOTYOU_ULTISOUND,						"Couper le son \"Ultime prêt\" :", 1)
SafeAddString(NOTYOU_ULTISOUND_TOOLTIP,			"Sélectionnez quand couper le son \"Ultime prêt\".", 1)

SafeAddString(NOTYOU_MARKET_HEADER,					"Publicités de la boutique", 1)
SafeAddString(NOTYOU_MARKET_ADS,						"Masquer les publicités de la Boutique", 1)
SafeAddString(NOTYOU_MARKET_ADS_TOOLTIP,			"Masquer les publicités de la boutique à couronne à la connexion.", 1)

SafeAddString(NOTYOU_MAIL_HEADER,					"Confirmations pour les mails", 1)
SafeAddString(NOTYOU_MAIL,								"Supprimer la confirmation \"Supprimer le mail\"", 1)
SafeAddString(NOTYOU_MAIL_TOOLTIP,					"Supprimer la fenêtre de confirmation de suppression de mail sans pièce jointe.", 1)

SafeAddString(NOTYOU_FENCE_HEADER,					"Confirmations pour le vol", 1)
SafeAddString(NOTYOU_FENCE,							"Supprimer \"Rachat impossible des objets volés\"", 1)
SafeAddString(NOTYOU_FENCE_TOOLTIP,					"Supprime la fenêtre de confirmation lors de la vente d'un objet volé rare.", 1)

SafeAddString(NOTYOU_GROUPS_HEADER,					"Confirmations pour les groupes", 1)
SafeAddString(NOTYOU_GROUPS_DISBAND,				"Supprimer \"Disperser le groupe\"", 1)
SafeAddString(NOTYOU_GROUPS_DISBAND_TOOLTIP,		"Supprime la fenêtre de confirmation de dispersion du groupe.", 1)
SafeAddString(NOTYOU_GROUPS_LARGE,					"Supprimer \"Conversion en groupe large\"", 1)
SafeAddString(NOTYOU_GROUPS_LARGE_TOOLTIP,		"Supprime la fenêtre de confirmation lors de la création d'un groupe élargi.", 1)

SafeAddString(NOTYOU_CRAFT_HEADER,					"Confirmations pour l'artisanat", 1)
SafeAddString(NOTYOU_CRAFT,							"Supprime le message \"Tenter l'amélioration ...\"", 1)
SafeAddString(NOTYOU_CRAFT_TOOLTIP,					"Supprime la fenêtre de confirmation lorsque vous tentez d'améliorer la qualité d'un objet.", 1)

SafeAddString(NOTYOU_CHAMELEON_HEADER,				"Pierre caméléon à Couronnes", 1)
SafeAddString(NOTYOU_CHAMELEON,						"Masquer la case Pierre caméléon à Couronnes", 1)
SafeAddString(NOTYOU_CHAMELEON_TOOLTIP,			"Masque la case Pierre caméléon à Couronne lorsque vous n'en avez pas", 1)

SafeAddString(NOTYOU_CHAT_HEADER,					"Icônes du Chat", 1)
SafeAddString(NOTYOU_CHAT,								"Faire disparaitre l'icône des amis connectés", 1)
SafeAddString(NOTYOU_CHAT_TOOLTIP,					"Activer la disparition de l'icône des amis connectés en haut de la fenêtre de Chat.", 1)

SafeAddString(NOTYOU_RETICLE_HEADER,				"Cible", 1)
SafeAddString(NOTYOU_RETICLE_TAKE,					"Désactiver l'interaction avec les insectes", 1)
SafeAddString(NOTYOU_RETICLE_TAKE_TOOLTIP,		"Désactive l'action \"Prendre\" pour collecter les insectes.", 1)

SafeAddString(NOTYOU_GUILDS_HEADER,					"Invitations de gulde", 1)
SafeAddString(NOTYOU_GUILDS,							"Ignorer les invitations de guilde", 1)
SafeAddString(NOTYOU_GUILDS_TOOLTIP,				"Ignorer les invitations et les notifications d'invitation à une guilde", 1)

SafeAddString(NOTYOU_GROSTER_HEADER,				"Alertes des Rosters de guildes", 1)
SafeAddString(NOTYOU_GROSTER_HEADER_TOOLTIP,		"Sélectionnez comment gérer les alertes de roster de guilde", 1)
SafeAddString(NOTYOU_GROSTER,							"Options de redirection :", 1)
SafeAddString(NOTYOU_GROSTER_TOOLTIP,				"Sélectionnez comment gérer les alertes de roster de guilde :\n|cFFFFFFAucune|r - Pas de changement\n|cFFFFFFChat|r - Les alertes sont redirigées dans le Chat\n|cFFFFFFSilencieux|r - Les alertes sont complètement supprimées", 1)

SafeAddString(NOTYOU_RAIDSCORE_HEADER,				"Notification de score de Raid", 1)
SafeAddString(NOTYOU_RAIDSCORE_HEADER_TOOLTIP,	"Sélectionner comment gérer les notifications de score de Raid", 1)
SafeAddString(NOTYOU_RAIDSCORE_ONLYFOR,			"Afficher uniquement pour :", 1)
SafeAddString(NOTYOU_RAIDSCORE_ONLYFOR_TOOLTIP,	"Sélectionnez comment afficher les notifications de score de Raid :\n|cFFFFFFToujours|r - Pas de changement\n|cFFFFFFAmis|r - Seulement lorsqu'un raid a été complété par un ami\n|cFFFFFFMembres de guildes|r - Seulement lorsqu'un raid a été complété par un membre des guildes définies ci-dessous\n|cFFFFFFJamais|r - Bloquer toutes les notifications de score de Raid", 1)
SafeAddString(NOTYOU_RAIDSCORE_REDIRECT,			"Rediriger les notifications dans le Chat", 1)

SafeAddString(NOTYOU_MOTD_HEADER,					"Notifications de Message du Jour", 1)
SafeAddString(NOTYOU_MOTD_HEADER_TOOLTIP,			"Sélectionnez comment gérer les notifications de Message du Jour", 1)
SafeAddString(NOTYOU_MOTD_BLOCK,						"Options de redirection :", 1)
SafeAddString(NOTYOU_MOTD_BLOCK_TOOLTIP,			"Sélectionnez comment gérer les notifications de Message du Jour :\n|cFFFFFFAucune|r - Pas de changement\n|cFFFFFFChat|r - Les notifications sont redirigées dans le Chat\n|cFFFFFFSilencieux|r - Les notifications sont complètement supprimées", 1)

SafeAddString(NOTYOU_GUILDLEAVE_HEADER,			"Désactiver \"Quitter la Guilde\"", 1)
SafeAddString(NOTYOU_GUILDLEAVE_HEADER_TOOLTIP,	"Sélectionnez comment l'option \"Quitter la Guilde\" doit être gérée dans le panneau de guilde", 1)
SafeAddString(NOTYOU_GUILDLEAVE_BLOCK,				"Désactivation pour :", 1)
SafeAddString(NOTYOU_GUILDLEAVE_BLOCK_TOOLTIP,	"Sélectionnez comment l'option \"Quitter la Guilde\" doit être gérée:\n|cFFFFFFAucune|r - Pas de changement\n|cFFFFFFToutes les guildes|r - Désactivé pour toutes les guildes\n|cFFFFFFPar guilde|r - Sélectionnez quelle guilde doit avoir cette commande désactivée", 1)

SafeAddString(NOTYOU_CAMERA_HEADER,					"Caméra & Interaction", 1)
SafeAddString(NOTYOU_CAMERA_INTERRUPT,				"Ne pas interrompre les interactions", 1)
SafeAddString(NOTYOU_CAMERA_INTERRUPT_TOOLTIP,	"Ne pas interrompre les interactions (collecte, pêche, etc) lorsque vous entrez dans un menu", 1)
SafeAddString(NOTYOU_CAMERA_ROTATE,					"Ne pas tourner la caméra", 1)
SafeAddString(NOTYOU_CAMERA_ROTATE_TOOLTIP,		"Ne pas tourner la caméra lorsque vous entrez dans un menu", 1)

SafeAddString(NOTYOU_AUTOLOOTITEMS_HEADER,		"Looter les conteneurs", 1)
SafeAddString(NOTYOU_AUTOLOOTITEMS,					"Looter automatiquement les conteneurs", 1)
SafeAddString(NOTYOU_AUTOLOOTITEMS_TOOLTIP,		"Looter automatiquement les conteneurs si l'option de butin automatique est activé. Les objets volés provenant de conteneurs seront lootés automatiquement si l'option associée est également activée.", 1)

SafeAddString(NOTYOU_NOLOREREADER,					"Ne pas lire les livres découverts", 1)
SafeAddString(NOTYOU_NOLOREREADER_TOOLTIP,		"N'affichera pas le livre que vous venez de découvrir, excepté depuis la librairie", 1)

SafeAddString(NOTYOU_LUA_HEADER,						"Erreurs Lua", 1)
SafeAddString(NOTYOU_LUA_MEMORY,						"Rediriger les erreurs de mémoire Lua vers :", 1)
SafeAddString(NOTYOU_LUA_MEMORY_TOOLTIP,			"Rediriger les erreurs de mémoire Lua vers une fenêtre permettant d'augmenter le paramètre plutôt que d'afficher la fenêtre originale", 1)
SafeAddString(NOTYOU_LUA_ERROR,						"Rediriger les erreurs Lua vers :", 1)
SafeAddString(NOTYOU_LUA_ERROR_TOOLTIP,			"Rediriger les erreurs Lua vers les notifications plutôt que d'afficher la fenêtre originale", 1)