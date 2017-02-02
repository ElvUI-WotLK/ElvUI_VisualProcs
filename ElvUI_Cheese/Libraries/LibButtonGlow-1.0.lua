local results = {};
setmetatable(results, {
	__mode = "kv";
});

function CHEESE_OVERLAY_GLOW_SPELL_MAP()
	local res = results.overlayGlowSpellMap;
	if ( not res ) then
		res = {
[133]=1,
[143]=1,
[145]=1,
[585]=3,
[591]=3,
[596]=5,
[598]=3,
[635]=9,
[639]=9,
[647]=9,
[686]=12,
[695]=12,
[705]=12,
[879]=15,
[984]=3,
[996]=5,
[1004]=3,
[1026]=9,
[1042]=9,
[1088]=12,
[1106]=12,
[1464]=17,
[2060]=5,
[2061]=3,
[2120]=19,
[2121]=19,
[2136]=21,
[2137]=21,
[2138]=21,
[2912]=23,
[3044]=25,
[3140]=1,
[3472]=9,
[5143]=28,
[5144]=28,
[5145]=28,
[5176]=30,
[5177]=30,
[5178]=30,
[5179]=30,
[5180]=30,
[5308]=32,
[5614]=15,
[5615]=15,
[6060]=3,
[6353]=35,
[6572]=39,
[6574]=39,
[6780]=30,
[7379]=39,
[7384]=41,
[7641]=12,
[7887]=41,
[8400]=1,
[8401]=1,
[8402]=1,
[8412]=21,
[8413]=21,
[8416]=28,
[8417]=28,
[8422]=19,
[8423]=19,
[8820]=17,
[8905]=30,
[8949]=23,
[8950]=23,
[8951]=23,
[9472]=3,
[9473]=3,
[9474]=3,
[9875]=23,
[9876]=23,
[9912]=30,
[10148]=1,
[10149]=1,
[10150]=1,
[10151]=1,
[10197]=21,
[10199]=21,
[10211]=28,
[10212]=28,
[10215]=19,
[10216]=19,
[10312]=15,
[10313]=15,
[10314]=15,
[10328]=9,
[10329]=9,
[10915]=3,
[10916]=3,
[10917]=3,
[10933]=3,
[10934]=3,
[10960]=5,
[10961]=5,
[10963]=5,
[10964]=5,
[10965]=5,
[11366]=43,
[11584]=41,
[11585]=41,
[11600]=39,
[11601]=39,
[11604]=17,
[11605]=17,
[11659]=12,
[11660]=12,
[11661]=12,
[12354]=19,
[12505]=43,
[12522]=43,
[12523]=43,
[12524]=43,
[12525]=43,
[12526]=43,
[13339]=45,
[13340]=45,
[13341]=45,
[13342]=45,
[13374]=45,
[13878]=48,
[14145]=45,
[14281]=25,
[14282]=25,
[14283]=25,
[14284]=25,
[14285]=25,
[14286]=25,
[14287]=25,
[14895]=41,
[15041]=48,
[15068]=5,
[15091]=48,
[15241]=48,
[15574]=45,
[15744]=48,
[16046]=48,
[16144]=45,
[16785]=48,
[17137]=3,
[17138]=3,
[17145]=48,
[17195]=48,
[17198]=41,
[17276]=45,
[17277]=48,
[17492]=45,
[17843]=3,
[17924]=35,
[18809]=43,
[18948]=19,
[18949]=19,
[19434]=50,
[19597]=25,
[19676]=25,
[19677]=25,
[19678]=25,
[19679]=25,
[19680]=25,
[19681]=25,
[19682]=25,
[19683]=25,
[19684]=25,
[19685]=25,
[19686]=25,
[19750]=52,
[19939]=52,
[19940]=52,
[19941]=52,
[19942]=52,
[19943]=52,
[20229]=48,
[20623]=45,
[20647]=32,
[20658]=32,
[20660]=32,
[20661]=32,
[20662]=32,
[20679]=45,
[20687]=23,
[20795]=45,
[20832]=45,
[20900]=50,
[20901]=50,
[20902]=50,
[20903]=50,
[20904]=50,
[21230]=1,
[21668]=23,
[22424]=48,
[22427]=17,
[23039]=48,
[23113]=48,
[23331]=48,
[23922]=56,
[23923]=56,
[23924]=56,
[23925]=56,
[24239]=58,
[24274]=58,
[24275]=58,
[24407]=41,
[24530]=45,
[24817]=41,
[25028]=45,
[25049]=48,
[25210]=5,
[25213]=5,
[25233]=3,
[25234]=32,
[25235]=3,
[25236]=32,
[25241]=17,
[25242]=17,
[25258]=56,
[25269]=39,
[25288]=39,
[25292]=9,
[25298]=23,
[25306]=1,
[25307]=12,
[25308]=5,
[25314]=5,
[25316]=5,
[25345]=28,
[25363]=3,
[25364]=3,
[26565]=5,
[26984]=30,
[26985]=30,
[26986]=23,
[27019]=25,
[27065]=50,
[27070]=1,
[27075]=28,
[27078]=21,
[27079]=21,
[27086]=19,
[27132]=43,
[27135]=9,
[27136]=9,
[27137]=52,
[27138]=15,
[27180]=58,
[27209]=12,
[27211]=35,
[27608]=3,
[27632]=50,
[28323]=48,
[29564]=3,
[29722]=60,
[30092]=48,
[30100]=25,
[30103]=25,
[30104]=25,
[30356]=56,
[30357]=39,
[30455]=48,
[30512]=45,
[30516]=45,
[30545]=35,
[30600]=48,
[30604]=5,
[30614]=50,
[30647]=25,
[30648]=25,
[30652]=25,
[31378]=45,
[31623]=50,
[32154]=41,
[32231]=60,
[32588]=17,
[33061]=48,
[33641]=3,
[33878]=65,
[33938]=43,
[33986]=65,
[33987]=65,
[34176]=3,
[34177]=12,
[34428]=67,
[34498]=69,
[34829]=25,
[35096]=3,
[35243]=23,
[35377]=48,
[35401]=25,
[36278]=48,
[36293]=25,
[36339]=45,
[36342]=48,
[36609]=25,
[36623]=25,
[36628]=48,
[36807]=48,
[36832]=60,
[36944]=15,
[37110]=45,
[37124]=23,
[37321]=41,
[37844]=48,
[37921]=1,
[37988]=45,
[38064]=48,
[38274]=1,
[38275]=1,
[38276]=1,
[38370]=50,
[38391]=48,
[38526]=45,
[38536]=48,
[38556]=1,
[38557]=1,
[38558]=1,
[38559]=1,
[38560]=1,
[38561]=1,
[38562]=1,
[38563]=1,
[38564]=1,
[38565]=1,
[38566]=1,
[38567]=1,
[38568]=1,
[38569]=1,
[38570]=1,
[38580]=3,
[38588]=3,
[38636]=48,
[38692]=1,
[38699]=28,
[38704]=28,
[38712]=48,
[38807]=25,
[38861]=50,
[38918]=60,
[38935]=23,
[39001]=48,
[39038]=48,
[39321]=5,
[40344]=23,
[40822]=1,
[41060]=1,
[41182]=17,
[41346]=1,
[41349]=23,
[41357]=23,
[41360]=23,
[41378]=3,
[42332]=1,
[42357]=1,
[42359]=1,
[42412]=1,
[42420]=3,
[42832]=1,
[42833]=1,
[42834]=1,
[42843]=28,
[42846]=28,
[42872]=21,
[42873]=21,
[42890]=43,
[42891]=43,
[42913]=48,
[42914]=48,
[42925]=19,
[42926]=19,
[43245]=45,
[43337]=25,
[43409]=1,
[43431]=3,
[43456]=41,
[43515]=1,
[43516]=3,
[43520]=1,
[43525]=1,
[43571]=48,
[43575]=3,
[43665]=1,
[43993]=1,
[44137]=48,
[44138]=48,
[44271]=50,
[44572]=48,
[44614]=1,
[45108]=1,
[45477]=71,
[46187]=48,
[46188]=48,
[46224]=19,
[46440]=1,
[46602]=1,
[46704]=1,
[47470]=32,
[47471]=32,
[47474]=17,
[47475]=17,
[47487]=56,
[47488]=56,
[47536]=75,
[47610]=1,
[47723]=48,
[47808]=12,
[47809]=12,
[47824]=35,
[47825]=35,
[47837]=60,
[47838]=60,
[48062]=5,
[48063]=5,
[48070]=3,
[48071]=3,
[48072]=5,
[48122]=3,
[48123]=3,
[48459]=30,
[48461]=30,
[48464]=23,
[48465]=23,
[48563]=65,
[48564]=65,
[48687]=12,
[48781]=9,
[48782]=9,
[48784]=52,
[48785]=52,
[48800]=15,
[48801]=15,
[48805]=58,
[48806]=58,
[48871]=50,
[48975]=1,
[49020]=80,
[49044]=25,
[49045]=25,
[49049]=50,
[49050]=50,
[49143]=82,
[49184]=71,
[49348]=3,
[49512]=1,
[49896]=71,
[49903]=71,
[49904]=71,
[49909]=71,
[50183]=48,
[50782]=17,
[50783]=17,
[50880]=71,
[50884]=71,
[50885]=71,
[50886]=71,
[50887]=71,
[51235]=1,
[51236]=1,
[51409]=71,
[51410]=71,
[51411]=71,
[51416]=82,
[51417]=82,
[51418]=82,
[51419]=82,
[51423]=80,
[51424]=80,
[51425]=80,
[51742]=25,
[52356]=1,
[52372]=71,
[52718]=50,
[52719]=17,
[52789]=71,
[53209]=50,
[53214]=25,
[53301]=69,
[53536]=71,
[53549]=71,
[54615]=50,
[55268]=82,
[56331]=3,
[56539]=9,
[56919]=3,
[56938]=48,
[57766]=3,
[57775]=3,
[57823]=39,
[57984]=45,
[58053]=9,
[58153]=9,
[58534]=48,
[58970]=48,
[59131]=71,
[59138]=1,
[59243]=50,
[59603]=1,
[59637]=45,
[59997]=3,
[60003]=3,
[60051]=69,
[60052]=69,
[60053]=69,
[60290]=48,
[60648]=52,
[60656]=52,
[60659]=52,
[60661]=52,
[60662]=52,
[60664]=52,
[60800]=52,
[61168]=1,
[61362]=48,
[61577]=48,
[61965]=3,
[62334]=3,
[62442]=3,
[62809]=3,
[63760]=3,
[66196]=82,
[66198]=80,
[66958]=82,
[66959]=82,
[66960]=82,
[66961]=82,
[66962]=82,
[66972]=80,
[66973]=80,
[66974]=80,
[67254]=3,
[67291]=3,
[68073]=12,
[68812]=1,
[71590]=48,
[71591]=48,
[71786]=48,
[71930]=3,
[71931]=3,
[72484]=3,
[75412]=48,
[75419]=48,
		};
		results.overlayGlowSpellMap = res;
	end
	return res;
