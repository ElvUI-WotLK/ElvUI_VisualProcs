local MAJOR_VERSION, MINOR_VERSION = "LibButtonGlow-1.0", 1;

local lib, oldversion = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION);
if(not lib) then return end -- No upgrade needed

-- Lua APIs
local _G = _G;
local pairs, next, tostring = pairs, next, tostring;
local tinsert, tremove = table.insert, table.remove;
local floor, ceil = math.floor, math.ceil;
local band, lshift, rshift = bit.band, bit.lshift, bit.rshift;

-- WoW APIs
local CreateFrame = CreateFrame;
local PlayerFrame = PlayerFrame;
local UnitBuff = UnitBuff;

local CBH = LibStub("CallbackHandler-1.0");

lib.eventFrame = lib.eventFrame or CreateFrame("Frame");

lib.callbacks = lib.callbacks or CBH:New(lib);

lib.mediaPath = lib.mediaPath or "Interface\\AddOns\\ElvUI_Cheese\\Textures\\";

lib.overlayShow = {};
lib.overlayHide = {};
lib.overlayGlowShow = {};
lib.overlayGlowHide = {};

lib.event = {
	["SPELL_ACTIVATION_OVERLAY_SHOW"] = lib.overlayShow,
	["SPELL_ACTIVATION_OVERLAY_HIDE"] = lib.overlayHide,
	["SPELL_ACTIVATION_OVERLAY_GLOW_SHOW"] = lib.overlayGlowShow,
	["SPELL_ACTIVATION_OVERLAY_GLOW_HIDE"] = lib.overlayGlowHide,
};

-- Overlay
lib.overlay = lib.overlay or {};
lib.overlay.inUse = lib.overlay.inUse or {};
lib.overlay.unused = lib.overlay.unused or {};

-- Overlay Glow
lib.overlayGlow = lib.overlayGlow or {};
lib.overlayGlow.unused = lib.overlayGlow.unused or {};
lib.overlayGlow.num = lib.overlayGlow.num or 0;

local actionButtons = {};

local buffGlowSpells = {};
local buffs = {};
local spellsOverlayed = {};

local function AddOverlayGlow(spellId)
	local overlayedCount = spellsOverlayed[spellId];
	if(not overlayedCount) then
		spellsOverlayed[spellId] = 1;

		for frame, func in pairs(lib.overlayGlowShow) do
			func(frame, spellId);
		end
	else
		spellsOverlayed[spellId] = overlayedCount + 1;
	end
end

local function RemoveOverlayGlow(spellId)
	local overlayedCount = spellsOverlayed[spellId];
	if(overlayedCount == 1) then
		spellsOverlayed[spellId] = nil;

		for frame, func in pairs(lib.overlayGlowHide) do
			func(frame, spellId);
		end
	else
		spellsOverlayed[spellId] = overlayedCount - 1;
	end
end

function lib:SetAction(action, globalID)
	actionButtons[action] = globalID;
	if(globalID) then
		local glowSpellK = GetOverlayGlowSpellMap()[globalID];
		if(glowSpellK) then
			local overlayGlowSpellTable = GetOverlayGlowSpellTable();
			local spellID = overlayGlowSpellTable[glowSpellK];
			repeat
				local glowSpells = buffGlowSpells[spellID];
				if(not glowSpells) then
					buffGlowSpells[spellID] = {
						[globalID] = 1;
					};
					if(buffs[spellID]) then
						AddOverlayGlow(globalID);
					end
				else
					local refCount = glowSpells[globalID];
					if(not refCount) then
						glowSpells[globalID] = 1;
						if(buffs[spellID]) then
							AddOverlayGlow(globalID);
						end
					else
						glowSpells[globalID] = refCount + 1;
					end
				end
				glowSpellK = glowSpellK + 1;
				spellID = overlayGlowSpellTable[glowSpellK];
			until(not spellID);
		end
	end
end

