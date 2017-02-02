local E, L, V, P, G = unpack(ElvUI);
local addon = E:NewModule("Cheese", "AceHook-3.0", "AceEvent-3.0");

local LAB = LibStub("LibActionButton-1.0");
local LBG = LibStub("LibButtonGlow-1.0", true);

function UpdateOverlayGlow(self)
	--if(not self._state_action) then return; end

	if(self:HasAction()) then
		if(not self.eventsRegistered) then
			LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self, OnEventOverlayGlowShow);
			LBG:RegisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self, OnEventOverlayGlowHide);
			self.eventsRegistered = true;
		end
	else
		if(self.eventsRegistered) then
			LBG.UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_SHOW", self);
			LBG.UnregisterEvent("SPELL_ACTIVATION_OVERLAY_GLOW_HIDE", self);
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

function OnEventOverlayGlowShow(self, arg1)
	if(self:GetSpellId() == arg1) then
		LBG:ShowOverlayGlow(self);
	end
end

function OnEventOverlayGlowHide(self, arg1)
	if(self:GetSpellId() == arg1) then
		LBG:HideOverlayGlow(self);
	end
end

local function OnButtonContentsChanged(self, arg1, state, arg3, arg4)
	if(state == "action") then
		
	end
end

local function OnButtonUpdate(self, button)
	--if(button._state_type ~= "action") then return; end

	LBG.ChangeAction(button._state_action, button:GetSpellId());

	UpdateOverlayGlow(button);
end

local isBlizzard = false;

function addon:Initialize()
	if(isBlizzard) then
		
	else
		LAB.RegisterCallback(addon, "OnButtonContentsChanged", OnButtonContentsChanged);
		LAB.RegisterCallback(addon, "OnButtonUpdate", OnButtonUpdate);
	end
end

E:RegisterModule(addon:GetName())