end

function CHEESE_OVERLAY_GLOW_SPELL_TABLE()
	local res = results.overlayGlowSpellTable;
	if ( not res ) then
		res = {
57761,nil;
33151,nil;
63735,63731,63734,nil;
53672,54149,nil;
17941,34936,nil;
59578,nil;
46916,nil;
54741,nil;
64343,nil;
48518,nil;
53220,56453,nil;
44401,nil;
48517,nil;
52437,5308,nil;
47383,71162,71165,nil;
6572,nil;
7384,nil;
48108,nil;
74396,64343,nil;
74396,nil;
53220,nil;
59578,53672,54149,nil;
50227,nil;
24275,nil;
47383,71162,71165,34936,nil;
50334,nil;
34428,nil;
56453,nil;
59052,51124,49796,nil;
33151,63735,63731,63734,nil;
49796,nil;
51124,49796,nil;
		};
		results.overlayGlowSpellTable = res;
	end
	return res;
end

function CHEESE_OVERLAY_MAP()
	local res = results.overlayMap;
	if ( not res ) then
		res = {
[59578]=1,
[50227]=6,
[52437]=11,
[53817]=16,
[6572]=121,
[5308]=121,
[24275]=121,
[48108]=21,
[57761]=26,
[74396]=31,
[59052]=36,
[53220]=41,
[56453]=46,
[48517]=51,
[48518]=56,
[33151]=61,
[50334]=121,
[33891]=121,
[34428]=121,
[46916]=66,
[7384]=121,
[17941]=71,
[47283]=76,
[16870]=81,
[5143]=121,
[64343]=86,
[47383]=91,
[71162]=91,
[71165]=91,
[34936]=96,
[51124]=101,
[44401]=106,
[63735]=111,
[63731]=111,
[53672]=116,
[54149]=116,
[49796]=121,
[54741]=121,
[63734]=111,
		};
		results.overlayMap = res;
	end
	return res;