function lib:ChangeAction(action, newGlobalID)
	local globalID = actionButtons[action];
	if(globalID) then
		local glowSpellK = GetOverlayGlowSpellMap()[globalID];
		if(glowSpellK) then
			local overlayGlowSpellTable = GetOverlayGlowSpellTable();
			local spellID = overlayGlowSpellTable[glowSpellK];
			repeat
				local glowSpells = buffGlowSpells[spellID];
				local refCount = glowSpells[globalID];
				if(refCount == 1) then
					glowSpells[globalID] = nil;
					if(next(glowSpells) == nil) then
						glowSpells = nil;
						buffGlowSpells[spellID] = nil;
					end
					if(buffs[spellID]) then
						RemoveOverlayGlow(globalID);
					end
				else
					glowSpells[globalID] = refCount - 1;
				end
				glowSpellK = glowSpellK + 1;
				spellID = overlayGlowSpellTable[glowSpellK];
			until(not spellID);
		end
	end
	lib:SetAction(action, newGlobalID);
end

local function BuffGained(spellID, k, overlayTable)
	if(k < OVERLAYS_UPPER_BOUND) then
		local texture = lib.mediaPath .. overlayTable[k + 1];
		local positions = overlayTable[k + 2];
		local scale = overlayTable[k + 3];
		local vertexColor = overlayTable[k + 4];
		local r = rshift(lshift(vertexColor, 8), 24);
		local g = rshift(lshift(vertexColor, 16), 24);
		local b = band(vertexColor, 0xff);

		for frame, func in pairs(lib.overlayShow) do
			func(frame, spellID, texture, positions, scale, r, g, b);
		end
	end

	local glowSpells = buffGlowSpells[spellID];
	if(glowSpells) then
		for globalID in pairs(glowSpells) do
			AddOverlayGlow(globalID);
		end
	end
end

local function BuffLost(spellID)
	for frame, func in pairs(lib.overlayHide) do
		func(frame, spellID);
	end

	local glowSpells = buffGlowSpells[spellID];
	if(glowSpells) then
		for globalID in pairs(glowSpells) do
			RemoveOverlayGlow(globalID);
		end
	end
end

function lib.OnEvent(_, event, unitID)
	local unit = PlayerFrame.unit;
	if(unitID == unit) then
		local name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, 1);
		if(name) then
			local overlayMap = GetOverlayMap();
			local overlayTable;
			local j = 1;
			repeat
				local k = overlayMap[spellID];
				if(k) then
					if(not overlayTable) then
						overlayTable = GetOverlayTable();
					end
					if(not (count < overlayTable[k])) then
						local hasBuff = buffs[spellID];
						buffs[spellID] = false;
						if(hasBuff == nil) then
							BuffGained(spellID, k, overlayTable);
						end
					end
				end
				j = j + 1;
				name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
			until(not name);
		end

		for spellID, hasBuff in pairs(buffs) do
			if(not hasBuff) then
				buffs[spellID] = true;
			else
				buffs[spellID] = nil;
				BuffLost(spellID);
			end
		end
	end
end

function lib:IsSpellOverlayed(spellID)
	return spellsOverlayed[spellID] and true or false;
end

function lib:RegisterEvent(event, frame, func)
	local isEvent = lib.event[event];
	if(isEvent) then
		isEvent[frame] = func;
	end
end

function lib:UnregisterEvent(event, frame)
	local isEvent = lib.event[event];
	if(isEvent) then
		isEvent[frame] = nil;
	end
end

function lib:IsEventRegistered(event, frame)
	local isEvent = lib.event[event];
	if(isEvent and isEvent[frame]) then
		return true;
	end
	return false;
end

-- Animation Functions
local function InitAlphaAnimation(self)
	local target = self.target;
	if(not target) then
		target = self:GetRegionParent();
		self.target = target;
	end
	local change = self.change;
	if(not change) then
		change = 0;
		self.change = change;
	end
	local frameAlpha = target:GetAlpha();
	self.frameAlpha = frameAlpha;
	self.alphaFactor = frameAlpha + change - frameAlpha;
end

local function TidyAlphaAnimation(self)
	self.alphaFactor = nil;
	self.frameAlpha = nil;
end

local function AlphaAnimation_OnUpdate(self, elapsed)
	local progress = self:GetSmoothProgress();
	if(progress ~= 0) then
		if(not self.played) then
			InitAlphaAnimation(self);
			self.played = 1;
		end
		local frameAlpha = self.frameAlpha;
		if(frameAlpha) then
			self.target:SetAlpha(frameAlpha + self.alphaFactor * progress);
			if(progress == 1) then
				TidyAlphaAnimation(self);
			end
		end
	end
end

local function AlphaAnimation_OnStop(self)
	if(self.frameAlpha) then
		TidyAlphaAnimation(self);
	end
	self.played = nil;
end

