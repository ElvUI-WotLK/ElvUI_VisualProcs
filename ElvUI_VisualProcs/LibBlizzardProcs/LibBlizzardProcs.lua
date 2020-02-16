local MAJOR_VERSION = "LibBlizzardProcs-1.0"
local MINOR_VERSION = 3

if not LibStub then error(MAJOR_VERSION .. " requires LibStub.") end
local lib = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION)
if not lib then return end

local LBP_Data = LBP_Data
if not LBP_Data then error(MAJOR_VERSION .. " requires LBP_Data.") end

local CBH = LibStub("CallbackHandler-1.0")

-- Lua APIs
local _G = _G
local pairs, ipairs, next = pairs, ipairs, next
local ceil, floor, fmod = math.ceil, math.floor, math.fmod
local upper = string.upper
local tinsert, tremove, twipe = table.insert, table.remove, table.wipe

-- WoW APIs
local CreateFrame = CreateFrame
local PlaySoundFile = PlaySoundFile
local PlayerFrame = PlayerFrame
local UnitBuff = UnitBuff
local UnitExists = UnitExists
local UnitHealth = UnitHealth
local UnitHealthMax = UnitHealthMax
local UnitIsConnected = UnitIsConnected
local UnitIsEnemy = UnitIsEnemy
local UnitIsPlayer = UnitIsPlayer

lib.eventFrame = lib.eventFrame or CreateFrame("Frame")
lib.eventFrame:UnregisterAllEvents()

lib.overlayShow = lib.overlayShow or {}
lib.overlayHide = lib.overlayHide or {}
lib.overlayGlowShow = lib.overlayGlowShow or {}
lib.overlayGlowHide = lib.overlayGlowHide or {}

-- Overlay
lib.overlay = lib.overlay or {}
lib.overlay.inUse = lib.overlay.inUse or {}
lib.overlay.unused = lib.overlay.unused or {}

-- Overlay Glow
lib.overlayGlow = lib.overlayGlow or {}
lib.overlayGlow.unused = lib.overlayGlow.unused or {}
lib.overlayGlow.num = lib.overlayGlow.num or 0

lib.event = {
	["SPELL_ACTIVATION_OVERLAY_SHOW"] = lib.overlayShow,
	["SPELL_ACTIVATION_OVERLAY_HIDE"] = lib.overlayHide,
	["SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"] = lib.overlayGlowShow,
	["SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"] = lib.overlayGlowHide,
}

lib.callbacks = lib.callbacks or CBH:New(lib)