end

CHEESE_OVERLAYS_UPPER_BOUND = 121;

function CHEESE_OVERLAY_TABLE()
	local res = results.overlayTable;
	if ( not res ) then
		res = {
0,"ART_OF_WAR.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"SWORD_AND_BOARD.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"SUDDEN_DEATH.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
5,"MAELSTROM_WEAPON.BLP","Top",1,0xFFFFFFFF;
1,"HOT_STREAK.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"BRAIN_FREEZE.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
1,"FROZEN_FINGERS.BLP","Top",1,0xFFFFFFFF;
0,"RIME.BLP","Top",1,0xFFFFFFFF;
0,"MASTER_MARKSMAN.BLP","Top",1,0xFFFFFFFF;
0,"LOCK_AND_LOAD.BLP","Top",1,0xFFFFFFFF;
0,"ECLIPSE_SUN.BLP","TopRight",1,0xFFF4F4F4;
0,"ECLIPSE_MOON.BLP","TopLeft",1,0xFFF4F4F4;
0,"SURGE_OF_LIGHT.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"BLOOD_SURGE.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"NIGHTFALL.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"IMP_EMPOWERMENT.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"NATURES_GRACE.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"IMPACT.BLP","Top",1,0xFFFFFFFF;
0,"MOLTEN_CORE.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"BACKLASH.BLP","Top",1,0xFFFFFFFF;
0,"KILLING_MACHINE.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
0,"ARCANE_MISSILES.BLP","Left + Right (Flipped)",1,0xFFFFFFFF;
3,"SERENDIPITY.BLP","Top",1,0xFFFFFFFF;
0,"DENOUNCE.BLP","Top",1,0xFFFFFFFF;
0;
		};
		results.overlayTable = res;
	end
	return res;