local AlphaAnimation_OnFinished = AlphaAnimation_OnStop;

local function CreateAlphaAnim(group, target, order, duration, change, delay, onPlay, onFinished)
	local alpha = group:CreateAnimation();
	if(target) then
		alpha.target = _G[alpha:GetRegionParent():GetName() .. target];
	end
	if(order) then
		alpha:SetOrder(order);
	end
	alpha:SetDuration(duration);
	alpha.change = change;

	if(delay) then
		alpha:SetStartDelay(delay);
	end

	if(onPlay) then
		alpha:SetScript("OnPlay", onPlay);
	end
	alpha:SetScript("OnUpdate", AlphaAnimation_OnUpdate);
	alpha:SetScript("OnStop", AlphaAnimation_OnStop);
	alpha:SetScript("OnFinished", onFinished or AlphaAnimation_OnFinished);
end

local function InitScaleAnimation(self)
	local target = self.target;
	if(not target) then
		target = self:GetRegionParent();
		self.target = target;
	end
	local scaleX = self.scaleX;
	if(not scaleX) then
		scaleX = 0;
		self.scaleX = scaleX;
	end
	local scaleY = self.scaleY;
	if(not scaleY) then
		scaleY = 0;
		self.scaleY = scaleY;
	end
	local _, _, width, height = target:GetRect();
	if(not width) then
		return nil;
	end
	self.frameWidth, self.frameHeight = width, height;
	self.widthFactor, self.heightFactor = width * scaleX - width, height * scaleY - height;
	local parent = target:GetParent();
	local setCenter;
	local numPoints = target:GetNumPoints();
	if(1 <= numPoints) then
		local point, relativeTo, relativePoint, xOffset, yOffset = target:GetPoint(1);
		if(numPoints == 1 and point == "CENTER") then
			setCenter = false;
		else
			local i = 1;
			while true do
				if(relativeTo ~= parent and yOffset ~= nil) then
					local k = #self + 1;
					self[k], self[k + 1], self[k + 2], self[k + 3], self[k + 4] = point, relativeTo, relativePoint, xOffset, yOffset;
				end
				i = i + 1;
				if(i <= numPoints) then
					point, relativeTo, relativePoint, xOffset, yOffset = target:GetPoint(i);
				else
					break;
				end
			end
			target:ClearAllPoints();
			setCenter = true;
		end
	else
		setCenter = true;
	end
	if(setCenter) then
		local x, y = target:GetCenter();
		local parentX, parentY = parent:GetCenter();
		target:SetPoint("CENTER", x - parentX, y - parentY);
	end
	return 1;
end

