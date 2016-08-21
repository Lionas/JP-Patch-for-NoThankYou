-------------------------------------------------------------------------------
--
-- Copyright (c) 2014, 2015 Ales Machat (Garkin)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.
--
-------------------------------------------------------------------------------
--
-- DISCLAIMER:
--
-- This Add-on is not created by, affiliated with or sponsored by ZeniMax
-- Media Inc. or its affiliates. The Elder ScrollsÂ® and related logos are
-- registered trademarks or trademarks of ZeniMax Media Inc. in the United
-- States and/or other countries. All rights reserved.
--
-- You can read the full terms at:
-- https://account.elderscrollsonline.com/add-on-terms
--
-------------------------------------------------------------------------------

local ADDON_NAME = "NoThankYou"
local ADDON_VERSION = "3"
local SV
local defaults = {
	ava = 1,
	friends = false,
	boss = false,
	screenshot = false,
	enlightened = false,
	craftingResults = false,
	repair = false,
	alertTextExpiryDelay = 3, --seconds, 3 is default value used in AlertText
	emptyMail = true,
	guildAlerts = 0,
	guildAlertsGuilds = {},
	raid = 0,
	raidToChat = true,
	raidGuilds = {},
	motd = 0,
	motdGuilds = {},
	nonstopHarvest = false,
	noCameraSpin = false,
	fenceDialog = false,
	ultimateSound = 0,
	disbandDialog = false,
	largeGroupDialog = false,
	marketAnnouncement = false,
	improveDialog = false,
	guildInvites = 0,
	luaMemory = 1,
	luaError = 1,
	dontReadBooks = false,
	noUniversalStones = false,
	noGuildLeave = 0,
	guildLeave = {},
	autoLootItems = false,
}
for i = 1, MAX_GUILDS do
	defaults.guildAlertsGuilds[i] = true
	defaults.raidGuilds[i] = true
	defaults.motdGuilds[i] = true
end

local recentMessages
local isQueued = false
local storedMessages = {}

local function SafePrint(message)
	if IsPlayerActivated() then
		CHAT_SYSTEM:AddMessage(message)
	else
		table.insert(storedMessages, message)
		if not isQueued then
			isQueued = true
			EVENT_MANAGER:RegisterForEvent("NOTY_Print", EVENT_PLAYER_ACTIVATED,
				function(event)
					EVENT_MANAGER:UnregisterForEvent("NOTY_Print", event)
					for i, message in ipairs(storedMessages) do
						CHAT_SYSTEM:AddMessage(message)
					end
					ZO_ClearNumericallyIndexedTable(storedMessages)
					isQueued = false
				end)
		end
	end
end

--AvA messages
local function HookAvAMessages()
	local handlers = ZO_CenterScreenAnnounce_GetHandlers()
	local avaEvents = {
		EVENT_ARTIFACT_CONTROL_STATE,
		EVENT_KEEP_GATE_STATE_CHANGED,
		EVENT_CORONATE_EMPEROR_NOTIFICATION,
		EVENT_DEPOSE_EMPEROR_NOTIFICATION,
		EVENT_IMPERIAL_CITY_ACCESS_GAINED_NOTIFICATION,
		EVENT_IMPERIAL_CITY_ACCESS_LOST_NOTIFICATION,
	}

	local function HookAvAEventHandler(event)
		local original = handlers[event]
		handlers[event] = function(...)
			if IsPlayerInAvAWorld() then
				return original(...)
			else
				if SV.ava == 1 then
					local _,_,msg = original(...)
					SafePrint(msg)
				elseif SV.ava == 2 then
					return
				else
					return original(...)
				end
			end
		end
	end

	for i = 1, #avaEvents do
		HookAvAEventHandler(avaEvents[i])
	end


	--filter centerscreen announcements which are already in queue
	if not IsPlayerInAvAWorld() then
		local messageQueue = CENTER_SCREEN_ANNOUNCE.m_displayQueue
		for i = #messageQueue, 1, -1 do
			for eventIndex = 1, #avaEvents do
				local priority = CENTER_SCREEN_ANNOUNCE:GetPriority(avaEvents[eventIndex])
				if messageQueue[i].priority == priority then
					if SV.ava == 1 then
						SafePrint(messageQueue[i][2])
						table.remove(messageQueue, i)
						break
					elseif SV.ava == 2 then
						table.remove(messageQueue, i)
						break
					end
				end
			end
		end
	end

end

local function HookFriendsMessages()
	local handlers = ZO_ChatSystem_GetEventHandlers()

	local function EventHook()
		return SV.friends
	end
	ZO_PreHook(handlers, EVENT_FRIEND_PLAYER_STATUS_CHANGED, EventHook)
end

local function BossAlertTextsHook()
	local handlers = ZO_AlertText_GetHandlers()

	local abilityErrorIds = {
		[162] = true, --"Flying creatures are immune to snares."
		[176] = true, --"This target is immune to bleeding effects."
		[177] = true, --"This target is too powerful for that effect."
	}
	local function AbilityEventHook(errorStringId)
		if SV.boss then
			return abilityErrorIds[errorStringId]
		end
	end
	ZO_PreHook(handlers, EVENT_ABILITY_REQUIREMENTS_FAIL, AbilityEventHook)

	local actionResults = {
		[ACTION_RESULT_MISSING_EMPTY_SOUL_GEM] = true, -- "You must have a valid empty soul gem."
	}
	local function CombatEventHook(result, isError, ...)
		if isError and SV.boss then
			return actionResults[result]
		end
	end
	ZO_PreHook(handlers, EVENT_COMBAT_EVENT, CombatEventHook)
end

local function NoLootWindowOnItems()
	
	-- When LOOT_SETTING_AUTO_LOOT is on, the C++ LootAll() is called, all is handled by C++ side, and EVENT_CLOSE_LOOT is sent.
	-- All we can do is to use the LootAll() Lua function

	local function LootAllItems()
	
		local name, targetType, actionName, isOwned = GetLootTargetInfo()
		if name ~= "" then
			if targetType == INTERACT_TARGET_TYPE_ITEM then
				name = zo_strformat(SI_TOOLTIP_ITEM_NAME, name)
			elseif targetType == INTERACT_TARGET_TYPE_OBJECT then
				name = zo_strformat(SI_LOOT_OBJECT_NAME, name)
			elseif targetType == INTERACT_TARGET_TYPE_FIXTURE then
				name = zo_strformat(SI_TOOLTIP_FIXTURE_INSTANCE, name)
			end
		end
		
		if SV.autoLootItems then
			if not (targetType == INTERACT_TARGET_TYPE_ITEM and (isOwned == false and GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT) == "1") or (isOwned and GetSetting(SETTING_TYPE_LOOT, LOOT_SETTING_AUTO_LOOT_STOLEN) == "1")) then
				SYSTEMS:GetObject("loot"):UpdateLootWindow(name, actionName, isOwned)
			else
				LOOT_SHARED:LootAllItems()
			end
		else
			SYSTEMS:GetObject("loot"):UpdateLootWindow(name, actionName, isOwned)
		end
		
	end
	
	EVENT_MANAGER:UnregisterForEvent("LOOT_SHARED", EVENT_LOOT_UPDATED)
	EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_LOOT_UPDATED, LootAllItems)
	