end


local MAJOR_VERSION, MINOR_VERSION = "LibButtonGlow-1.0", 1;

local lib, oldversion = LibStub:NewLibrary(MAJOR_VERSION, MINOR_VERSION);
if(not lib) then return end -- No upgrade needed

lib.disableActivationOverlay = false;

-- Lua APIs
local pairs, next, tostring = pairs, next, tostring;
local tinsert, tremove = table.insert, table.remove;
local band, lshift, rshift = bit.band, bit.lshift, bit.rshift;

-- WoW APIs
local CreateFrame = CreateFrame;
local PlayerFrame = PlayerFrame;
local GetActionInfo = GetActionInfo;
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


local OVERLAY_GLOW_SPELL_MAP = CHEESE_OVERLAY_GLOW_SPELL_MAP;
local OVERLAY_GLOW_SPELL_TABLE = CHEESE_OVERLAY_GLOW_SPELL_TABLE;
local OVERLAY_MAP = CHEESE_OVERLAY_MAP;
local OVERLAY_TABLE = CHEESE_OVERLAY_TABLE;
local OVERLAYS_UPPER_BOUND = CHEESE_OVERLAYS_UPPER_BOUND;

local actionButtons = {
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
	nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
};

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

function lib.SetAction(action, globalID)
	actionButtons[action] = globalID;
	if(globalID) then
		local glowSpellK = OVERLAY_GLOW_SPELL_MAP()[globalID];
		if(glowSpellK) then
			local overlayGlowSpellTable = OVERLAY_GLOW_SPELL_TABLE();
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