local function TidyScaleAnimation(self)
	local target = self.target;
	if(#self ~= 0) then
		target:ClearAllPoints();
		for i = 1, #self, 5 do
			target:SetPoint(self[i], self[i + 1], self[i + 2], self[i + 3], self[i + 4]);
			self[i], self[i + 1], self[i + 2], self[i + 3], self[i + 4] = nil;
		end
	end
	self.widthFactor, self.heightFactor = nil;
	self.frameWidth, self.frameHeight = nil;
end

local function ScaleAnimation_OnUpdate(self, elapsed)
	local progress = self:GetSmoothProgress();
	if(progress ~= 0) then
		if(not self.played) then
			if(InitScaleAnimation(self)) then
				self.played = 1;
			end
		end
		local frameWidth = self.frameWidth;
		if(frameWidth) then
			self.target:SetSize(frameWidth + self.widthFactor * progress, self.frameHeight + self.heightFactor * progress);
			if(progress == 1) then
				TidyScaleAnimation(self);
			end
		end
	end
end

local function ScaleAnimation_OnStop(self)
	if(self.frameWidth) then
		TidyScaleAnimation(self);
	end
	self.played = nil;
end

local ScaleAnimation_OnFinished = ScaleAnimation_OnStop;

local function CreateScaleAnim(group, target, order, duration, x, y, delay, smoothing, onPlay)
	local scale = group:CreateAnimation();
	if(target) then
		scale.target = _G[scale:GetRegionParent():GetName() .. target];
	end
	scale:SetOrder(order);
	scale:SetDuration(duration);
	scale.scaleX, scale.scaleY = x, y;

	if(delay) then
		scale:SetStartDelay(delay);
	end

	if(smoothing) then
		scale:SetSmoothing(smoothing);
	end

	if(onPlay) then
		scale:SetScript("OnPlay", onPlay);
	end
	scale:SetScript("OnUpdate", ScaleAnimation_OnUpdate);
	scale:SetScript("OnStop", ScaleAnimation_OnStop);
	scale:SetScript("OnFinished", ScaleAnimation_OnFinished);
end

local function AnimateTexCoords(texture, textureWidth, textureHeight, frameWidth, frameHeight, numFrames, elapsed, throttle)
	if(not texture.frame) then
		texture.frame = 1;
		texture.throttle = throttle;
		texture.numColumns = floor(textureWidth / frameWidth);
		texture.numRows = floor(textureHeight / frameHeight);
		texture.columnWidth = frameWidth / textureWidth;
		texture.rowHeight = frameHeight / textureHeight;
	end
	local frame = texture.frame;
	if(not texture.throttle or texture.throttle > throttle) then
		local framesToAdvance = floor(texture.throttle / throttle);
		while(frame + framesToAdvance > numFrames) do
			frame = frame - numFrames;
		end
		frame = frame + framesToAdvance;
		texture.throttle = 0;
		local left = mod(frame - 1, texture.numColumns) * texture.columnWidth;
		local right = left + texture.columnWidth;
		local bottom = ceil(frame / texture.numColumns) * texture.rowHeight;
		local top = bottom - texture.rowHeight;
		texture:SetTexCoord(left, right, top, bottom);

		texture.frame = frame;
	else
		texture.throttle = texture.throttle + elapsed;
	end
end

-- Overlay Glow Functions
local function OverlayGlowAnimOutFinished(self)
	local overlay = self:GetParent();
	local frame = overlay:GetParent();
	overlay:Hide();
	tinsert(lib.overlayGlow.unused, overlay);
	frame.__LBGoverlay = nil;
end

local function OverlayGlow_OnHide(self)
	if(self.animOut:IsPlaying()) then
		self.animOut:Stop();
		OverlayGlowAnimOutFinished(self.animOut);
	end
end

local function OverlayGlow_OnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
end

local function AnimIn_OnPlay(self)
	local frame = self:GetRegionParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetSize(frameWidth, frameHeight);
	frame.spark:SetAlpha(0.3);
	frame.innerGlow:SetSize(frameWidth / 2, frameHeight / 2);
	frame.innerGlow:SetAlpha(1.0);
	frame.innerGlowOver:SetAlpha(1.0);
	frame.outerGlow:SetSize(frameWidth * 2, frameHeight * 2);
	frame.outerGlow:SetAlpha(1.0);
	frame.outerGlowOver:SetAlpha(1.0);
	frame.ants:SetSize(frameWidth * 0.85, frameHeight * 0.85);
	frame.ants:SetAlpha(0);
	frame:Show();
end

local function AnimIn_OnFinished(self)
	local frame = self:GetParent();
	local frameWidth, frameHeight = frame:GetSize();
	frame.spark:SetAlpha(0);
	frame.innerGlow:SetAlpha(0);
	frame.innerGlow:SetSize(frameWidth, frameHeight);
	frame.innerGlowOver:SetAlpha(0.0);
	frame.outerGlow:SetSize(frameWidth, frameHeight);
	frame.outerGlowOver:SetAlpha(0.0);
	frame.outerGlowOver:SetSize(frameWidth, frameHeight);
	frame.ants:SetAlpha(1.0);
end

local function IsAnimPlaying(self)
	return self.isPlaying;
end

function lib:CreateOverlayGlow()
	lib.overlayGlow.num = lib.overlayGlow.num + 1;

	local name = "ButtonGlowOverlay" .. tostring(lib.overlayGlow.num);
	local overlay = CreateFrame("Frame", name, UIParent);

	overlay.spark = overlay:CreateTexture(name .. "Spark", "BACKGROUND");
	overlay.spark:SetPoint("CENTER");
	overlay.spark:SetAlpha(0);
	overlay.spark:SetTexture(lib.mediaPath .. "IconAlert");
	overlay.spark:SetTexCoord(0.00781250, 0.61718750, 0.00390625, 0.26953125);

	overlay.innerGlow = overlay:CreateTexture(name .. "InnerGlow", "ARTWORK");
	overlay.innerGlow:SetPoint("CENTER");
	overlay.innerGlow:SetAlpha(0);
	overlay.innerGlow:SetTexture(lib.mediaPath .. "IconAlert");
	overlay.innerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375);

	overlay.innerGlowOver = overlay:CreateTexture(name .. "InnerGlowOver", "ARTWORK");
	overlay.innerGlowOver:SetPoint("TOPLEFT", overlay.innerGlow, "TOPLEFT");
	overlay.innerGlowOver:SetPoint("BOTTOMRIGHT", overlay.innerGlow, "BOTTOMRIGHT");
	overlay.innerGlowOver:SetAlpha(0);
	overlay.innerGlowOver:SetTexture(lib.mediaPath .. "IconAlert");
	overlay.innerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625);

	overlay.outerGlow = overlay:CreateTexture(name .. "OuterGlow", "ARTWORK");
	overlay.outerGlow:SetPoint("CENTER");
	overlay.outerGlow:SetAlpha(0);
	overlay.outerGlow:SetTexture(lib.mediaPath .. "IconAlert");
	overlay.outerGlow:SetTexCoord(0.00781250, 0.50781250, 0.27734375, 0.52734375);

	overlay.outerGlowOver = overlay:CreateTexture(name .. "OuterGlowOver", "ARTWORK");
	overlay.outerGlowOver:SetPoint("TOPLEFT", overlay.outerGlow, "TOPLEFT");
	overlay.outerGlowOver:SetPoint("BOTTOMRIGHT", overlay.outerGlow, "BOTTOMRIGHT");
	overlay.outerGlowOver:SetAlpha(0);
	overlay.outerGlowOver:SetTexture(lib.mediaPath .. "IconAlert");
	overlay.outerGlowOver:SetTexCoord(0.00781250, 0.50781250, 0.53515625, 0.78515625);

	overlay.ants = overlay:CreateTexture(name .. "Ants", "OVERLAY");
	overlay.ants:SetPoint("CENTER");
	overlay.ants:SetAlpha(0);
	overlay.ants:SetTexture(lib.mediaPath .. "IconAlertAnts");

	overlay.animIn = overlay:CreateAnimationGroup();
	CreateScaleAnim(overlay.animIn, "Spark", 1, 0.2, 1.5, 1.5, nil, nil, AnimIn_OnPlay);
	CreateAlphaAnim(overlay.animIn, "Spark", 1, 0.2, 1);
	CreateScaleAnim(overlay.animIn, "InnerGlow", 1, 0.3, 2, 2);
	CreateScaleAnim(overlay.animIn, "InnerGlowOver", 1, 0.3, 2, 2);
	CreateAlphaAnim(overlay.animIn, "InnerGlowOver", 1, 0.3, -1);
	CreateScaleAnim(overlay.animIn, "OuterGlow", 1, 0.3, 0.5, 0.5);
	CreateScaleAnim(overlay.animIn, "OuterGlowOver", 1, 0.3, 0.5, 0.5);
	CreateAlphaAnim(overlay.animIn, "OuterGlowOver",  1, 0.3, -1)
	CreateScaleAnim(overlay.animIn, "Spark", 1, 0.2, 0.666666, 0.666666, 0.2);
	CreateAlphaAnim(overlay.animIn, "Spark", 1, 0.2, -1, 0.2);
	CreateAlphaAnim(overlay.animIn, "InnerGlow", 1, 0.2, -1, 0.3);
	CreateAlphaAnim(overlay.animIn, "Ants", 1, 0.2, 1, 0.3);
	overlay.animIn:SetScript("OnFinished", AnimIn_OnFinished);

	overlay.animOut = overlay:CreateAnimationGroup();
	CreateAlphaAnim(overlay.animOut, "OuterGlowOver", 1, 0.2, 1);
	CreateAlphaAnim(overlay.animOut, "Ants", 1, 0.2, -1);
	CreateAlphaAnim(overlay.animOut, "OuterGlowOver", 2, 0.2, -1);
	CreateAlphaAnim(overlay.animOut, "OuterGlow", 2, 0.2, -1);
	overlay.animOut:SetScript("OnPlay", function(self) self.isPlaying = true; end);
	overlay.animOut:SetScript("OnStop", function(self) self.isPlaying = false; end);
	overlay.animOut:SetScript("OnFinished", function(self) self.isPlaying = false; OverlayGlowAnimOutFinished(self) end);

	overlay:SetScript("OnUpdate", OverlayGlow_OnUpdate);
	overlay:SetScript("OnHide", OverlayGlow_OnHide);

	overlay.animOut.isPlaying = false;
	overlay.animOut.IsPlaying = IsAnimPlaying;

	lib.callbacks:Fire("OnOverlayGlowCreated", overlay);

	return overlay;
