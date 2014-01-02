if !(isServer) exitWith {};

/* ARMA2
_wreckarray= ["HMMWVWreck","BMP2Wreck",
"UralWreck",
"datsun01Wreck",
"datsun02Wreck",
"hiluxWreck",
"T72Wreck",
"BRDMWreck",
"UAZWreck",
"SKODAWreck",
"LADAWreck",
"WarfareSalvageTruck_INS",
"UralRefuel_INS",
"KamazOpen",
"T34",
"T55_Base",
"BTR40_MG_base_EP1"
];

_dontflip = [
"T34",
"T55_Base",
"BTR40_MG_base_EP1"
];*/

/*ARMA 3*/
_wreckarray = [
"Land_Wreck_BMP2_F",
"Land_Wreck_BRDM2_F",
"Land_Wreck_Car_F",
"Land_Wreck_Car2_F",
"Land_Wreck_Car3_F",
"Land_Wreck_CarDismantled_F",
"Land_Wreck_Heli_Attack_01_F",
"Land_Wreck_Heli_Attack_02_F",
"Land_Wreck_HMMWV_F",
"Land_Wreck_Hunter_F",
"Land_Wreck_Offroad_F",
"Land_Wreck_Offroad2_F",
"Land_Wreck_Plane_Transport_01_F",
"Land_Wreck_Skodovka_F",
"Land_Wreck_Slammer_F",
"Land_Wreck_Slammer_hull_F",
"Land_Wreck_Slammer_turret_F",
"Land_Wreck_T72_hull_F",
"Land_Wreck_Truck_dropside_F",
"Land_Wreck_Truck_F",
"Land_Wreck_UAZ_F",
"Land_Wreck_Ural_F",
"Land_Wreck_Van_F"
];

_badarray = [];


_center = [_this select 0] call ws_fnc_getPos;
_wrecks = _this select 1;
_radius = _this select 2;

for "_x" from 1 to _wrecks do {
_wrecktype = _wreckarray call ws_fnc_selectRandom;
_pos = [];
while {count _pos != 3} do {
	_pos = [_center,_radius] call ws_fnc_getPos;
	_pos = _pos findEmptyPosition [0,15,_wrecktype];
};
_wreck = _wrecktype createVehicle _pos;
_wreck enableSimulation false;
_wreck setDir (random 360);
_wreck setDamage 0.5 + round random 0.4;
_wreck lock true;
if !(_wrecktype in _dontflip) then {
if (random 1 > 0.7) then {_wreck Setpos [getPos _wreck select 0,getPos _wreck select 1,-0.5];[_wreck,0, 90] call bis_fnc_setpitchbank;}
} else {_wreck setVectorUp(surfaceNormal(getPos _wreck));};
};