function lib.ChangeAction(action, newGlobalID)
	local globalID = actionButtons[action];
	if(globalID) then
		local glowSpellK = OVERLAY_GLOW_SPELL_MAP()[globalID];
		if(glowSpellK) then
			local overlayGlowSpellTable = OVERLAY_GLOW_SPELL_TABLE();
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
	lib.SetAction(action, newGlobalID);
end

local function BuffGained(spellID, k, overlayTable)
	if(k < OVERLAYS_UPPER_BOUND) then -- Это код на текстуры
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

	local glowSpells = buffGlowSpells[spellID]; -- Вроде как на панели
	if(glowSpells) then
		for globalID in pairs(glowSpells) do
			AddOverlayGlow(globalID);
		end
	end
end

local function BuffLost(spellID)
	for frame, func in pairs(lib.overlayHide) do -- Это код на текстуры
		func(frame, spellID);
	end

	local glowSpells = buffGlowSpells[spellID]; -- Вроде как на панели
	if(glowSpells) then
		for globalID in pairs(glowSpells) do
			RemoveOverlayGlow(globalID);
		end
	end
end

function lib.OnEvent(self, event, unitID)
	local unit = PlayerFrame.unit;
	if(unitID == unit) then
		do
			local name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, 1);
			if(name) then
				local overlayMap = CHEESE_OVERLAY_MAP();
				local overlayTable;
				local j = 1;
				repeat
					local k = overlayMap[spellID];
					if(k) then
						if(not overlayTable) then
							overlayTable = CHEESE_OVERLAY_TABLE();
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

local function GetSpellIdByName(spellName)
	if(not spellName) then return; end
	local spellLink = GetSpellLink(spellName);
	if(spellLink) then
		return tonumber(spellLink:match("spell:(%d+)"));
	end
	return nil;
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
	local left, bottom, width, height = target:GetRect();
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
		for i=1, #self, 5 do
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

local function CreateScaleAnim(group, target, order, duration, x, y, delay, endDelay, smoothing, onPlay)
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
	if(endDelay) then
		scale:SetEndDelay(endDelay)
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
	--local cooldown = self:GetParent().cooldown;
	-- we need some threshold to avoid dimming the glow during the gdc
	-- (using 1500 exactly seems risky, what if casting speed is slowed or something?)
	--if(cooldown and cooldown:IsShown() and cooldown:GetCooldownDuration() > 3000) then
	--	self:SetAlpha(0.5);
	--else
	--	self:SetAlpha(1.0);
	--end
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
	CreateScaleAnim(overlay.animIn, "Spark", 1, 0.2, 1.5, 1.5, nil, nil, nil, AnimIn_OnPlay);
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

	lib.callbacks:Fire("OnOverlayCreated", overlay);

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

local sizeScale = 0.8;
local longSide = 256 * sizeScale;
local shortSide = 128 * sizeScale;

lib.overlayFrame = lib.overlayFrame or CreateFrame("Frame", nil, UIParent);
lib.overlayFrame:SetSize(longSide, longSide);
lib.overlayFrame:SetPoint("CENTER");