lib.playerClass = lib.playerClass or select(2, UnitClass("player"))
lib.isClassSupported = lib.isClassSupported or lib.playerClass and (#LBP_Data.ButtonProcs[lib.playerClass] > 0 or next(LBP_Data.OverlayProcs[lib.playerClass]))

lib.mediaPath = lib.mediaPath or "Interface\\AddOns\\LibBlizzardProcs\\textures\\"

lib.disableOverlay = lib.disableOverlay or false
lib.disableButtonGlow = lib.disableButtonGlow or false
lib.disableSound = lib.disableSound or false

lib.ExecuteButtonSpells = lib.ExecuteButtonSpells or {
	HUNTER = 61006,
	PALADIN = 24275,
	WARRIOR = 5308,
}

local actionButtons = {}
local buffs = {}
local buffGlowSpells = {}
local spellsOverlayed = {}

local function AddOverlayGlow(spellID)
	local overlayedCount = spellsOverlayed[spellID]

	if not overlayedCount then
		spellsOverlayed[spellID] = 1

		for frame, func in pairs(lib.overlayGlowShow) do
			func(frame, spellID)
		end
	else
		spellsOverlayed[spellID] = overlayedCount + 1
	end
end

local function RemoveOverlayGlow(spellID)
	local overlayedCount = spellsOverlayed[spellID]

	if overlayedCount then
		if overlayedCount == 1 then
			spellsOverlayed[spellID] = nil

			for frame, func in pairs(lib.overlayGlowHide) do
				func(frame, spellID)
			end
		else
			spellsOverlayed[spellID] = overlayedCount - 1
		end
	end
end

function lib:SetAction(action, spellID)
	actionButtons[action] = spellID

	if spellID then
		local procIdx = LBP_Data.ButtonSpells[lib.playerClass][spellID]
		if procIdx then
			for _, procID in ipairs(LBP_Data.ButtonProcs[lib.playerClass][procIdx]) do
				local glowSpells = buffGlowSpells[procID]

				if not glowSpells then
					buffGlowSpells[procID] = {
						[spellID] = 1
					}

					if buffs[procID] then
						AddOverlayGlow(spellID)
					end
				else
					local refCount = glowSpells[spellID]

					if not refCount then
						glowSpells[spellID] = 1

						if buffs[procID] then
							AddOverlayGlow(spellID)
						end
					else
						glowSpells[spellID] = refCount + 1
					end
				end
			end
		end
	end
end

function lib:ChangeAction(action, newSpellID)
	local spellID = actionButtons[action]
	if spellID == newSpellID then return end

	if spellID then
		local procIdx = LBP_Data.ButtonSpells[lib.playerClass][spellID]

		if procIdx then
			for _, procID in ipairs(LBP_Data.ButtonProcs[lib.playerClass][procIdx]) do
				local glowSpells = buffGlowSpells[procID]
				local refCount = glowSpells[spellID]

				if refCount == 1 then
					glowSpells[spellID] = nil

					if not next(glowSpells) then
						buffGlowSpells[procID] = nil
					end

					if buffs[procID] then
						RemoveOverlayGlow(spellID)
					end
				else
					glowSpells[spellID] = refCount - 1
				end
			end
		end
	end

	lib:SetAction(action, newSpellID)
end

function lib:DisableButtonGlows()
	for spellID, hasBuff in pairs(buffs) do
		if hasBuff then
			local glowSpells = buffGlowSpells[spellID]

			if glowSpells then
				for globalID in pairs(glowSpells) do
					RemoveOverlayGlow(globalID)
				end
			end
		end
	end
end

local function BuffGained(spellID, textureData)
	if not lib.disableOverlay and textureData and textureData[2] then
		local texture = lib.mediaPath .. "overlay\\" .. textureData[2]
		local positions = textureData[3]
		local scale = textureData[4]
		local r, g, b = textureData[5], textureData[6], textureData[7]

		for frame, func in pairs(lib.overlayShow) do
			func(frame, spellID, texture, positions, scale, r, g, b)
		end
	end

	if not lib.disableButtonGlow then
		local glowSpells = buffGlowSpells[spellID]

		if glowSpells then
			for globalID in pairs(glowSpells) do
				AddOverlayGlow(globalID)
			end
		end
	end
end

local function BuffLost(spellID, noOverlay)
	if not lib.disableOverlay and not noOverlay then
		for frame, func in pairs(lib.overlayHide) do
			func(frame, spellID)
		end
	end

	if not lib.disableButtonGlow then
		local glowSpells = buffGlowSpells[spellID]

		if glowSpells then
			for globalID in pairs(glowSpells) do
				RemoveOverlayGlow(globalID)
			end
		end
	end
end

local function ExecuteCheckHealth()
	local hp = UnitHealth("target") / UnitHealthMax("target") * 100

	if hp < 20 and hp > 0 then
		return true
	end
end

local function ExecuteUpdate()
	if lib.executeValidTarget and ExecuteCheckHealth() then
		if not lib.executeShown then
			BuffGained(lib.ExecuteButtonSpells[lib.playerClass])
			lib.executeShown = true
		end
	elseif lib.executeShown then
		if lib.playerClass ~= "WARRIOR" or not buffs[52437] then
			BuffLost(lib.ExecuteButtonSpells[lib.playerClass], true)
		end

		lib.executeShown = nil
	end
end

local function OnEvent(_, event, unit)
	if event == "UNIT_AURA" then
		if unit == PlayerFrame.unit then
			local overlayProcList = LBP_Data.OverlayProcs[lib.playerClass]

			local overlayTextures
			local _, name, count, spellID

			for i = 1, 40 do
				name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, i)
				if not name then break end

				local textureIndx = overlayProcList[spellID]
				if textureIndx then
					if not overlayTextures then
						overlayTextures = LBP_Data.OverlayTextures[lib.playerClass]
					end

					if overlayTextures[textureIndx][1] <= count then
						local hasBuff = buffs[spellID]
						buffs[spellID] = false

						if hasBuff == nil then
							BuffGained(spellID, overlayTextures[textureIndx])
						end
					end
				else
					local hasBuff = buffs[spellID]
					buffs[spellID] = false

					if hasBuff == nil then
						BuffGained(spellID)
					end
				end
			end

			for spellID, hasBuff in pairs(buffs) do
				if not hasBuff then
					buffs[spellID] = true
				else
					buffs[spellID] = nil
					BuffLost(spellID)
				end
			end
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		unit = PlayerFrame.unit

		local overlayProcList = LBP_Data.OverlayProcs[lib.playerClass]

		local overlayTextures
		local _, name, count, spellID

		for i = 1, 40 do
			name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, i)
			if not name then break end

			local textureIndx = overlayProcList[spellID]
			if textureIndx then
				if not overlayTextures then
					overlayTextures = LBP_Data.OverlayTextures[lib.playerClass]
				end

				if overlayTextures[textureIndx][1] <= count then
					buffs[spellID] = true
					BuffGained(spellID, overlayTextures[textureIndx])
				end
			else
				buffs[spellID] = true
				BuffGained(spellID)
			end
		end

		lib.eventFrame:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "PLAYER_TARGET_CHANGED" then
		if UnitExists("target") then
			if UnitIsEnemy("target", "player") and (not UnitIsPlayer("target") or UnitIsConnected("target")) then
				lib.executeValidTarget = true
				lib.eventFrame:RegisterEvent("UNIT_HEALTH")
			else
				lib.executeValidTarget = nil
				lib.eventFrame:UnregisterEvent("UNIT_HEALTH")
			end

			lib.eventFrame:RegisterEvent("UNIT_FACTION")
		else
			lib.executeValidTarget = nil
			lib.eventFrame:UnregisterEvent("UNIT_HEALTH")
			lib.eventFrame:UnregisterEvent("UNIT_FACTION")
		end

		ExecuteUpdate()
	elseif event == "UNIT_HEALTH" and unit == "target" then
		ExecuteUpdate()
	elseif event == "UNIT_FACTION" and unit == "target" then
		OnEvent(_, "PLAYER_TARGET_CHANGED")
	end
