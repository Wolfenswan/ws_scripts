// Burning buildings mini script
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature: Destroys a selection of buildings and sets them on fire
//
// Usage: 
// In the editor place gamelogics named burn, burn_1, etc on top of the buildings you want to destroy/see burn
// add object names to _firearray below
// [] execVM "ws_burningbuilding.sqf" in the init.sqf
//
// Customization: 
// Change _minfirestrength if you want a bigger/smaller fire

private ["_firearray","_fire","_building","_firestrength","_burn","_pos","_minfirestrength"]; 

BIS_Effects_Burn=compile preprocessFile "\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf";

//All objects placed over a building, named accordingly
_firearray = [burn,burn_1,burn_2];
_minfirestrength = 5;

{
_pos = getPos _x;
_x setPos [_pos select 0, _pos select 1, 0.1];
_building = _pos nearestObject "Building";
_building setdamage 1;
_firestrength = _minfirestrength + (ceil (random 4));
_burn = [_x,_firestrength,time,false,false] spawn BIS_Effects_Burn;
} forEach _firearray;