end

function lib:GetOverlayGlow()
	local overlay = tremove(lib.overlayGlow.unused);
	if(not overlay) then
		overlay = lib:CreateOverlayGlow();
	end
	return overlay;
end

function lib:ShowOverlayGlow(frame)
	if(frame.__LBGoverlay) then
		if(frame.__LBGoverlay.animOut:IsPlaying()) then
			frame.__LBGoverlay.animOut:Stop();
			frame.__LBGoverlay.animIn:Play();
		end
	else
		local overlay = lib:GetOverlayGlow();
		local frameWidth, frameHeight = frame:GetSize();
		overlay:SetParent(frame);
		overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		overlay:SetPoint("TOPLEFT", frame, "TOPLEFT", -frameWidth * 0.2, frameHeight * 0.2);
		overlay:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", frameWidth * 0.2, -frameHeight * 0.2);
		overlay.animIn:Play();
		frame.__LBGoverlay = overlay;
	end
end

function lib:HideOverlayGlow(frame)
	if(frame.__LBGoverlay) then
		if(frame.__LBGoverlay.animIn:IsPlaying()) then
			frame.__LBGoverlay.animIn:Stop();
		end
		if(frame:IsVisible()) then
			frame.__LBGoverlay.animOut:Play();
		else
			OverlayGlowAnimOutFinished(frame.__LBGoverlay.animOut);
		end
	end
