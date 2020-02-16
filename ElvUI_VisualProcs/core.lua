local E, L, V, P, G = unpack(ElvUI)

local LBP = LibStub("LibBlizzardProcs-1.0", true)
local LAB = LibStub("LibActionButton-1.0-ElvUI")
local EP = LibStub("LibElvUIPlugin-1.0")
local VP = E:NewModule("VisualProcs", "AceEvent-3.0")

local AddOnName = ...

local find = string.find
local pairs, ipairs = pairs, ipairs

P.visualProcs = {
	overlay = {
		enable = true,
		scale = 0.8,
		disableSound = false,
	},
	buttonGlow = {
		enable = true,
	},
}

local function GetOptions()
	E.Options.args.visualProcs = {
		order = 50,
		type = "group",
		childGroups = "select",
		name = "|cff0070ddVisual Procs|r",
		args = {
			overlayTest = {
				order = 1,
				type = "execute",
				name = L["Show/Hide Overlay"],
				func = function(info) VP:ToggleTestFrame() end,
				disabled = function() return not (LBP.isClassSupported and E.db.visualProcs.overlay.enable) end,
			},
			spacer = {
				order = 2,
				type = "description",
				width = "full",
				name = "",
			},
			buttonGlow = {
				order = 3,
				type = "toggle",
				name = L["Button Glow"],
				get = function(info) return E.db.visualProcs.buttonGlow.enable end,
				set = function(info, value)
					E.db.visualProcs.buttonGlow.enable = value
					VP:ToggleButtonGlow()
				end,
				disabled = function() return not LBP.isClassSupported end,
			},
			overlay = {
				order = 4,
				type = "toggle",
				name = L["Overlay Frame"],
				get = function(info) return E.db.visualProcs.overlay.enable end,
				set = function(info, value)
					E.db.visualProcs.overlay.enable = value
					VP:ToggleOverlay()
				end,
				disabled = function() return not LBP.isClassSupported end,
			},
			overlayScale = {
				order = 5,
				type = "range",
				min = 0.1, max = 2, step = 0.01,
				name = L["Overlay Frame Scale"],
				get = function(info) return E.db.visualProcs.overlay.scale end,
				set = function(info, value)
					E.db.visualProcs.overlay.scale = value
					VP:UpdateOverlay()
				end,
				disabled = function() return not (LBP.isClassSupported and E.db.visualProcs.overlay.enable) end,
			},
			disableSound = {
				order = 6,
				type = "toggle",
				name = L["Disable Sound"],
				desc = L["Disable playing sound on overlay proc."],
				get = function(info) return E.db.visualProcs.overlay.disableSound end,
				set = function(info, value)
					E.db.visualProcs.overlay.disableSound = value
					VP:UpdateSettings()
				end,
				disabled = function() return not (LBP.isClassSupported and E.db.visualProcs.overlay.enable) end,
			}
		}
	}
end

local function OverlayGlowShow(self, spellID)
	if self:GetSpellId() == spellID then
		LBP:ShowOverlayGlow(self)
	end
end

local function OverlayGlowHide(self, spellID)
	if self:GetSpellId() == spellID then
		LBP:HideOverlayGlow(self)
	end
end

local function UpdateOverlayGlow(self)
	local spellID = self:GetSpellId()

	if self:HasAction() then
		if not self.eventsRegistered then
			LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self, OverlayGlowShow)
			LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self, OverlayGlowHide)
			self.eventsRegistered = true
		end

		if spellID then
			LBP:ChangeAction(self._state_action, spellID)
		end
	else
		if self.eventsRegistered then
			LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self)
			LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self)
			self.eventsRegistered = nil
		end
	end

	if spellID and LBP:IsSpellOverlayed(spellID) then
		LBP:ShowOverlayGlow(self)
	else
		LBP:HideOverlayGlow(self)
	end
end

local function OverlayShow(self, spellID, texture, positions, scale, r, g, b)
	LBP:ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
end