end

function lib:RegisterEvent(event, frame, func)
	local isEvent = lib.event[event]
	if isEvent then
		isEvent[frame] = func
	end
end

function lib:UnregisterEvent(event, frame)
	local isEvent = lib.event[event]
	if isEvent then
		isEvent[frame] = nil
	end
end

function lib:IsEventRegistered(event, frame)
	local isEvent = lib.event[event]
	if isEvent and isEvent[frame] then
		return true
	end
	return false
end

function lib:IsSpellOverlayed(spellID)
	return spellsOverlayed[spellID] and true or false
end

-- Animation Functions
local function InitAlphaAnimation(self)
	self.target = self.target or self:GetRegionParent()
	self.change = self.change or 0

	self.frameAlpha = self.target:GetAlpha()
	self.alphaFactor = self.frameAlpha + self.change - self.frameAlpha
end

local function TidyAlphaAnimation(self)
	self.alphaFactor = nil
	self.frameAlpha = nil
end

local function AlphaAnimation_OnUpdate(self, elapsed)
	local progress = self:GetSmoothProgress()
	if progress ~= 0 then
		if not self.played then
			InitAlphaAnimation(self)
			self.played = 1
		end

		if self.frameAlpha then
			self.target:SetAlpha(self.frameAlpha + self.alphaFactor * progress)

			if progress == 1 then
				TidyAlphaAnimation(self)
			end
		end
	end
end

local function AlphaAnimation_OnStop(self)
	if self.frameAlpha then
		TidyAlphaAnimation(self)
	end

	self.played = nil
end

local function CreateAlphaAnim(group, target, order, duration, change, delay, onPlay, onFinished)
	local alpha = group:CreateAnimation()

	if target then
		alpha.target = _G[alpha:GetRegionParent():GetName() .. target]
	end

	if order then
		alpha:SetOrder(order)
	end

	alpha:SetDuration(duration)
	alpha.change = change

	if delay then
		alpha:SetStartDelay(delay)
	end

	if onPlay then
		alpha:SetScript("OnPlay", onPlay)
	end

	alpha:SetScript("OnUpdate", AlphaAnimation_OnUpdate)
	alpha:SetScript("OnStop", AlphaAnimation_OnStop)
	alpha:SetScript("OnFinished", onFinished or AlphaAnimation_OnStop)
