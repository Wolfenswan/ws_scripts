//by Wolfenswan [ARPS]
//
//nul = [this,100,west,10] execVM "scripts\ws_assassins_light.sqf";

//From left to right:
//1. Has to be this in a unit inititilization or the name of an existing (civilian) unit 	| (this or objectname)
//
//2. The chance in 100 that the civilian will actually pull a weapon and shoot 			| (0-100)
//
//3. The radius around the civilian that triggers him 									| (any number)
//
//4. MOST IMPORTANT. What the civilian will attack:
//   If set to on west,east or resistance he will trigger when any alive unit of that type is near

if !(isServer) exitWith {};

private ["_count","_done","_check","_listclose","_listclosealive","_flee",
"_unit","_units","_unitloc","_weapon","_weaponmag","_target1","_target2","_trg","_trgsize","_switch","_chance",
"_grp","_target"];

//If it fails the chance check there's no need to run anything else:
_chance = _this select 1;
if ((round(random 100))>= _chance)exitWith{};

//Modify these arrays for the randomized weapon selection.
//Correspondin mag has to be on the same position as the weapon.
_weaponarr = ["Sa61_EP1","UZI_EP1","revolver_EP1","Makarov"];
_weaponmagarr = ["20Rnd_B_765x17_Ball","30Rnd_9x19_UZI","6Rnd_45ACP","8Rnd_9x18_Makarov"];
_flee = 1; //if 1 the sleepers flee as long as they are disguised, if 0 they won't

//Variables taken from the array
_unit = _this select 0;
_trgsize = _this select 3;
_switch = 0;
_target1 = _this select 2; //the legit target class (can be a side or a unit name)
_target2 = 5; //the number of valid targets that have to be in the area
_focus = 0; //0 for off
_skill = 0.7;

//Weapon selection
_ran = (floor(random(count _weaponarr)));
_weapon = _weaponarr select _ran;_weaponmag = _weaponmagarr select _ran;

//Helper variables / declaring variables we need later
_listclose = [];
_listclosealive = [];
_target = "";
_done = false;
_unitloc = getPos _unit;

//Group Creation
switch (_target1) do {
	case west: {_grp = createGroup east;_target="soldierWB"};
	case east: {_grp = createGroup west;_target="soldierEB"};
	case resistance: {if ((west getFriend resistance)<0.6)then{_grp = createGroup east;_target="soldierGB"}else{_grp = createGroup west;_target="soldierGB"};};
	default {_target="Man"};
};

_unit allowfleeing _flee;
_unit setSkill _skill;

//The magical loop where it all happens
while {(alive _unit)&& !(_done)} do {
_unitloc = getPos _unit;
_listclose = nearestObjects [_unitloc,[_target],_trgsize];
{if (alive _x) then {_listclosealive set [(count _listclosealive),_x];};} foreach _listclose;
	if ((count _listclosealive) >_target2) exitWith {
	sleep (random(8));
	[_unit] join grpNull;
	sleep 0.1;
	[_unit] join _grp;
	_unit addWeapon _weapon;
	_unit addMagazine _weaponmag;
	_unit addMagazine _weaponmag;
	_done = true;
	};
sleep 1;
};

deletegroup _grp;