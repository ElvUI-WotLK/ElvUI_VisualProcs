local E, L, V, P, G = unpack(ElvUI)
local LBP = LibStub("LibBlizzardProcs-1.0", true)
local LAB = LibStub("LibActionButton-1.0")
local EP = LibStub("LibElvUIPlugin-1.0")
local VP = E:NewModule("ElvUI_VisualProcs")

local AddOnName = ...

P.visualProcs = {
	overlay = {
		enable = true,
		scale = 0.8,
	},
	buttonGlow = {
		enable = true,
	},
}

local function GetOptions()
	E.Options.args.PinyaProfiles = {
		order = -20,
		type = "group",
		childGroups = "select",
		name = "VisualProcs",
		args = {
			buttonGlow = {
				order = 1,
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
				order = 2,
				type = "toggle",
				name = L["Overlay Frame"],
				get = function(info) return E.db.visualProcs.overlay.enable end,
				set = function(info, value)
					E.db.visualProcs.overlay.enable = value
					VP:ToggleOverlay()
				end,
				disabled = function() return not LBP.isClassSupported end,
			}
		}
	}
end

local function OverlayGlowShow(self, spellID)
	if (self:GetSpellId() == spellID) then
		LBP:ShowOverlayGlow(self)
	end
end

local function OverlayGlowHide(self, spellID)
	if (self:GetSpellId() == spellID) then
		LBP:HideOverlayGlow(self)
	end
end

local function UpdateOverlayGlow(self)
	local spellID = self:GetSpellId()

	if (self:HasAction()) then
		if (not self.eventsRegistered) then
			LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self, OverlayGlowShow)
			LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self, OverlayGlowHide)
			self.eventsRegistered = true
		end

		if (spellID) then
			LBP:ChangeAction(self._state_action, spellID);
		end
	else
		if (self.eventsRegistered) then
			LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self)
			LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self)
			self.eventsRegistered = nil
		end
	end

	if (spellID and LBP:IsSpellOverlayed(spellID)) then
		LBP:ShowOverlayGlow(self)
	else
		LBP:HideOverlayGlow(self)
	end
end

local function OverlayShow(self, spellID, texture, positions, scale, r, g, b)
	LBP:ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b)
end

local function OverlayHide(self, spellID)
	if (spellID) then
		LBP:HideOverlays(self, spellID)
	else
		LBP:HideAllOverlays(self)
	end
end

function VP:ToggleButtonGlow()
	if not LBP.isClassSupported then return end

	LBP.disableButtonGlow = not (E.private.actionbar.enable and E.db.visualProcs.buttonGlow.enable)

	if (E.private.actionbar.enable and E.db.visualProcs.buttonGlow.enable) then
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
end

function VP:ToggleOverlay()
	if not LBP.isClassSupported then return end

	LBP.disableOverlay = not E.db.visualProcs.overlay.enable

	if (E.db.visualProcs.overlay.enable) then
		LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", self.overlayFrame, OverlayShow)
		LBP:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", self.overlayFrame, OverlayHide)
		self.overlayFrame:Show()
	else
		LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", self.overlayFrame)
		LBP:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", self.overlayFrame)

		LBP:DisableOverlays()
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

	self:ToggleButtonGlow()
	self:UpdateOverlay()
	self:ToggleOverlay()

	EP:RegisterPlugin(AddOnName, GetOptions)
end

E:RegisterModule(VP:GetName())