end

local function CreateBlizzAlphaAnim(group, order, duration, change, delay)
	local alpha = group:CreateAnimation("Alpha")

	if order then
		alpha:SetOrder(order)
	end

	alpha:SetDuration(duration)
	alpha:SetChange(change)

	if delay then
		alpha:SetStartDelay(delay)
	end
end

local function InitScaleAnimation(self)
	self.target = self.target or self:GetRegionParent()
	self.scaleX = self.scaleX or 0
	self.scaleY = self.scaleY or 0

	local _, _, width, height = self.target:GetRect()
	if not width then return end

	self.frameWidth = width
	self.frameHeight = height

	self.widthFactor = width * self.scaleX - width
	self.heightFactor = height * self.scaleY - height

	local setCenter
	local parent = self.target:GetParent()
	local numPoints = self.target:GetNumPoints()

	if numPoints > 0 then
		local point, relativeTo, relativePoint, xOffset, yOffset = self.target:GetPoint(1)

		if numPoints == 1 and point == "CENTER" then
			setCenter = false
		else
			local i = 1
			while true do
				if relativeTo ~= parent and yOffset then
					local j = #self + 1
					self[j], self[j + 1], self[j + 2], self[j + 3], self[j + 4] = point, relativeTo, relativePoint, xOffset, yOffset
				end

				i = i + 1
				if numPoints >= i then
					point, relativeTo, relativePoint, xOffset, yOffset = self.target:GetPoint(i)
				else
					break
				end
			end

			setCenter = true
		end
	else
		setCenter = true
	end

	if setCenter then
		local x, y = self.target:GetCenter()
		local parentX, parentY = parent:GetCenter()

		self.target:ClearAllPoints()
		self.target:SetPoint("CENTER", x - parentX, y - parentY)
	end

	return 1
end

local function TidyScaleAnimation(self)
	local target = self.target

	if #self ~= 0 then
		target:ClearAllPoints()

		for i = 1, #self, 5 do
			target:SetPoint(self[i], self[i + 1], self[i + 2], self[i + 3], self[i + 4])
			self[i] = nil
			self[i + 1] = nil
			self[i + 2] = nil
			self[i + 3] = nil
			self[i + 4] = nil
		end
	end

	self.widthFactor = nil
	self.heightFactor = nil

	self.frameWidth = nil
	self.frameHeight = nil
end

local function ScaleAnimation_OnUpdate(self, elapsed)
	local progress = self:GetSmoothProgress()
	if progress ~= 0 then
		if not self.played then
			if InitScaleAnimation(self) then
				self.played = 1
			end
		end

		if self.frameWidth then
			self.target:SetSize(self.frameWidth + self.widthFactor * progress, self.frameHeight + self.heightFactor * progress)

			if progress == 1 then
				TidyScaleAnimation(self)
			end
		end
	end
end

local function ScaleAnimation_OnStop(self)
	if self.frameWidth then
		TidyScaleAnimation(self)
	end

	self.played = nil
end

local function CreateScaleAnim(group, target, order, duration, x, y, delay, smoothing, onPlay)
	local scale = group:CreateAnimation()

	if target then
		scale.target = _G[scale:GetRegionParent():GetName() .. target]
	end

	scale:SetOrder(order)
	scale:SetDuration(duration)
	scale.scaleX, scale.scaleY = x, y

	if delay then
		scale:SetStartDelay(delay)
	end

	if smoothing then
		scale:SetSmoothing(smoothing)
	end

	if onPlay then
		scale:SetScript("OnPlay", onPlay)
	end

	scale:SetScript("OnUpdate", ScaleAnimation_OnUpdate)
	scale:SetScript("OnStop", ScaleAnimation_OnStop)
	scale:SetScript("OnFinished", ScaleAnimation_OnStop)
end

local function CreateBlizzScaleAnim(group, order, duration, x, y, delay, smoothing)
	local scale = group:CreateAnimation("Scale")

	scale:SetOrder(order)
	scale:SetDuration(duration)
	scale:SetScale(x, y)

	if delay then
		scale:SetStartDelay(delay)
	end

	if smoothing then
		scale:SetSmoothing(smoothing)
	end
end