end

local function ScreenshotAlertHook()
	local handlers = ZO_AlertText_GetHandlers()

	local function EventHook()
		return SV.screenshot
	end
	ZO_PreHook(handlers, EVENT_SCREENSHOT_SAVED, EventHook)
end

local function EnlightenedAlertHook()
	local handlers = ZO_CenterScreenAnnounce_GetHandlers()

	local function EventHook()
		return SV.enlightened
	end
	ZO_PreHook(handlers, EVENT_PLAYER_ACTIVATED, EventHook)
end

local function CraftingResultAlertsHook()
	local blockedMessages = {
		[SI_SMITHING_BLACKSMITH_EXTRACTION_FAILED] = true,
		[SI_SMITHING_CLOTHIER_EXTRACTION_FAILED] = true,
		[SI_SMITHING_WOODWORKING_EXTRACTION_FAILED] = true,
		[SI_SMITHING_DECONSTRUCTION_LEVEL_PENALTY] = true,
		[SI_SMITHING_IMPROVEMENT_SUCCESS] = true,
		[SI_SMITHING_IMPROVEMENT_FAILED] = true,
		[SI_ALCHEMY_NO_YIELD] = true,
		[SI_ENCHANT_NO_YIELD] = true,
	}

	local function ZO_AlertNoSuppression_Hook(category, soundId, message)
		if SV.craftingResults then
			return blockedMessages[message]
		end
	end

	ZO_PreHook("ZO_AlertNoSuppression", ZO_AlertNoSuppression_Hook)
end

local function RepairAlertsHook()
	if ZO_GamepadStoreManager and ZO_GamepadStoreManager.RepairMessageBox then
		local function RepairMessageBox_Hook(...)
			return SV.repair
		end

		ZO_PreHook(ZO_GamepadStoreManager, "RepairMessageBox", RepairMessageBox_Hook)
	end
end

local function AlertTextThrottling()
	recentMessages = ZO_RecentMessages:New(SV.alertTextExpiryDelay * 1000)

	local function ZO_Alert_Hook(category, soundId, message)
		if message and message ~= "" then
			return not recentMessages:ShouldDisplayMessage(message)
		end
		return true
	end
	ZO_PreHook("ZO_Alert", ZO_Alert_Hook)

	local function ZO_SoundAlert_Hook(category, soundId)
		if soundId and soundId ~= "" then
			return not recentMessages:ShouldDisplayMessage(soundId)
		end
		return true
	end
	ZO_PreHook("ZO_SoundAlert", ZO_SoundAlert_Hook)
end

local function DeleteEmptyMailHook()
	local function Delete_Hook(self)
		if SV.emptyMail and self.mailId then
			if self:IsMailDeletable() then
				self:ConfirmDelete(self.mailId)
				return true
			end
		end
	end
	ZO_PreHook(MAIL_INBOX, "Delete", Delete_Hook)
end

local function NoUniversalStones()

	local function DisableUniversalCheckbox(_, craftSkill)
		if craftSkill ==  CRAFTING_TYPE_BLACKSMITHING
		or craftSkill ==  CRAFTING_TYPE_CLOTHIER
		or craftSkill ==  CRAFTING_TYPE_WOODWORKING then
			if GetCurrentSmithingStyleItemCount(ZO_ADJUSTED_UNIVERSAL_STYLE_ITEM_INDEX) == 0 then
				ZO_SmithingTopLevelCreationPanelStyleListUniversalStyleItem:SetHidden(true)
			else
				ZO_SmithingTopLevelCreationPanelStyleListUniversalStyleItem:SetHidden(false)
			end
		end
	end
	
	if SV.noUniversalStones then
		EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_CRAFTING_STATION_INTERACT, DisableUniversalCheckbox)
	else
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_CRAFTING_STATION_INTERACT)
		ZO_SmithingTopLevelCreationPanelStyleListUniversalStyleItem:SetHidden(false)
	end
	
end

local function NoGuildLeave()

	local function NoGuildLeave_Hook(playerGuildId)
		if SV.noGuildLeave == 1 then
			return true
		elseif SV.noGuildLeave == 2 and SV.guildLeave[playerGuildId] then
			return true
		end
		return false
	end
	
	ZO_PreHook("ZO_ShowLeaveGuildDialog", NoGuildLeave_Hook)
	
end

local function GuildRosterAlertsHook()
	local function GetGuildIndex(guildId)
		for index = 1, GetNumGuilds() do
			if GetGuildId(index) == guildId then
				return index
			end
		end
		return 0
	end

	local function OnGuildMemberAdded_Hook(self, guildId, displayName)
		if SV.guildAlerts == 1 then
			local index = GetGuildIndex(guildId)
			if SV.guildAlertsGuilds[index] then
				self:RefreshData()
				if DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE) then
					local data = self:FindDataByDisplayName(displayName)
					if data then
						local _, rawCharacterName = GetGuildMemberCharacterInfo(guildId, data.index)
						SafePrint(zo_strformat(SI_GUILD_ROSTER_ADDED, rawCharacterName, self.guildName))
					end
				end
				return true
			end
		elseif SV.guildAlerts == 2 then
			local index = GetGuildIndex(guildId)
			if SV.guildAlertsGuilds[index] then
				self:RefreshData()
				return true
			end
		end
	end
	ZO_PreHook(ZO_GuildRosterManager or GUILD_ROSTER, "OnGuildMemberAdded", OnGuildMemberAdded_Hook)

	local function OnGuildMemberRemoved_Hook(self, guildId, rawCharacterName)
		if SV.guildAlerts == 1 then
			local index = GetGuildIndex(guildId)
			if SV.guildAlertsGuilds[index] then
				if DoesPlayerHaveGuildPermission(guildId, GUILD_PERMISSION_INVITE) then
					SafePrint(zo_strformat(SI_GUILD_ROSTER_REMOVED, rawCharacterName, self.guildName))
				end
				self:RefreshData()
				return true
			end
		elseif SV.guildAlerts == 2 then
			local index = GetGuildIndex(guildId)
			if SV.guildAlertsGuilds[index] then
				self:RefreshData()
				return true
			end
		end
	end
	ZO_PreHook(ZO_GuildRosterManager or GUILD_ROSTER, "OnGuildMemberRemoved", OnGuildMemberRemoved_Hook)
end