lib:RegisterEvent("SPELL_ACTIVATION_OVERLAY_SHOW", lib.overlayFrame, function(self, spellID, texture, positions, scale, r, g, b)
	lib:ShowAllOverlays(self, spellID, texture, positions, scale, r, g, b);
end);

lib:RegisterEvent("SPELL_ACTIVATION_OVERLAY_HIDE", lib.overlayFrame, function(self, spellID)
	if(spellID) then
		lib:HideOverlays(self, spellID);
	else
		lib:HideAllOverlays(self);
	end
end);

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
		width, height = longSide, longSide;
		overlay:SetPoint("CENTER", frame, "CENTER", 0, 0);
	elseif(position == "LEFT") then
		width, height = shortSide, longSide;
		overlay:SetPoint("RIGHT", frame, "LEFT", 0, 0);
	elseif(position == "RIGHT") then
		width, height = shortSide, longSide;
		overlay:SetPoint("LEFT", frame, "RIGHT", 0, 0);
	elseif(position == "TOP") then
		width, height = longSide, shortSide;
		overlay:SetPoint("BOTTOM", frame, "TOP");
	elseif(position == "BOTTOM") then
		width, height = longSide, shortSide;
		overlay:SetPoint("TOP", frame, "BOTTOM");
	elseif(position == "TOPRIGHT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 0, 0);
	elseif(position == "TOPLEFT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("BOTTOMRIGHT", frame, "TOPLEFT", 0, 0);
	elseif(position == "BOTTOMRIGHT") then
		width, height = shortSide, shortSide;
		overlay:SetPoint("TOPLEFT", frame, "BOTTOMRIGHT", 0, 0);
	elseif(position == "BOTTOMLEFT") then
		width, height = shortSide, shortSide;
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

function lib:HideOverlays(frame, spellID)
	local overlayList = lib.overlay.inUse[spellID];
	if(overlayList) then
		for i = 1, #overlayList do
			local overlay = overlayList[i];
			overlay.pulse:Pause();
			overlay.animOut:Play();
		end
	end
end

function lib:HideAllOverlays(frame)
	for spellID, overlayList in pairs(lib.overlay.inUse) do
		lib:HideOverlays(frame, spellID);
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
	CreateScaleAnim(overlay.pulse, nil, 1, 0.5, 1.08, 1.08, nil, nil, "IN_OUT");
	CreateScaleAnim(overlay.pulse, nil, 2, 0.5, 0.9259, 0.9259, nil, nil, "IN_OUT");

	overlay.texture = overlay:CreateTexture(nil, "ARTWORK");
	overlay.texture:SetAllPoints();
	overlay:SetScript("OnShow", Texture_OnShow);
	overlay:SetScript("OnHide", nil);

	return overlay;
end

function lib.Init()
	for action = 1, 144 do
		local actionType, id, _, globalID = GetActionInfo(action);
		if(actionType == "spell") then
			lib.SetAction(action, globalID);
		elseif(actionType == "macro") then
			lib.SetAction(action, GetSpellIdByName(GetMacroSpell(id)));
		end
	end

	local unit = PlayerFrame.unit;
	local name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, 1);
	if(name) then
		local overlayMap = OVERLAY_MAP();
		local overlayTable;
		local j = 1;
		repeat
			local k = overlayMap[spellID];
			if(k) then
				if(not overlayTable) then
					overlayTable = OVERLAY_TABLE();
				end

				if(not (count < overlayTable[k])) then
					buffs[spellID] = true;
					BuffGained(spellID, k, overlayTable);
				end
			end
			j = j + 1;
			name, _, _, count, _, _, _, _, _, _, spellID = UnitBuff(unit, j);
		until(not name);
	end
end

lib.Init();

lib.eventFrame:SetScript("OnEvent", lib.OnEvent);
lib.eventFrame:RegisterEvent("UNIT_AURA");