local function AnimateTexCoords(texture, textureWidth, textureHeight, frameWidth, frameHeight, numFrames, elapsed, throttle)
	if not texture.frame then
		texture.frame = 1
		texture.throttle = throttle
		texture.numColumns = floor(textureWidth / frameWidth)
		texture.numRows = floor(textureHeight / frameHeight)
		texture.columnWidth = frameWidth / textureWidth
		texture.rowHeight = frameHeight / textureHeight
	end

	if not texture.throttle or texture.throttle > throttle then
		local frame = texture.frame
		local framesToAdvance = floor(texture.throttle / throttle)

		while frame + framesToAdvance > numFrames do
			frame = frame - numFrames
		end

		frame = frame + framesToAdvance
		texture.throttle = 0

		local left = fmod(frame - 1, texture.numColumns) * texture.columnWidth
		local right = left + texture.columnWidth
		local bottom = ceil(frame / texture.numColumns) * texture.rowHeight
		local top = bottom - texture.rowHeight

		texture:SetTexCoord(left, right, top, bottom)
		texture.frame = frame
	else
		texture.throttle = texture.throttle + elapsed
	end
end

-- Overlay Glow Functions
local function OverlayGlowAnimOutFinished(self)
	local overlay = self:GetParent()
	local frame = overlay:GetParent()

	overlay:Hide()
	tinsert(lib.overlayGlow.unused, overlay)
	frame.__LBGoverlay = nil
end

local function OverlayGlow_OnHide(self)
	if self.animOut:IsPlaying() then
		self.animOut:Stop()
		OverlayGlowAnimOutFinished(self.animOut)
	end
end

local function OverlayGlow_OnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01)
--[[
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	local cooldown = self:GetParent().cooldown
	if cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000 then
		self:SetAlpha(0.5)
	else
		self:SetAlpha(1.0)
	end
--]]
end

local function AnimIn_OnPlay(self)
	local frame = self:GetRegionParent()
	local frameWidth, frameHeight = frame:GetSize()

	frame.spark:SetSize(frameWidth, frameHeight)
	frame.spark:SetAlpha(0.3)
	frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2)
	frame.innerGlow:SetAlpha(1.0)
	frame.innerGlowOver:SetAlpha(1.0)
	frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2)
	frame.outerGlow:SetAlpha(1.0)
	frame.outerGlowOver:SetAlpha(1.0)
	frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85)
	frame.ants:SetAlpha(0)
	frame:Show()
end

local function AnimIn_OnFinished(self)
	local frame = self:GetParent()
	local frameWidth, frameHeight = frame:GetSize()

	frame.spark:SetAlpha(0)
	frame.innerGlow:SetAlpha(0)
	frame.innerGlow:SetSize(frameWidth, frameHeight)
	frame.innerGlowOver:SetAlpha(0.0)
	frame.outerGlow:SetSize(frameWidth, frameHeight)
	frame.outerGlowOver:SetAlpha(0.0)
	frame.outerGlowOver:SetSize(frameWidth, frameHeight)
	frame.ants:SetAlpha(1.0)
end

local function IsAnimPlaying(self)
	return self.isPlaying
end