--raid notifications
local function HookRaidNotifications()
	local function BuildNotificationList_Hook(self)
		
		local function BuildMessageAndRemoveNotification(contacts, message, notificationId)
			
			local membersListShorten = ""
			local nbContacts = #contacts
			if nbContacts > 4 then
				local shortOthers = zo_strformat(GetString(NOTY_RAID_OTHERS), ZO_SELECTED_TEXT:Colorize((nbContacts - 2)))
				membersListShorten = zo_strformat(" (<<1>>, <<2>> <<3>>)", ZO_SELECTED_TEXT:Colorize(contacts[1]), ZO_SELECTED_TEXT:Colorize(contacts[2]), shortOthers)
			else
				local myContacts = ""
				for _, contactName in ipairs(contacts) do
					myContacts = myContacts .. ZO_SELECTED_TEXT:Colorize(contactName) .. ", "
				end
				membersListShorten = zo_strformat(" (<<1>>)", myContacts:sub(1, -3))
			end
			message = string.gsub(message, GetString(NOTY_RAID_COMPLETE), zo_strformat("<<1>><<2>> ",  membersListShorten, GetString(NOTY_RAID_COMPLETE)))
			SafePrint(message)
			RemoveRaidScoreNotification(notificationId)
	
		end
	
		if SV.raid == 0 and SV.raidToChat then
			for index = 1, GetNumRaidScoreNotifications() do
				local notificationId = GetRaidScoreNotificationId(index)
				local numRaidMembers = GetNumRaidScoreNotificationMembers(notificationId)
				local hasGuildMember = false
				local hasFriend = false
				local contacts = {}

				for raidMemberIndex = 1, numRaidMembers do
					local displayName, _, isFriend, isGuildMember = GetRaidScoreNotificationMemberInfo(notificationId, raidMemberIndex)
					if isFriend or isGuildMember then
						table.insert(contacts, displayName)
					end
					hasFriend = hasFriend or isFriend
					hasGuildMember = hasGuildMember or isGuildMember
				end

				if hasFriend or hasGuildMember then
					local raidId, raidScore = GetRaidScoreNotificationInfo(notificationId)
					local raidName = GetRaidName(raidId)
					local message = self:CreateMessage(raidName, raidScore, hasFriend, hasGuildMember)
					BuildMessageAndRemoveNotification(contacts, message, notificationId)
				end
				
			end
		elseif SV.raid == 1 then
			for index = 1, GetNumRaidScoreNotifications() do
				local notificationId = GetRaidScoreNotificationId(index)
				local numRaidMembers = GetNumRaidScoreNotificationMembers(notificationId)
				local hasGuildMember = false
				local showNotification = false
				local contacts = {}
				
				for raidMemberIndex = 1, numRaidMembers do
					local displayName, _, isFriend, isGuildMember = GetRaidScoreNotificationMemberInfo(notificationId, raidMemberIndex)
					showNotification = showNotification or isFriend
					if isFriend then
						table.insert(contacts, displayName)
					end
					hasGuildMember = hasGuildMember or isGuildMember
				end

				if not showNotification then
					RemoveRaidScoreNotification(notificationId)
				elseif SV.raidToChat then
					local raidId, raidScore = GetRaidScoreNotificationInfo(notificationId)
					local raidName = GetRaidName(raidId)
					local message = self:CreateMessage(raidName, raidScore, showNotification, hasGuildMember)
					BuildMessageAndRemoveNotification(contacts, message, notificationId)
				end
			end
		elseif SV.raid == 2 then
			for index = 1, GetNumRaidScoreNotifications() do
				local notificationId = GetRaidScoreNotificationId(index)
				local numRaidMembers = GetNumRaidScoreNotificationMembers(notificationId)
				local showNotification = false
				local hasFriend = false
				local guildMembers = {}
				local contacts = {}
				
				for raidMemberIndex = 1, numRaidMembers do
					local displayName, _, isFriend, isGuildMember = GetRaidScoreNotificationMemberInfo(notificationId, raidMemberIndex)
					hasFriend = hasFriend or isFriend
					if isGuildMember then
						table.insert(guildMembers, displayName)
					end
				end

				for _, displayName in ipairs(guildMembers) do
					for guildIndex = 1, GetNumGuilds() do
						if SV.raidGuilds[guildIndex] then
							local guildId = GetGuildId(guildIndex)
							for guildMemberIndex = 1, GetNumGuildMembers(guildId) do
								local displayName = GetGuildMemberInfo(guildId, guildMemberIndex)
								if displayName == displayName then
									showNotification = true
									table.insert(contacts, displayName)
								end
							end
						end
					end
				end

				if not showNotification then
					RemoveRaidScoreNotification(notificationId)
				elseif SV.raidToChat then
					local raidId, raidScore = GetRaidScoreNotificationInfo(notificationId)
					local raidName = GetRaidName(raidId)
					local message = self:CreateMessage(raidName, raidScore, hasFriend, #guildMembers > 0)
					BuildMessageAndRemoveNotification(contacts, message, notificationId)
				end
			end
		elseif SV.raid == 3 then
			for index = 1, GetNumRaidScoreNotifications() do
				local notificationId = GetRaidScoreNotificationId(index)
				RemoveRaidScoreNotification(notificationId)
			end
		end
	end

	ZO_PreHook(ZO_LeaderboardRaidProvider, "BuildNotificationList", BuildNotificationList_Hook)
end

--Guild MotD notifications
local function HookMotDNotifications()
	local function BuildNotificationList_Hook(self)
		if self.sv then
			if SV.motd == 1 then
				ZO_ClearNumericallyIndexedTable(self.list)
				for i = 1, GetNumGuilds() do
					local guildId = GetGuildId(i)
					local guildName = GetGuildName(guildId)
					local savedMotD = self.sv[guildName]
					local currentMotD = GetGuildMotD(guildId)
					if savedMotD ~= currentMotD then
						local guildAlliance = GetGuildAlliance(guildId)
						local allianceIcon = zo_iconFormat(GetAllianceBannerIcon(guildAlliance), 24, 24)
						local message = zo_strformat("<<X:1>> |cFFFFFF<<2>>|r\n<<3>>", allianceIcon, guildName, currentMotD)
						SafePrint(message)
					end
					self.sv[guildName] = currentMotD
				end
				return true
			elseif SV.motd == 2 then
				ZO_ClearNumericallyIndexedTable(self.list)
				for i = 1, GetNumGuilds() do
					local guildId = GetGuildId(i)
					local guildName = GetGuildName(guildId)
					self.sv[guildName] = GetGuildMotD(guildId)
				end
				return true
			end
		end
	end
	ZO_PreHook(ZO_GuildMotDProvider, "BuildNotificationList", BuildNotificationList_Hook)
end


--Reticle Hook
local function HookReticleTake()
	local function DisableReticleTake_Hook(interactionPossible)
		if interactionPossible then
			if SV.reticleTake then
				local action, interactableName = GetGameCameraInteractableActionInfo()
				if action and interactableName then
					if (action == GetString(NOTY_INTERACTION_TAKE)) then
						if (interactableName == GetString(NOTY_INSECT_BUTTERFLY)
						or interactableName == GetString(NOTY_INSECT_TORCHBUG)
						or interactableName == GetString(NOTY_INSECT_WASP)
						or interactableName == GetString(NOTY_INSECT_FLESHFLIES))
						then
							return true
						end
					end
				end
			end
		end
		return false
	end
	ZO_PreHook(RETICLE, "TryHandlingInteraction", DisableReticleTake_Hook)
end

--Guild invite notifications
local function HookGuildInvitesNotifications()
	local function BuildNotificationList_Hook(self)
		ZO_ClearNumericallyIndexedTable(self.list)
		if SV.guildInvites == 0 or (SV.guildInvites == 2 and GetNumGuilds() < MAX_GUILDS) then
			for i = 1, GetNumGuildInvites() do
				local guildId, guildName, guildAlliance, inviterDisplayName, note = GetGuildInviteInfo(i)
				local secsSinceRequest = 0
				local formattedInviterName = ZO_FormatUserFacingDisplayName(inviterDisplayName)
				local message = self:CreateMessage(guildAlliance, guildName, formattedInviterName)
				self.list[i] =  {
					dataType = NOTIFICATIONS_REQUEST_DATA,
					guildId = guildId,
					guildAlliance = guildAlliance,
					guildName = guildName,
					displayName = inviterDisplayName,
					notificationType = NOTIFICATION_TYPE_GUILD,
					secsSinceRequest = ZO_NormalizeSecondsSince(secsSinceRequest),
					note = note,
					message = message,
					shortDisplayText = formattedInviterName,
					controlsOwnSounds = true,
				}
			end
		end
		return true
	end
	ZO_PreHook(ZO_GuildInviteProvider, "BuildNotificationList", BuildNotificationList_Hook)
end

local function HookPlayerToPlayerGuildInvite()

	PLAYER_TO_PLAYER.control:UnregisterForEvent(EVENT_GUILD_INVITE_ADDED)
	PLAYER_TO_PLAYER.control:RegisterForEvent(EVENT_GUILD_INVITE_ADDED, function (eventCode, guildId, guildName, guildAlliance, inviterName)
		
		if SV.guildInvites == 0 or (SV.guildInvites == 2 and GetNumGuilds() < MAX_GUILDS) then
		
			local allianceIconSize = 24
			if IsInGamepadPreferredMode() then
				allianceIconSize = 36
			end

			local formattedInviterName = ZO_FormatUserFacingDisplayName(inviterName)
			local guildNameAlliance = zo_iconTextFormat(GetAllianceBannerIcon(guildAlliance), allianceIconSize, allianceIconSize, ZO_SELECTED_TEXT:Colorize(guildName))
			local data = PLAYER_TO_PLAYER:AddPromptToIncomingQueue(INTERACT_TYPE_GUILD_INVITE, nil, formattedInviterName, zo_strformat(SI_PLAYER_TO_PLAYER_INCOMING_GUILD_REQUEST, ZO_SELECTED_TEXT:Colorize(formattedInviterName), guildNameAlliance),
				function()
					AcceptGuildInvite(guildId)
				end,
				function()
					RejectGuildInvite(guildId)
				end,
				function()
					PLAYER_TO_PLAYER:RemoveFromIncomingQueue(INTERACT_TYPE_GUILD_INVITE, formattedInviterName)
				end)
			data.guildId = guildId
		end
	end)
	
end

-- Aya: Don't interrupt on mailScenes anymore due to RequestOpenMailbox() - sec issue I guess
local function DontInterruptHarvesting()
	local function Show_Hook(self)
		if SV.nonstopHarvest then
			EndPendingInteraction()
			self:OnShown()
			return true
		end
	end
	ZO_PreHook(END_IN_WORLD_INTERACTIONS_FRAGMENT, "Show", Show_Hook)
end

local function DontReadBooks()

	local function OnShowBook(eventCode, title, body, medium, showTitle)
		local willShow = LORE_READER:Show(title, body, medium, showTitle)
		if willShow then
			PlaySound(LORE_READER.OpenSound)
		else
			EndInteraction(INTERACTION_BOOK)
		end
	end

	local function OnDontShowBook()
		EndInteraction(INTERACTION_BOOK)
	end

	if SV.dontReadBooks then
		LORE_READER.control:UnregisterForEvent(EVENT_SHOW_BOOK)
		LORE_READER.control:RegisterForEvent(EVENT_SHOW_BOOK, OnDontShowBook)
	else
		LORE_READER.control:UnregisterForEvent(EVENT_SHOW_BOOK)
		LORE_READER.control:RegisterForEvent(EVENT_SHOW_BOOK, OnShowBook)
	end
	
end


local scenes = {}
local function DontRotateGameCamera()

	local emotesFragments = {
		FRAME_PLAYER_FRAGMENT,
		FRAME_EMOTE_FRAGMENT_INVENTORY,
		FRAME_EMOTE_FRAGMENT_SKILLS,
		FRAME_EMOTE_FRAGMENT_JOURNAL,
		FRAME_EMOTE_FRAGMENT_MAP,
		FRAME_EMOTE_FRAGMENT_SOCIAL,
		FRAME_EMOTE_FRAGMENT_AVA,
		FRAME_EMOTE_FRAGMENT_SYSTEM,
		FRAME_EMOTE_FRAGMENT_LOOT,
		FRAME_EMOTE_FRAGMENT_CHAMPION,
	}
	
	if SV.noCameraSpin then
		for name, scene in pairs(SCENE_MANAGER.scenes) do
			if not name:find("market") then
				local sceneToSave = true
				for _, fragmentToRemove in ipairs(emotesFragments) do
					if scene:HasFragment(fragmentToRemove) then
						scene:RemoveFragment(fragmentToRemove)
						if sceneToSave then
							sceneToSave = false
							scenes[name] = scene
							scenes[name].toRestore = {}
						end
						table.insert(scenes[name].toRestore, fragmentToRemove)
					end
				end
			end
		end
	else
		for name, scene in pairs(scenes) do
			if scene.toRestore then
				for index, fragment in ipairs(scene.toRestore) do
					scene:AddFragment(fragment)
				end
			end
		end
	end
	
end

local function HookFenceDialog()
	local function ShowDialog_Hook(name, data)
		if name == "CANT_BUYBACK_FROM_FENCE" then
			if SV.fenceDialog and GetItemType(data.bag, data.slot) == ITEMTYPE_TREASURE then
				SellInventoryItem(data.bag, data.slot, data.stackCount)
				return true
			end
		end
	end
	ZO_PreHook("ZO_Dialogs_ShowDialog", ShowDialog_Hook)
end

local function HookPlaySound()
	local function PlaySound_Hook(soundId)
		if (soundId == SOUNDS.ABILITY_ULTIMATE_READY) then
			if SV.ultimateSound == 1 then
				return (not IsUnitInCombat("player"))
			elseif SV.ultimateSound == 2 then
				return IsUnitInCombat("player")
			elseif SV.ultimateSound == 3 then
				return true
			end
		end
	end
	ZO_PreHook("PlaySound", PlaySound_Hook)
end

local function HookDisbandDialog()
	local function ShowDialog_Hook(name, data)
		if name == "GROUP_DISBAND_DIALOG" then
			if SV.disbandDialog then
				GroupDisband()
				return true
			end
		end
	end
	ZO_PreHook("ZO_Dialogs_ShowDialog", ShowDialog_Hook)
end

local function HookLargeGroupDialog()
	local function ShowDialog_Hook(name, data)
		if name == "LARGE_GROUP_INVITE_WARNING" then
			if SV.largeGroupDialog then
					 local characterOrDisplayName = data
					 GroupInviteByName(characterOrDisplayName)
					 ZO_Menu_SetLastCommandWasFromMenu(true)
					 ZO_Alert(ALERT, nil, zo_strformat(GetString("SI_GROUPINVITERESPONSE", GROUP_INVITE_RESPONSE_INVITED), ZO_FormatUserFacingDisplayName(characterOrDisplayName)))
				return true
			end
		end
	end
	ZO_PreHook("ZO_Dialogs_ShowDialog", ShowDialog_Hook)
end

local function HookImproveDialog()
	local function ShowDialog_Hook(name, data)
		if name == "CONFIRM_IMPROVE_ITEM" then
			if SV.improveDialog then
				ImproveSmithingItem(data.bagId, data.slotIndex, data.boostersToApply)
				return true
			end
		end
	end
	ZO_PreHook("ZO_Dialogs_ShowDialog", ShowDialog_Hook)
end

local function HookMarketAnnouncement()
	if SCENE_MANAGER.scenes.marketAnnouncement then
		local function SetState_Hook(self, state, ...)
			if state == SCENE_SHOWING then
				return SV.marketAnnouncement
			end
		end
		ZO_PreHook(SCENE_MANAGER.scenes.marketAnnouncement, "SetState", SetState_Hook)
	end
end

local function HandleLuaErrorEvent()

	if SV.luaError == 1 then
		
		--unregister original handler
		EVENT_MANAGER:UnregisterForEvent("ErrorFrame", EVENT_LUA_ERROR)
		
		local seenBugs = {}
		
		--create a new event handler
		local function OnLuaError(_, errString)
			
			-- Display a notification
			local LNTF = LibStub("LibNotifications")
			local provider = LNTF:CreateProvider()
			
			local function RemoveNotification(data)
				table.remove(provider.notifications, data.notificationId)
				provider:UpdateNotifications()
			end
			
			if not seenBugs[errString] then
			
				local msg = {
					dataType						= NOTIFICATIONS_REQUEST_DATA,
					secsSinceRequest			= ZO_NormalizeSecondsSince(0),
					message						= GetString(NOTYOU_LUAERR_MESSAGE),
					note							= errString,
					heading						= GetString(NOTYOU_LUAERR_HEADING),
					texture						= "/esoui/art/miscellaneous/eso_icon_warning.dds",
					shortDisplayText			= GetString(NOTYOU_LUAERR_SHORT),
					controlsOwnSounds			= true,
					keyboardAcceptCallback	= function(data)
						ZO_ERROR_FRAME:OnUIError(errString)
						RemoveNotification(data)
					end,
					keybaordDeclineCallback	= RemoveNotification,
					gamepadAcceptCallback	= function(data)
						ZO_ERROR_FRAME:OnUIError(errString)
						RemoveNotification(data)
					end,
					gamepadDeclineCallback	= RemoveNotification,
					data							= {errString = errString},
				}
				
				table.insert(provider.notifications, msg)
				provider:UpdateNotifications()
				seenBugs[errString] = true
			
			end
			
		end
		
		EVENT_MANAGER:RegisterForEvent("LUA_ERROR", EVENT_LUA_ERROR, OnLuaError)
	
	end
	
end

local function HandleLuaLowMemoryEvent()

	--unregister original handler
	EVENT_MANAGER:UnregisterForEvent("ZO_UIErrors_OnEvent", EVENT_LUA_LOW_MEMORY)

	--define new dialog
	local lowMemoryDialog = {
		gamepadInfo = { dialogType = GAMEPAD_DIALOGS.BASIC },
		title = { text = GetString(NOTYOU_LUADIALOG_TITLE) },
		mainText = { text = GetString(NOTYOU_LUADIALOG_TEXT) },
		buttons = {
			[1] = {
				text = SI_DIALOG_YES,
				callback = function(dialog)
					SetCVar("LuaMemoryLimitMB", tostring(dialog.data.newLimit))
					ReloadUI("ingame")
				end,
			},
			[2] =  { text = SI_DIALOG_NO }
		}
	}
	
	ZO_Dialogs_RegisterCustomDialog("LUA_LOW_MEMORY", lowMemoryDialog)
	
	if SV.luaMemory == 0 then
		
		--create a new event handler
		local function OnEventNoDialog()
			
			--create a new event handler
			local function OnEventDialog(data)
				local currentLimit = tonumber(GetCVar("LuaMemoryLimitMB")) or 64
				--round to the next power of two
				local _, exponent = math.frexp(currentLimit)
				local newLimit = 2 ^ exponent
				
				if not ZO_Dialogs_IsShowing("LUA_LOW_MEMORY") then
					if IsInGamepadPreferredMode() then
						ZO_Dialogs_ShowGamepadDialog("LUA_LOW_MEMORY", { newLimit = newLimit }, { mainTextParams = { currentLimit, newLimit } } )
					else
						ZO_Dialogs_ShowDialog("LUA_LOW_MEMORY", { newLimit = newLimit }, { mainTextParams = { currentLimit, newLimit } } )
					end
				end
			end
			
			-- Display a notification
			local LNTF = LibStub("LibNotifications")
			local provider = LNTF:CreateProvider()
			
			local function RemoveNotification(data)
				table.remove(provider.notifications, data.notificationId)
				provider:UpdateNotifications()
			end
			
			local msg = {
				dataType						= NOTIFICATIONS_REQUEST_DATA,
				secsSinceRequest			= ZO_NormalizeSecondsSince(0),
				message						= GetString(NOTYOU_LUAMEM_MESSAGE),
				heading						= GetString(NOTYOU_LUAMEM_HEADING),
				texture						= "/esoui/art/miscellaneous/eso_icon_warning.dds",
				shortDisplayText			= GetString(NOTYOU_LUAMEM_SHORT),
				controlsOwnSounds			= true,
				keyboardAcceptCallback	= OnEventDialog,
				keybaordDeclineCallback	= RemoveNotification,
				gamepadAcceptCallback	= OnEventDialog,
				gamepadDeclineCallback	= RemoveNotification,
				data							= {},
			}
			
			table.insert(provider.notifications, msg)
			provider:UpdateNotifications()
			
		end
		
		EVENT_MANAGER:RegisterForEvent("LUA_LOW_MEMORY_DIALOG", EVENT_LUA_LOW_MEMORY, OnEventNoDialog)

	else
		
		-- Display the dialog directly
		
		--create a new event handler
		local function OnEventDialog()
			local currentLimit = tonumber(GetCVar("LuaMemoryLimitMB")) or 64
			--round to the next power of two
			local _, exponent = math.frexp(currentLimit)
			local newLimit = 2 ^ exponent

			if not ZO_Dialogs_IsShowing("LUA_LOW_MEMORY") then
				if IsInGamepadPreferredMode() then
					ZO_Dialogs_ShowGamepadDialog("LUA_LOW_MEMORY", { newLimit = newLimit }, { mainTextParams = { currentLimit, newLimit } } )
				else
					ZO_Dialogs_ShowDialog("LUA_LOW_MEMORY", { newLimit = newLimit }, { mainTextParams = { currentLimit, newLimit } } )
				end
			end
		end
		
		EVENT_MANAGER:RegisterForEvent("LUA_LOW_MEMORY_DIALOG", EVENT_LUA_LOW_MEMORY, OnEventDialog)
	
	end
	
end

local function BuildSettingsMenu()
	local panelData = {
		type = "panel",
		name = "No, thank you!",
		author = "Garkin & Ayantir",
		version = ADDON_VERSION,
		slashCommand = "/noty",
		registerForRefresh = true,
		registerForDefaults = true,
	}
	
	local guildInvites = { GetString(NOTY_GUILD_INV_OPTION_0), GetString(NOTY_GUILD_INV_OPTION_1), GetString(NOTY_GUILD_INV_OPTION_2) }
	local guildInvitesLookup = { [GetString(NOTY_GUILD_INV_OPTION_0)] = 0, [GetString(NOTY_GUILD_INV_OPTION_1)] = 1, [GetString(NOTY_GUILD_INV_OPTION_2)] = 2 }

	local avaMode = { GetString(NOTY_AVA_MODE_OPTION_0), GetString(NOTY_AVA_MODE_OPTION_1), GetString(NOTY_AVA_MODE_OPTION_2) }
	local avaModeLookup = { [GetString(NOTY_AVA_MODE_OPTION_0)] = 0, [GetString(NOTY_AVA_MODE_OPTION_1)] = 1, [GetString(NOTY_AVA_MODE_OPTION_2)] = 2 }

	local soundMode = { GetString(NOTY_SOUND_MODE_OPTION_0), GetString(NOTY_SOUND_MODE_OPTION_1), GetString(NOTY_SOUND_MODE_OPTION_2), GetString(NOTY_SOUND_MODE_OPTION_3) }
	local soundModeLookup = { [GetString(NOTY_SOUND_MODE_OPTION_0)] = 0, [GetString(NOTY_SOUND_MODE_OPTION_1)] = 1, [GetString(NOTY_SOUND_MODE_OPTION_2)] = 2, [GetString(NOTY_SOUND_MODE_OPTION_3)] = 3 }

	local guildAlertsMode = { GetString(NOTY_GALERTS_OPTION_0), GetString(NOTY_GALERTS_OPTION_1), GetString(NOTY_GALERTS_OPTION_2) }
	local guildAlertsModeLookup = { [GetString(NOTY_GALERTS_OPTION_0)] = 0, [GetString(NOTY_GALERTS_OPTION_1)] = 1, [GetString(NOTY_GALERTS_OPTION_2)] = 2 }

	local raidMode = { GetString(NOTY_RAID_OPTION_0), GetString(NOTY_RAID_OPTION_1), GetString(NOTY_RAID_OPTION_2), GetString(NOTY_RAID_OPTION_3) }
	local raidModeLookup = { [GetString(NOTY_RAID_OPTION_0)] = 0, [GetString(NOTY_RAID_OPTION_1)] = 1, [GetString(NOTY_RAID_OPTION_2)] = 2, [GetString(NOTY_RAID_OPTION_3)] = 3 }

	local motdMode = { GetString(NOTY_MOTD_OPTION_0), GetString(NOTY_MOTD_OPTION_1), GetString(NOTY_MOTD_OPTION_2) }
	local motdModeLookup = { [GetString(NOTY_MOTD_OPTION_0)] = 0, [GetString(NOTY_MOTD_OPTION_1)] = 1, [GetString(NOTY_MOTD_OPTION_2)] = 2 }
	
	local guildLeaveMode = { GetString(NOTY_GUILDLEAVE_OPTION_0), GetString(NOTY_GUILDLEAVE_OPTION_1), GetString(NOTY_GUILDLEAVE_OPTION_2) }
	local guildLeaveModeLookup = { [GetString(NOTY_GUILDLEAVE_OPTION_0)] = 0, [GetString(NOTY_GUILDLEAVE_OPTION_1)] = 1, [GetString(NOTY_GUILDLEAVE_OPTION_2)] = 2 }
	
	local luaMemory = { GetString(NOTY_LUAMEM_OPTION_0), GetString(NOTY_LUAMEM_OPTION_1) }
	local luaMemoryLookup = { [GetString(NOTY_LUAMEM_OPTION_0)] = 0, [GetString(NOTY_LUAMEM_OPTION_1)] = 1 }
	
	local luaError = { GetString(NOTY_LUAERR_OPTION_0), GetString(NOTY_LUAERR_OPTION_1) }
	local luaErrorLookup = { [GetString(NOTY_LUAERR_OPTION_0)] = 0, [GetString(NOTY_LUAERR_OPTION_1)] = 1 }

	local optionsData = {
		--AvA Messages
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_AVA_HEADER)),
		},
		{
			type = "dropdown",
			name = GetString(NOTYOU_AVA),
			tooltip = GetString(NOTYOU_AVA_TOOLTIP),
			choices = avaMode,
			getFunc = function() return avaMode[SV.ava + 1] end,
			setFunc = function(value) SV.ava = avaModeLookup[value] end,
			default = avaMode[defaults.ava + 1],
		},
		--Friends Status Messages
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_FRIENDS_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_FRIENDS_ACTIVITY),
			tooltip = GetString(NOTYOU_FRIENDS_ACTIVITY_TOOLTIP),
			getFunc = function() return SV.friends end,
			setFunc = function(value) SV.friends = value end,
			default = defaults.friends,
		},
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_TEXT_ALERTS_HEADER)),
		},
		--Ability alerts
		{
			type = "checkbox",
			name = GetString(NOTYOU_MOB_IMMUNE),
			tooltip = GetString(NOTYOU_MOB_IMMUNE_TOOLTIP),
			getFunc = function() return SV.boss end,
			setFunc = function(value) SV.boss = value end,
			default = defaults.boss,
		},
		--Screenshot Saved alert
		{
			type = "checkbox",
			name = GetString(NOTYOU_SCREENSHOT),
			tooltip = GetString(NOTYOU_SCREENSHOT_TOOLTIP),
			getFunc = function() return SV.screenshot end,
			setFunc = function(value) SV.screenshot = value end,
			default = defaults.screenshot,
		},
		--Enlightened alert
		{
			type = "checkbox",
			name = GetString(NOTYOU_ENLIGHTENED),
			tooltip = GetString(NOTYOU_ENLIGHTENED_TOOLTIP),
			getFunc = function() return SV.enlightened end,
			setFunc = function(value) SV.enlightened = value end,
			default = defaults.enlightened,
			disabled = function() return not IsEnlightenedAvailableForCharacter() end,
		},
		--Crafting Result alerts
		{
			type = "checkbox",
			name = GetString(NOTYOU_CRAFTRESULT),
			tooltip = GetString(NOTYOU_CRAFTRESULT_TOOLTIP),
			getFunc = function() return SV.craftingResults end,
			setFunc = function(value) SV.craftingResults = value end,
			default = defaults.craftingResults,
		},
		--Repair alerts
		{
			type = "checkbox",
			name = GetString(NOTYOU_REPAIR),
			tooltip = GetString(NOTYOU_REPAIR_TOOLTIP),
			getFunc = function() return SV.repair end,
			setFunc = function(value) SV.repair = value end,
			default = defaults.repair,
			disabled = function() return ZO_GamepadStoreManager == nil end,
		},
		--AlertText throttling
		{
			type = "slider",
			name = GetString(NOTYOU_ALERT_THROTTLING),
			tooltip = GetString(NOTYOU_ALERT_THROTTLING_TOOLTIP),
			min = 3,
			max = 30,
			getFunc = function() return SV.alertTextExpiryDelay end,
			setFunc = function(value)
				SV.alertTextExpiryDelay = value
				recentMessages.expiryDelayMilliseconds = value * 1000
			end,
			default = defaults.alertTextExpiryDelay,
		},
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_SOUND_HEADER)),
		},
		{
			type = "dropdown",
			name = GetString(NOTYOU_ULTISOUND),
			tooltip = GetString(NOTYOU_ULTISOUND_TOOLTIP),
			choices = soundMode,
			getFunc = function() return soundMode[SV.ultimateSound + 1] end,
			setFunc = function(value) SV.ultimateSound = soundModeLookup[value] end,
			default = soundMode[defaults.ultimateSound + 1],
		},
		--Hide market announcement
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_MARKET_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_MARKET_ADS),
			tooltip = GetString(NOTYOU_MARKET_ADS_TOOLTIP),
			getFunc = function() return SV.marketAnnouncement end,
			setFunc = function(value) SV.marketAnnouncement = value end,
			default = defaults.marketAnnouncement,
			disabled = function() return SCENE_MANAGER.scenes.marketAnnouncement == nil end,
		},
		--Confirmation dialog when deleting empty mails
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_MAIL_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_MAIL),
			tooltip = GetString(NOTYOU_MAIL_TOOLTIP),
			getFunc = function() return SV.emptyMail end,
			setFunc = function(value) SV.emptyMail = value end,
			default = defaults.emptyMail,
		},
		--Confirmation dialog when selling rare items to fence
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_FENCE_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_FENCE),
			tooltip = GetString(NOTYOU_FENCE_TOOLTIP),
			getFunc = function() return SV.fenceDialog end,
			setFunc = function(value) SV.fenceDialog = value end,
			default = defaults.fenceDialog,
		},
		--Confirmation dialog when disband group and setting large group
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_GROUPS_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_GROUPS_DISBAND),
			tooltip = GetString(NOTYOU_GROUPS_DISBAND_TOOLTIP),
			getFunc = function() return SV.disbandDialog end,
			setFunc = function(value) SV.disbandDialog = value end,
			default = defaults.disbandDialog,
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_GROUPS_LARGE),
			tooltip = GetString(NOTYOU_GROUPS_LARGE_TOOLTIP),
			getFunc = function() return SV.largeGroupDialog end,
			setFunc = function(value) SV.largeGroupDialog = value end,
			default = defaults.largeGroupDialog,
		},
		--Confirmation dialog when crafting
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_CRAFT_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_CRAFT),
			tooltip = GetString(NOTYOU_CRAFT_TOOLTIP),
			getFunc = function() return SV.improveDialog end,
			setFunc = function(value) SV.improveDialog = value end,
			default = defaults.improveDialog,
		},
		--Chameleon checkbox
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_CHAMELEON_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_CHAMELEON),
			tooltip = GetString(NOTYOU_CHAMELEON_TOOLTIP),
			getFunc = function() return SV.noUniversalStones end,
			setFunc = function(value)
				SV.noUniversalStones = value
				NoUniversalStones()
			end,
			default = defaults.noUniversalStones,
		},
		-- Reticle options
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_RETICLE_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_RETICLE_TAKE),
			tooltip = GetString(NOTYOU_RETICLE_TAKE_TOOLTIP),
			getFunc = function() return SV.reticleTake end,
			setFunc = function(value) SV.reticleTake = value end,
			default = defaults.reticleTake,
		},
		-- Auto Loot Items
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_AUTOLOOTITEMS_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_AUTOLOOTITEMS),
			tooltip = GetString(NOTYOU_AUTOLOOTITEMS_TOOLTIP),
			getFunc = function() return SV.autoLootItems end,
			setFunc = function(value)
				SV.autoLootItems = value
				NoLootWindowOnItems()
			end,
			default = defaults.autoLootItems,
		},
		-- Guild Invites
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_GUILDS_HEADER)),
		},
		{
			type = "dropdown",
			name = GetString(NOTYOU_GUILDS),
			tooltip = GetString(NOTYOU_GUILDS_TOOLTIP),
			choices = guildInvites,
			getFunc = function() return guildInvites[SV.guildInvites + 1] end,
			setFunc = function(value) SV.guildInvites = guildInvitesLookup[value] end,
			default = guildInvites[defaults.guildInvites + 1],
		},
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_CAMERA_HEADER)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_CAMERA_INTERRUPT),
			tooltip = GetString(NOTYOU_CAMERA_INTERRUPT_TOOLTIP),
			getFunc = function() return SV.nonstopHarvest end,
			setFunc = function(value) SV.nonstopHarvest = value end,
			default = defaults.nonstopHarvest,
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_CAMERA_ROTATE),
			tooltip = GetString(NOTYOU_CAMERA_ROTATE_TOOLTIP),
			getFunc = function() return SV.noCameraSpin end,
			setFunc = function(value)
				SV.noCameraSpin = value
				DontRotateGameCamera()
			end,
			default = defaults.noCameraSpin,
		},
		{
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(SI_WINDOW_TITLE_LORE_LIBRARY)),
		},
		{
			type = "checkbox",
			name = GetString(NOTYOU_NOLOREREADER),
			tooltip = GetString(NOTYOU_NOLOREREADER_TOOLTIP),
			getFunc = function() return SV.dontReadBooks end,
			setFunc = function(value)
				SV.dontReadBooks = value
				DontReadBooks()
			end,
			default = defaults.dontReadBooks,
		},
	}
	--Guild Alerts
	local submenuGuildAlerts = {
		type = "submenu",
		name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_GROSTER_HEADER)),
		tooltip = GetString(NOTYOU_GROSTER_HEADER_TOOLTIP),
		controls = {
			{
				type = "dropdown",
				name = GetString(NOTYOU_GROSTER),
				tooltip = GetString(NOTYOU_GROSTER_TOOLTIP),
				choices = guildAlertsMode,
				getFunc = function() return guildAlertsMode[SV.guildAlerts + 1] end,
				setFunc = function(value) SV.guildAlerts = guildAlertsModeLookup[value] end,
				default = guildAlertsMode[defaults.guildAlerts + 1],
			},
			{
				type = "texture",
				image = "EsoUI/Art/Quest/questJournal_divider.dds",
				imageWidth = 510,
				imageHeight = 4,
			},
		},
	}
	--RaidScore Notifications
	local submenuRaidScore = {
		type = "submenu",
		name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_RAIDSCORE_HEADER)),
		tooltip = GetString(NOTYOU_RAIDSCORE_HEADER_TOOLTIP),
		controls = {
			{
				type = "dropdown",
				name = GetString(NOTYOU_RAIDSCORE_ONLYFOR),
				tooltip = GetString(NOTYOU_RAIDSCORE_ONLYFOR_TOOLTIP),
				choices = raidMode,
				getFunc = function() return raidMode[SV.raid + 1] end,
				setFunc = function(value) SV.raid = raidModeLookup[value] end,
				default = raidMode[defaults.raid + 1],
			},
			{
				type = "checkbox",
				name = GetString(NOTYOU_RAIDSCORE_REDIRECT),
				getFunc = function() return SV.raidToChat end,
				setFunc = function(value) SV.raidToChat = value end,
				default = defaults.raidToChat,
				disabled = function() return SV.raid == 3 end
			},
			{
				type = "texture",
				image = "EsoUI/Art/Quest/questJournal_divider.dds",
				imageWidth = 510,
				imageHeight = 4,
			},
		},
	}
	--Guild MotD Notifications
	local submenuGuildMotD = {
		type = "submenu",
		name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_MOTD_HEADER)),
		tooltip = GetString(NOTYOU_MOTD_HEADER_TOOLTIP),
		controls = {
			{
				type = "dropdown",
				name = GetString(NOTYOU_MOTD_BLOCK),
				tooltip = GetString(NOTYOU_MOTD_BLOCK_TOOLTIP),
				choices = motdMode,
				getFunc = function() return motdMode[SV.motd + 1] end,
				setFunc = function(value) SV.motd = motdModeLookup[value] end,
				default = motdMode[defaults.motd + 1],
			},
			{
				type = "texture",
				image = "EsoUI/Art/Quest/questJournal_divider.dds",
				imageWidth = 510,
				imageHeight = 4,
			},
		},
	}
	
	--Guild MotD Notifications
	local submenuGuildLeave = {
		type = "submenu",
		name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_GUILDLEAVE_HEADER)),
		tooltip = GetString(NOTYOU_GUILDLEAVE_HEADER_TOOLTIP),
		controls = {
			{
				type = "dropdown",
				name = GetString(NOTYOU_GUILDLEAVE_BLOCK),
				tooltip = GetString(NOTYOU_GUILDLEAVE_BLOCK_TOOLTIP),
				choices = guildLeaveMode,
				getFunc = function() return guildLeaveMode[SV.noGuildLeave + 1] end,
				setFunc = function(value) SV.noGuildLeave = guildLeaveModeLookup[value] end,
				default = guildLeaveMode[defaults.noGuildLeave + 1],
			},
			{
				type = "texture",
				image = "EsoUI/Art/Quest/questJournal_divider.dds",
				imageWidth = 510,
				imageHeight = 4,
			},
		},
	}

	for i = 1, MAX_GUILDS do
		local gname = GetGuildName(GetGuildId(i))

		--Guild Alerts
		local guildData = {
			type = "checkbox",
			name = (#gname > 0 and gname or "Guild " .. i),
			getFunc = function() return SV.guildAlertsGuilds[i] end,
			setFunc = function(value) SV.guildAlertsGuilds[i] = value end,
			default = defaults.guildAlertsGuilds[i],
			disabled = function() return SV.guildAlerts == 0 end,
		}
		table.insert(submenuGuildAlerts.controls, guildData)

		--RaidScore Notifications
		guildData = {
			type = "checkbox",
			name = (#gname > 0 and gname or "Guild " .. i),
			getFunc = function() return SV.raidGuilds[i] end,
			setFunc = function(value)
					SV.raidGuilds[i] = value
					NOTIFICATIONS:RefreshNotificationList()
				end,
			default = defaults.raidGuilds[i],
			disabled = function() return SV.raid ~= 2 end,
		}
		table.insert(submenuRaidScore.controls, guildData)

		--Guild MotD Notifications
		local motdData = {
			type = "checkbox",
			name = (#gname > 0 and gname or "Guild " .. i),
			getFunc = function() return SV.motdGuilds[i] end,
			setFunc = function(value)
					SV.motdGuilds[i] = value
					NOTIFICATIONS:RefreshNotificationList()
				end,
			default = defaults.motdGuilds[i],
			disabled = function() return SV.motd == 0 end,
		}
		table.insert(submenuGuildMotD.controls, motdData)
		
		--Guild Leave
		local guildLeave = {
			type = "checkbox",
			name = (#gname > 0 and gname or "Guild " .. i),
			getFunc = function() return SV.guildLeave[i] end,
			setFunc = function(value) SV.guildLeave[i] = value end,
			default = defaults.guildLeave[i],
			disabled = function() return SV.noGuildLeave ~= 2 end,
		}
		table.insert(submenuGuildLeave.controls, guildLeave)
		
	end

	--add submenus to the optionsData
	table.insert(optionsData, submenuGuildAlerts)
	table.insert(optionsData, submenuRaidScore)
	table.insert(optionsData, submenuGuildMotD)
	table.insert(optionsData, submenuGuildLeave)
	
	table.insert(optionsData, {
			type = "header",
			name = ZO_HIGHLIGHT_TEXT:Colorize(GetString(NOTYOU_LUA_HEADER)),
		})
	table.insert(optionsData, {
			type = "dropdown",
			name = GetString(NOTYOU_LUA_MEMORY),
			tooltip = GetString(NOTYOU_LUA_MEMORY_TOOLTIP),
			choices = luaMemory,
			getFunc = function() return luaMemory[SV.luaMemory + 1] end,
			setFunc = function(value) SV.luaMemory = luaMemoryLookup[value] end,
			default = luaMemory[defaults.luaMemory + 1],
		})
	table.insert(optionsData, {
			type = "dropdown",
			name = GetString(NOTYOU_LUA_ERROR),
			tooltip = GetString(NOTYOU_LUA_ERROR_TOOLTIP),
			choices = luaError,
			getFunc = function() return luaError[SV.luaError + 1] end,
			setFunc = function(value)
				SV.luaError = luaErrorLookup[value]
				HandleLuaErrorEvent()
			end,
			default = luaError[defaults.luaError + 1],
		})

	local LAM = LibStub("LibAddonMenu-2.0")
	local panel = LAM:RegisterAddonPanel("NOTY_Panel", panelData)
	LAM:RegisterOptionControls("NOTY_Panel", optionsData)

	--add logo
	panel.logo = WINDOW_MANAGER:CreateControl(nil, panel, CT_TEXTURE)
	panel.logo:SetAnchor(TOP, panel, TOP, -5, 15)
	panel.logo:SetDimensions(420, 60)
	panel.logo:SetTexture("NoThankYou/Art/noty.dds")
	panel.logo:SetTextureCoords(0, 1, 0, 0.1429)
	panel.label:SetHeight(65)
	panel.label:SetHidden(true)
	panel.container:ClearAnchors()
	panel.container:SetAnchor(TOPLEFT, panel.info, BOTTOMLEFT, 0, 10)
	panel.container:SetAnchor(BOTTOMRIGHT, panel, BOTTOMRIGHT, -3, -3)
end

local function OnAddonLoaded(event, name)
	if name == ADDON_NAME then
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, event)

		SV = ZO_SavedVars:NewAccountWide("NO_THANK_YOU_VARS", 1, defaults)

		--set hooks
		HookAvAMessages()
		HookFriendsMessages()
		BossAlertTextsHook()
		ScreenshotAlertHook()
		EnlightenedAlertHook()
		GuildRosterAlertsHook()
		CraftingResultAlertsHook()
		RepairAlertsHook()
		AlertTextThrottling()
		DeleteEmptyMailHook()
		HookRaidNotifications()
		HookMotDNotifications()
		HookReticleTake()
		HookGuildInvitesNotifications()
		HandleLuaErrorEvent()
		HandleLuaLowMemoryEvent()
		DontInterruptHarvesting()
		DontRotateGameCamera()
		HookFenceDialog()
		HookPlaySound()
		HookDisbandDialog()
		HookLargeGroupDialog()
		HookImproveDialog()
		HookMarketAnnouncement()
		HookPlayerToPlayerGuildInvite()
		DontReadBooks()
		NoUniversalStones()
		NoGuildLeave()
		NoLootWindowOnItems()

		BuildSettingsMenu()

		--rebuild notifications list
		NOTIFICATIONS:RefreshNotificationList()
	end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnAddonLoaded)