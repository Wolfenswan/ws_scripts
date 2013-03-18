// City in ruins mini script
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature:
// Destroy a  random selection of buildings and sets them on fire
//
// Usage: 
// In the editor place a gamelogic with [this,300,50,50] execVM "ws_cityinruins.sqf" in the init.sqf
// Adjust values accordingly
//
// Customization: 
// Second Number: radius around the gamelogic where buildings are affected
// Third number: chance in 100 that a building in the radius is destroyed
// Fourth number: chance in 100 that a destroyed building is burning
//
// Note:
// Not JIP-compatible

private ["_center","_radius","_fire","_destructometer","_firechance","_buildings","_count","_firestrength","_minfirestrength","_firearray","_destroyarray"];

BIS_Effects_Burn=compile preprocessFile "\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf";
_center = _this select 0;
_radius = _this select 1;
_destructometer = _this select 2;
_firechance = _this select 3;

_minfirestrength = 5;
_buildings = nearestObjects [_center, ["building"], _radius];
_count = count _buildings;
_destroyarray = [];
_firearray = [];

if (isServer) then {
for "_i" from 1 to _count do {
if (round random 100 <= _destructometer) then {
_building = _buildings select _i;
_destroyarray = _destroyarray + [_building];
	if (round random 100 <= _firechance) then {
	_fire = "LocationLogic" createVehicle (getPos _building);
	_firearray = _firearray + [_fire];
	};};};
ws_firearray = _firearray; publicvariable "ws_firearray";
ws_destroyarray = _destroyarray; publicvariable "ws_destroyarray";
};

waituntil {(!isNil "ws_destroyarray")};

{_x setdamage 1;} forEach ws_destroyarray;
{
_firestrength = _minfirestrength + (ceil (random 4));
_burn = [_x,_firestrength,time,false,false] spawn BIS_Effects_Burn;
} forEach ws_firearray;