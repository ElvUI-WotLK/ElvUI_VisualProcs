local addOnName = ...;
local E, L, V, P, G = unpack(ElvUI);
local EP = LibStub("LibElvUIPlugin-1.0");
local addon = E:NewModule("Cheese");

P.cheese = {
	overlay = {
		enable = true,
		scale = 0.3,
	},
	overlayGlow = {
		enable = true,
	},
};

local function GetOptions()
	E.Options.args.general.args.general.args.overlay = {
		order = 100,
		type = "toggle",
		name = L["Overlay Frame"],
		get = function(info) return E.db.cheese.overlay.enable; end,
		set = function(info, value) E.db.cheese.overlay.enable = value; addon:UpdateOverlay(); end
	};
	E.Options.args.general.args.general.args.overlayScale = {
		order = 101,
		type = "range",
		name = L["Overlay Frame Scale"],
		min = 0.1, max = 2, step = 0.01,
		get = function(info) return E.db.cheese.overlay.scale; end,
		set = function(info, value) E.db.cheese.overlay.scale = value; addon:UpdateOverlay(); end
	};
	E.Options.args.general.args.general.args.overlayGlow = {
		order = 102,
		type = "toggle",
		name = L["Overlay Glow Frame"]
	};
end

local LAB = LibStub("LibActionButton-1.0");
local LBG = LibStub("LibButtonGlow-1.0", true);

local function OverlayGlowShow(self, arg1)
	if(self:GetSpellId() == arg1) then
		LBG:ShowOverlayGlow(self);
	end
end

local function OverlayGlowHide(self, arg1)
	if(self:GetSpellId() == arg1) then
		LBG:HideOverlayGlow(self);
	end
end

local function UpdateOverlayGlow(self)
	if(self:HasAction()) then
		if(not self.eventsRegistered) then
			LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self, OverlayGlowShow);
			LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self, OverlayGlowHide);
			self.eventsRegistered = true;
		end
	else
		if(self.eventsRegistered) then
			LBG:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self);
			LBG:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self);
			self.eventsRegistered = nil;
		end
	end

	local spellId = self:GetSpellId();
	if(spellId and LBG:IsSpellOverlayed(spellId)) then
		LBG:ShowOverlayGlow(self);
	else
		LBG:HideOverlayGlow(self);
	end
end

local function OnUpdate(self)
	local spellId = self:GetSpellId();
	if(spellId) then
		LBG:SetAction(self:GetAction(), spellId);
	end
	self:SetScript("OnUpdate", nil);
end

local function OnButtonCreated(_, button)
	button:SetScript("OnUpdate", OnUpdate);
end

local function OnButtonContentsChanged(_, button, state, value)
	if(state == "action") then
		local spellId = button:GetSpellId();
		if(spellId) then
			LBG:ChangeAction(value, spellId);
		end
	end
end

local function OnButtonUpdate(event, button)
	UpdateOverlayGlow(button);
end

-- Overlay Glow
LAB.RegisterCallback(LBG, "OnButtonCreated", OnButtonCreated);
LAB.RegisterCallback(LBG, "OnButtonContentsChanged", OnButtonContentsChanged);
LAB.RegisterCallback(LBG, "OnButtonUpdate", OnButtonUpdate);

-- Overlay
local function OverlayShow(self, spellID, texture, positions, scale, r, g, b)
	LBG:ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b);
end

local function OverlayHide(self, spellID)
	if(spellID) then
		LBG:HideOverlays(self, spellID);
	else
		LBG:HideAllOverlays(self);
	end
end

function addon:UpdateOverlay()
	if(E.db.cheese.overlay.enable) then
		LBG.overlay.sizeScale = E.db.cheese.overlay.scale;
		LBG.overlay.longSide = 256 * E.db.cheese.overlay.scale;
		LBG.overlay.shortSide = 128 * E.db.cheese.overlay.scale;

		LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", LBG.overlayFrame, OverlayShow);
		LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", LBG.overlayFrame, OverlayHide);
	else
		LBG:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", LBG.overlayFrame);
		LBG:UnregisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", LBG.overlayFrame);
	end
end

function addon:Initialize()
	self:UpdateOverlay();

	EP:RegisterPlugin(addOnName, GetOptions);
end

E:RegisterModule(addon:GetName());