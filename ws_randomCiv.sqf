// Gives a unit randomized civilian clothing
// Thank to Snippers
// In unit init:
// this execVM ws_randomCiv

_unit = _this;

if !(local _unit) exitWith {};

_uniforms = ["U_Rangemaster","U_C_Poloshirt_tricolour","U_C_Poloshirt_salmon","U_C_Poloshirt_burgundy","U_C_Poloshirt_blue","U_OrestesBody","U_Competitor","U_IG_Guerilla1_1","U_IG_Guerilla2_1","U_IG_Guerilla2_2","U_IG_Guerilla3_1","U_IG_Guerilla3_2","U_IG_leader","U_C_HunterBody_grn","U_I_G_resistanceLeader_F","U_C_Driver_3","U_C_Journalist","U_Marshal","U_NikosBody"];

_headgears = 	["H_Booniehat_khk","H_Cap_red","H_Cap_tan","H_Cap_blk","H_Cap_grn_BI","H_Bandanna_surfer","H_Bandanna_khk","H_Bandanna_camo","H_Shemag_khk","H_Shemag_olive","H_Beret_blk","H_Watchcap_blk","H_StrawHat","H_Hat_brown","H_Hat_checker","H_Cap_blk_ION","H_RacingHelmet_1_black_F","H_StrawHat_dark"];

_vests = ["V_Rangemaster_belt","V_BandollierB_khk","V_BandollierB_rgr"];

_backpacks = ["B_AssaultPack_khk","B_AssaultPack_rgr","B_AssaultPack_blk","B_AssaultPack_cbr","B_Kitbag_rgr","B_Kitbag_cbr","B_Kitbag_sgg","B_TacticalPack_blk","B_Carryall_khk","B_FieldPack_cbr","B_FieldPack_khk","B_TacticalPack_oli"];

removeUniform _unit;
removeheadgear _unit;

_unit forceAddUniform (_uniforms call BIS_fnc_selectRandom);
_unit addheadgear (_headgears call BIS_fnc_selectRandom);

if (random 1 > 0.2) then { // either backpack or a vest
	_unit addbackpack(_backpacks call BIS_fnc_selectRandom);
	//[[[_unit,_backpacks call BIS_fnc_selectRandom], {(_this select 0) addBackpack (_this select 1);}], "BIS_fnc_spawn", true] call BIS_fnc_MP;
} else {
	_unit addvest(_vests call BIS_fnc_selectRandom);
};
// give a bonus headgear.
_unit addItem (_headgears call BIS_fnc_selectRandom);