function lib:CreateOverlayGlow()
	lib.overlayGlow.num = lib.overlayGlow.num + 1

	local name = "ButtonGlowOverlay" .. lib.overlayGlow.num
	local overlay = CreateFrame("Frame", name, UIParent)

	overlay.spark = overlay:CreateTexture(name .. "Spark", "BACKGROUND")
	overlay.spark:SetPoint("CENTER")
	overlay.spark:SetAlpha(0)
	overlay.spark:SetTexture(lib.mediaPath .. "IconAlert")
	overlay.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125)

	overlay.innerGlow = overlay:CreateTexture(name .. "InnerGlow", "ARTWORK")
	overlay.innerGlow:SetPoint("CENTER")
	overlay.innerGlow:SetAlpha(0)
	overlay.innerGlow:SetTexture(lib.mediaPath .. "IconAlert")
	overlay.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	overlay.innerGlowOver = overlay:CreateTexture(name .. "InnerGlowOver", "ARTWORK")
	overlay.innerGlowOver:SetPoint("TOPLEFT", overlay.innerGlow, "TOPLEFT")
	overlay.innerGlowOver:SetPoint("BOTTOMRIGHT", overlay.innerGlow, "BOTTOMRIGHT")
	overlay.innerGlowOver:SetAlpha(0)
	overlay.innerGlowOver:SetTexture(lib.mediaPath .. "IconAlert")
	overlay.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

	overlay.outerGlow = overlay:CreateTexture(name .. "OuterGlow", "ARTWORK")
	overlay.outerGlow:SetPoint("CENTER")
	overlay.outerGlow:SetAlpha(0)
	overlay.outerGlow:SetTexture(lib.mediaPath .. "IconAlert")
	overlay.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375)

	overlay.outerGlowOver = overlay:CreateTexture(name .. "OuterGlowOver", "ARTWORK")
	overlay.outerGlowOver:SetPoint("TOPLEFT", overlay.outerGlow, "TOPLEFT")
	overlay.outerGlowOver:SetPoint("BOTTOMRIGHT", overlay.outerGlow, "BOTTOMRIGHT")
	overlay.outerGlowOver:SetAlpha(0)
	overlay.outerGlowOver:SetTexture(lib.mediaPath .. "IconAlert")
	overlay.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625)

	overlay.ants = overlay:CreateTexture(name .. "Ants", "OVERLAY")
	overlay.ants:SetPoint("CENTER")
	overlay.ants:SetAlpha(0)
	overlay.ants:SetTexture(lib.mediaPath .. "IconAlertAnts")

	overlay.animIn = overlay:CreateAnimationGroup()
	CreateScaleAnim(overlay.animIn, "Spark", 1, 0.2, 1.5, 1.5, nil, nil, AnimIn_OnPlay)
	CreateAlphaAnim(overlay.animIn, "Spark", 1, 0.2, 1)
	CreateScaleAnim(overlay.animIn, "InnerGlow", 1, 0.3, 2, 2)
	CreateScaleAnim(overlay.animIn, "InnerGlowOver", 1, 0.3, 2, 2)
	CreateAlphaAnim(overlay.animIn, "InnerGlowOver", 1, 0.3, -1)
	CreateScaleAnim(overlay.animIn, "OuterGlow", 1, 0.3, 0.5, 0.5)
	CreateScaleAnim(overlay.animIn, "OuterGlowOver", 1, 0.3, 0.5, 0.5)
	CreateAlphaAnim(overlay.animIn, "OuterGlowOver", 1, 0.3, -1)
	CreateScaleAnim(overlay.animIn, "Spark", 1, 0.2, 0.666666, 0.666666, 0.2)
	CreateAlphaAnim(overlay.animIn, "Spark", 1, 0.2, -1, 0.2)
	CreateAlphaAnim(overlay.animIn, "InnerGlow", 1, 0.2, -1, 0.3)
	CreateAlphaAnim(overlay.animIn, "Ants", 1, 0.2, 1, 0.3)
	overlay.animIn:SetScript("OnFinished", AnimIn_OnFinished)

	overlay.animOut = overlay:CreateAnimationGroup()
	CreateAlphaAnim(overlay.animOut, "OuterGlowOver", 1, 0.2, 1)
	CreateAlphaAnim(overlay.animOut, "Ants", 1, 0.2, -1)
	CreateAlphaAnim(overlay.animOut, "OuterGlowOver", 2, 0.2, -1)
	CreateAlphaAnim(overlay.animOut, "OuterGlow", 2, 0.2, -1)
	overlay.animOut:SetScript("OnPlay", function(self) self.isPlaying = true end)
	overlay.animOut:SetScript("OnStop", function(self) self.isPlaying = false end)
	overlay.animOut:SetScript("OnFinished", function(self) self.isPlaying = false OverlayGlowAnimOutFinished(self) end)

	overlay:SetScript("OnUpdate", OverlayGlow_OnUpdate)
	overlay:SetScript("OnHide", OverlayGlow_OnHide)

	overlay.animOut.isPlaying = false
	overlay.animOut.IsPlaying = IsAnimPlaying

	lib.callbacks:Fire("OnOverlayGlowCreated", overlay)

	return overlay
end

function lib:GetOverlayGlow()
	local overlay = tremove(lib.overlayGlow.unused)
	if not overlay then
		overlay = lib:CreateOverlayGlow()
	end
	return overlay
end