local function OverlayHide(self, spellID)
	if spellID then
		LBP:HideOverlays(self, spellID)
	else
		LBP:HideAllOverlays(self)
	end
end

function VP:ToggleTestFrame()
	self.overlayFrame.test = not self.overlayFrame.test

	if self.overlayFrame.test then
		LBP:HideAllOverlays(self.overlayFrame)

		local path = LBP.mediaPath .. "overlay\\"
		local foundTop, foundLeft

		for _, data in ipairs(LBP_Data.OverlayTextures[LBP.playerClass]) do
			if not foundTop and find(data[3], "Top") then
				foundTop = true
				LBP:ShowAllOverlays(self.overlayFrame, 100000, path .. data[2], data[3], data[4], data[5], data[6], data[7])
			elseif not foundLeft and find(data[3], "Left") then
				foundLeft = true
				LBP:ShowAllOverlays(self.overlayFrame, 100001, path .. data[2], data[3], data[4], data[5], data[6], data[7])
			end

			if foundTop and foundLeft then
				break
			end
		end

		self:RegisterEvent("PLAYER_REGEN_DISABLED", "ToggleTestFrame")
	else
		LBP:HideAllOverlays(self.overlayFrame)
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
	end
end

function VP:ToggleButtonGlow()
	if not LBP.isClassSupported then return end

	LBP.disableButtonGlow = not (E.private.actionbar.enable and E.db.visualProcs.buttonGlow.enable)

	if E.private.actionbar.enable and E.db.visualProcs.buttonGlow.enable then
		LAB.RegisterCallback(LBP, "OnButtonUpdate", function(_, button)
			UpdateOverlayGlow(button)
		end)
	else
		LAB.UnregisterCallback(LBP, "OnButtonUpdate")

		LBP:DisableButtonGlows()
	end

	self:UpdateState()
end

function VP:UpdateOverlay()
	if not LBP.isClassSupported then return end

	local scale = E.db.visualProcs.overlay.scale

	LBP.overlay.sizeScale = scale
	LBP.overlay.longSide = 256 * scale
	LBP.overlay.shortSide = 128 * scale

	self.overlayFrame:SetSize(256 * scale, 256 * scale)

	for _, overlayList in pairs(LBP.overlay.inUse) do
		if overlayList then
			for i = 1, #overlayList do
				LBP:OverlayPointSize(self.overlayFrame, overlayList[i], 1)
			end
		end
	end
end

function VP:UpdateSettings()
	if not LBP.isClassSupported then return end

	LBP.disableSound = E.db.visualProcs.overlay.disableSound
end

function VP:ToggleOverlay()
	if not LBP.isClassSupported then return end

	LBP.disableOverlay = not E.db.visualProcs.overlay.enable

	if E.db.visualProcs.overlay.enable then
		LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", self.overlayFrame, OverlayShow)
		LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", self.overlayFrame, OverlayHide)
		self.overlayFrame:Show()
	else
		LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", self.overlayFrame)
		LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", self.overlayFrame)

		LBP:DisableOverlays()
		self:UnregisterAllEvents()
		self.overlayFrame.test = false
		self.overlayFrame:Hide()
	end

	self:UpdateState()
end

function VP:UpdateState()
	if LBP.disableOverlay and LBP.disableButtonGlow then
		if LBP:isEnabled() then
			LBP:Disable()
		end
	else
		if not LBP:isEnabled() then
			LBP:Enable()
		end
	end
end

function VP:Initialize()
	LBP.mediaPath = "Interface\\AddOns\\ElvUI_VisualProcs\\LibBlizzardProcs\\textures\\"

	self.overlayFrame = CreateFrame("Frame", "ElvUI_VisualProcsOverlay", UIParent)
	self.overlayFrame:Point("CENTER")

	self:UpdateSettings()
	self:ToggleButtonGlow()
	self:UpdateOverlay()
	self:ToggleOverlay()

	EP:RegisterPlugin(AddOnName, GetOptions)
end

local function InitializeCallback()
	VP:Initialize()
end

E:RegisterModule(VP:GetName(), InitializeCallback)