end

-- Overlay Functions
lib.overlay.sizeScale = lib.overlay.sizeScale or 0.8;
lib.overlay.longSide = 256 * lib.overlay.sizeScale;
lib.overlay.shortSide = 128 * lib.overlay.sizeScale;

lib.overlayFrame = lib.overlayFrame or CreateFrame("Frame", nil, UIParent);
lib.overlayFrame:SetSize(lib.overlay.longSide, lib.overlay.longSide);
lib.overlayFrame:SetPoint("CENTER");

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
};

function lib:ShowAllOverlays(frame, spellID, texturePath, positions, scale, r, g, b)
	positions = strupper(positions);
	if(complexLocationTable[positions]) then
		for location, info in pairs(complexLocationTable[positions]) do
			lib:ShowOverlay(frame, spellID, texturePath, location, scale, r, g, b, info.vFlip, info.hFlip);
		end
	else
		lib:ShowOverlay(frame, spellID, texturePath, positions, scale, r, g, b, false, false);
	end
end

function lib:ShowOverlay(frame, spellID, texturePath, position, scale, r, g, b, vFlip, hFlip)
	local overlay = lib:GetOverlay(frame, spellID, position);
	overlay.spellID = spellID;
	overlay.position = position;

	overlay:ClearAllPoints();

	local texLeft, texRight, texTop, texBottom = 0, 1, 0, 1;
	if(vFlip) then
		texTop, texBottom = 1, 0;
	end
	if(hFlip) then
		texLeft, texRight = 1, 0;
	end
	overlay.texture:SetTexCoord(texLeft, texRight, texTop, texBottom);

	local width, height;
	if(position == "CENTER") then
		width, height = lib.overlay.longSide, lib.overlay.longSide;
		overlay:SetPoint("CENTER", frame, "CENTER", 0, 0);
	elseif(position == "LEFT") then
		width, height = lib.overlay.shortSide, lib.overlay.longSide;
		overlay:SetPoint("RIGHT", frame, "LEFT", 0, 0);
	elseif(position == "RIGHT") then
		width, height = lib.overlay.shortSide, lib.overlay.longSide;
		overlay:SetPoint("LEFT", frame, "RIGHT", 0, 0);
	elseif(position == "TOP") then
		width, height = lib.overlay.longSide, lib.overlay.shortSide;
		overlay:SetPoint("BOTTOM", frame, "TOP");
	elseif(position == "BOTTOM") then
		width, height = lib.overlay.longSide, lib.overlay.shortSide;
		overlay:SetPoint("TOP", frame, "BOTTOM");
	elseif(position == "TOPRIGHT") then
		width, height = lib.overlay.shortSide, lib.overlay.shortSide;
		overlay:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 0, 0);
	elseif(position == "TOPLEFT") then
		width, height = lib.overlay.shortSide, lib.overlay.shortSide;
		overlay:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", 0, 0);
	elseif(position == "BOTTOMRIGHT") then
		width, height = lib.overlay.shortSide, lib.overlay.shortSide;
		overlay:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", 0, 0);
	elseif(position == "BOTTOMLEFT") then
		width, height = lib.overlay.shortSide, lib.overlay.shortSide;
		overlay:SetPoint("TOPRIGHT", frame, "BOTTOMLEFT", 0, 0);
	else
		return;
	end

	overlay:SetSize(width * scale, height * scale);

	overlay.texture:SetTexture(texturePath);
	overlay.texture:SetVertexColor(r / 255, g / 255, b / 255);

	overlay.animOut:Stop();
	overlay:Show();