function lib:ShowOverlayGlow(frame)
	if frame.__LBGoverlay then
		if frame.__LBGoverlay.animOut:IsPlaying() then
			frame.__LBGoverlay.animOut:Stop()
			frame.__LBGoverlay.animIn:Play()
		end
	else
		local overlay = lib:GetOverlayGlow()
		local frameWidth, frameHeight = frame:GetSize()

		overlay:SetParent(frame)
		overlay:ClearAllPoints()
		-- Make the height/width available before the next frame:
		overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4)
		overlay:SetPoint("TOPLEFT", frame, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2)
		overlay:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2)
		overlay.animIn:Play()
		frame.__LBGoverlay = overlay
	end
end

function lib:HideOverlayGlow(frame)
	if frame.__LBGoverlay then
		if frame.__LBGoverlay.animIn:IsPlaying() then
			frame.__LBGoverlay.animIn:Stop()
		end

		if frame:IsVisible() then
			frame.__LBGoverlay.animOut:Play()
		else
			OverlayGlowAnimOutFinished(frame.__LBGoverlay.animOut)
		end
	end
end

-- Overlay Functions
lib.overlay.sizeScale = lib.overlay.sizeScale or 0.8
lib.overlay.longSide = 256 * lib.overlay.sizeScale
lib.overlay.shortSide = 128 * lib.overlay.sizeScale

local complexLocationTable = {
	["RIGHT (FLIPPED)"] = {
		RIGHT = {hFlip = true},
	},
	["BOTTOM (FLIPPED)"] = {
		BOTTOM = {vFlip = true},
	},
	["LEFT + RIGHT (FLIPPED)"] = {
		LEFT = {},
		RIGHT = {hFlip = true},
	},
	["TOP + BOTTOM (FLIPPED)"] = {
		TOP = {},
		BOTTOM = {vFlip = true}
	}
}

function lib:ShowAllOverlays(frame, spellID, texturePath, positions, scale, r, g, b)
	positions = upper(positions)

	if complexLocationTable[positions] then
		for location, info in pairs(complexLocationTable[positions]) do
			lib:ShowOverlay(frame, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip)
		end
	else
		lib:ShowOverlay(frame, spellID, texturePath, positions, scale, r, g, b, false, false)
	end
end

function lib:OverlayPointSize(frame, overlay, scale)
	local longSide, shortSide = lib.overlay.longSide, lib.overlay.shortSide
	local position = overlay.position
	local width, height

	overlay:ClearAllPoints()

	if position == "CENTER" then
		width, height = longSide, longSide
		overlay:SetPoint("CENTER", frame)
	elseif position == "LEFT" then
		width, height = shortSide, longSide
		overlay:SetPoint("RIGHT", frame, "LEFT")
	elseif position == "RIGHT" then
		width, height = shortSide, longSide
		overlay:SetPoint("LEFT", frame, "RIGHT")
	elseif position == "TOP" then
		width, height = longSide, shortSide
		overlay:SetPoint("BOTTOM", frame, "TOP")
	elseif position == "BOTTOM" then
		width, height = longSide, shortSide
		overlay:SetPoint("TOP", frame, "BOTTOM")
	elseif position == "TOPRIGHT" then
		width, height = shortSide, shortSide
		overlay:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT")
	elseif position == "TOPLEFT" then
		width, height = shortSide, shortSide
		overlay:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT")
	elseif position == "BOTTOMRIGHT" then
		width, height = shortSide, shortSide
		overlay:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT")
	elseif position == "BOTTOMLEFT" then
		width, height = shortSide, shortSide
		overlay:SetPoint("TOPRIGHT", frame, "BOTTOMLEFT")
	end

	overlay:SetSize(width * scale, height * scale)
end

function lib:ShowOverlay(frame, spellID, texturePath, position, scale, r, g, b, vFlip, hFlip)
	local overlay = lib:GetOverlay(frame, spellID, position)
	overlay.spellID = spellID
	overlay.position = position

	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1

	if vFlip then
		texTop, texBottom = 1, 0
	end
	if hFlip then
		texLeft, texRight = 1, 0
	end

	overlay.texture:SetTexCoord(texLeft, texRight, texTop, texBottom)

	lib:OverlayPointSize(frame, overlay, scale)

	overlay.texture:SetTexture(texturePath)
	overlay.texture:SetVertexColor(r, g, b)

	overlay.animOut:Stop()

	if not lib.disableSound then
		PlaySoundFile("Sound\\Spells\\ReputationLevelUp.wav", "SFX")
	end

	overlay:Show()
