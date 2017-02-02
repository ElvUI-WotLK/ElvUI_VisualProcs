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
		local spellId = button:GetSpellId(); -- Берем кнопку только с spellId
		if(spellId) then
			LBG:ChangeAction(value, spellId);
		end
	end
end

local function OnButtonUpdate(event, button)
	UpdateOverlayGlow(button);
end

local isBlizzard = false;

if(isBlizzard) then
	
else
	LAB.RegisterCallback(LBG, "OnButtonCreated", OnButtonCreated);
	LAB.RegisterCallback(LBG, "OnButtonContentsChanged", OnButtonContentsChanged);
	LAB.RegisterCallback(LBG, "OnButtonUpdate", OnButtonUpdate);
end