end

function lib:GetOverlay(frame, spellID, position)
	local overlayList = lib.overlay.inUse[spellID];
	local overlay;
	if(overlayList) then
		for i = 1, #overlayList do
			if(overlayList[i].position == position) then
				overlay = overlayList[i];
			end
		end
	end

	if(not overlay) then
		overlay = lib:GetUnusedOverlay(frame);
		if(overlayList) then
			tinsert(overlayList, overlay);
		else
			lib.overlay.inUse[spellID] = {overlay};
		end
	end

	return overlay;
end

function lib:HideOverlays(spellID)
	local overlayList = lib.overlay.inUse[spellID];
	if(overlayList) then
		for i = 1, #overlayList do
			local overlay = overlayList[i];
			overlay.pulse:Pause();
			overlay.animOut:Play();
		end
	end
end

function lib:HideAllOverlays()
	for spellID, overlayList in pairs(lib.overlay.inUse) do
		lib:HideOverlays(spellID);
	end
end

function lib:GetUnusedOverlay(frame)
	local overlay = tremove(lib.overlay.unused, #lib.overlay.unused);
	if(not overlay) then
		overlay = lib:CreateOverlay(frame);
	end
	return overlay;
end

local function Texture_OnShow(self)
	self.animIn:Play();
end

local function Texture_OnFadeInPlay(animGroup)
	animGroup:GetParent():SetAlpha(0);
end

local function Texture_OnFadeInFinished(animGroup)
	local overlay = animGroup:GetParent();
	overlay:SetAlpha(1);
	overlay.pulse:Play();
end

local function Texture_OnFadeOutFinished(self)
	AlphaAnimation_OnFinished(self);
	local overlay = self:GetRegionParent();
	overlay.pulse:Stop();
	overlay:Hide();
	tDeleteItem(lib.overlay.inUse[overlay.spellID], overlay);
	tinsert(lib.overlay.unused, overlay);
end

function lib:CreateOverlay(frame)
	local overlay = CreateFrame("Frame", nil, frame);
	overlay:Hide();

	overlay.animIn = overlay:CreateAnimationGroup();
	CreateAlphaAnim(overlay.animIn, nil, nil, 0.2, 1);
	overlay.animIn:SetScript("OnPlay", Texture_OnFadeInPlay);
	overlay.animIn:SetScript("OnFinished", Texture_OnFadeInFinished);

	overlay.animOut = overlay:CreateAnimationGroup();
	CreateAlphaAnim(overlay.animOut, nil, nil, 0.1, -1, nil, nil, Texture_OnFadeOutFinished);

	overlay.pulse = overlay:CreateAnimationGroup();
	overlay.pulse:SetLooping("REPEAT");
	CreateScaleAnim(overlay.pulse, nil, 1, 0.5, 1.08, 1.08, nil, "IN_OUT");
	CreateScaleAnim(overlay.pulse, nil, 2, 0.5, 0.9259, 0.9259, nil, "IN_OUT");

	overlay.texture = overlay:CreateTexture(nil, "ARTWORK");
	overlay.texture:SetAllPoints();
	overlay:SetScript("OnShow", Texture_OnShow);
	overlay:SetScript("OnHide", nil);

	lib.callbacks:Fire("OnOverlayCreated", overlay);

	return overlay;
end

--
local function Init()
	lib.eventFrame:SetScript("OnEvent", lib.OnEvent);
	lib.eventFrame:RegisterEvent("UNIT_AURA");
	lib.OnEvent(lib.eventFrame, "ForseUpdate", "player");
end

Init();