end

function lib:GetOverlay(frame, spellID, position)
	local overlayList = lib.overlay.inUse[spellID]
	local overlay

	if overlayList then
		for i = 1, #overlayList do
			if overlayList[i].position == position then
				overlay = overlayList[i]
			end
		end
	end

	if not overlay then
		overlay = lib:GetUnusedOverlay(frame)

		if overlayList then
			tinsert(overlayList, overlay)
		else
			lib.overlay.inUse[spellID] = {overlay}
		end
	end

	return overlay
end

function lib:HideOverlays(frame, spellID)
	local overlayList = lib.overlay.inUse[spellID]

	if overlayList then
		for i = 1, #overlayList do
			local overlay = overlayList[i]
			overlay.pulse:Pause()
			overlay.animOut:Play()
		end
	end
end

function lib:HideAllOverlays(frame)
	for spellID in pairs(lib.overlay.inUse) do
		lib:HideOverlays(frame, spellID)
	end
end

function lib:DisableOverlays()
	for _, overlayList in pairs(lib.overlay.inUse) do
		for _, overlay in ipairs(overlayList) do
			lib:HideAllOverlays(overlay)
		end
	end
end

function lib:GetUnusedOverlay(frame)
	local overlay = tremove(lib.overlay.unused, #lib.overlay.unused)
	if not overlay then
		overlay = lib:CreateOverlay(frame)
	end
	return overlay
end

local function Overlay_OnShow(self)
	self.animIn:Play()
end

local function OverlayTexture_OnFadeInFinished(animGroup)
	local overlay = animGroup:GetParent()
	overlay.pulse:Play()
end

local function OverlayTexture_OnFadeOutFinished(animGroup)
	local overlay = animGroup:GetParent()
	overlay.pulse:Stop()
	overlay:Hide()

	local overlayList = lib.overlay.inUse[overlay.spellID]

	for i = 1, #overlayList do
		if overlayList[i] == overlay then
			tremove(overlayList, i)
			break
		end
	end

	tinsert(lib.overlay.unused, overlay)
end

function lib:CreateOverlay(frame)
	local overlay = CreateFrame("Frame", nil, frame)
	overlay:Hide()

	overlay.animIn = overlay:CreateAnimationGroup()
	CreateBlizzAlphaAnim(overlay.animIn, 1, 0, -1)
	CreateBlizzAlphaAnim(overlay.animIn, 2, 0.2, 1)
	overlay.animIn:SetScript("OnFinished", OverlayTexture_OnFadeInFinished)

	overlay.animOut = overlay:CreateAnimationGroup()
	CreateBlizzAlphaAnim(overlay.animOut, 1, 0.1, -1)
	overlay.animOut:SetScript("OnFinished", OverlayTexture_OnFadeOutFinished)

	overlay.pulse = overlay:CreateAnimationGroup()
	overlay.pulse:SetLooping("REPEAT")

	CreateBlizzScaleAnim(overlay.pulse, 1, 0, 1, 1)
	CreateBlizzScaleAnim(overlay.pulse, 2, 0.5, 1.08, 1.08, nil, "IN_OUT")
	CreateBlizzScaleAnim(overlay.pulse, 3, 0.5, 0.9259, 0.9259, nil, "IN_OUT")

	overlay.texture = overlay:CreateTexture(nil, "ARTWORK")
	overlay.texture:SetAllPoints()

	overlay:SetScript("OnShow", Overlay_OnShow)

	lib.callbacks:Fire("OnOverlayCreated", overlay)

	return overlay
end

function lib:isEnabled()
	return lib.eventFrame:GetScript("OnEvent") and true or false
end

function lib:Enable()
	if lib.isClassSupported and not lib:isEnabled() and not (lib.disableOverlay or lib.disableButtonGlow) then
		lib.eventFrame:SetScript("OnEvent", OnEvent)

		lib.eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		lib.eventFrame:RegisterEvent("UNIT_AURA")

		if lib.ExecuteButtonSpells[lib.playerClass] then
			lib.eventFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
		end
	end
end

function lib:Disable()
	lib.eventFrame:SetScript("OnEvent", nil)
	lib.eventFrame:UnregisterAllEvents()
	twipe(buffs)
end