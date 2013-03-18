//by Wolfenswan [FA]
//
//nul = [this,"Sa61_EP1","20Rnd_B_765x17_Ball",100,10,0,west,1,0,1,0] execVM "scripts\ws_assassins.sqf";

//From left to right:
//1. Has to be this in a unit inititilization or the name of an existing (civilian) unit 	| (this or objectname)
//
//2. The intended Weapon class. "" for random small arm 									| (any legal weapon class) or ""
//
//3. The magazine of the intended class. "" for mag for random small arm					| (any legal magazine class) or ""
//
//4. The chance in 100 that the civilian will actually pull a weapon and shoot 			| (0-100)
//
//5. The radius around the civilian that triggers him 						| (any number)
//
//6. The Switch - relevant for 7.,8. & 9. See those entries					| (0 or 1)
//
//7. MOST IMPORTANT. What the civilian will attack:
//   If set to on west,east or resistance he will trigger when any alive unit of that type is near
//   If set to Switch 1 and a unitname, it will wait until the specified unit is in the area.
//	
//8. How many units of the selected target side have to be in the area before the civilian	| (any number over 0)
//   triggers. Should be 1 in switch mode 1. Any number for switch mode 0
//
//9. Focus switch - only works in switch mode 1. The civilian will focus on the target alone	| (0 or 1)
//   he won't attack any other units
//
//10. The skill level of the civilian. Can be anything from 0 to 1, including decimals.		| (any number 0 to 1)
//   See http://community.bistudio.com/wiki/setSkill
//
//11.Switch to control between apply to all civilians (1) or only the specified one (0)		| (0 or 1)
//   1.,2.,3.,6.,9. are ignored when set to (1)
//   7. can only be a faction in (1)
//   4.,5. and 8. are read in (1) and should be randomized.
//   In (1) The Weapons are randonmly taken from an array. Modify this array in the ws_assassins.sqf.
//   Note that the weapon and it's corresponding magazine have to be in the same place in their 
//   respective arrays.

// Rewrite: Replace The Switch by typename Check of 7 (side or object)

if !(isServer) exitWith {};

private ["_count","_done","_check","_listclose","_listclosealive","_sleep","_ran","_flee",
"_unit","_units","_unitloc","_weapon","_weaponmag","_target1","_target2","_trg","_trgsize","_switch","_chance",
"_grp","_target"];


//Modify these arrays for the randomized weapon selection.
//Corresponding mag has to be on the same position as the weapon.
_weaponarr = ["Sa61_EP1","UZI_EP1","revolver_EP1","Makarov"];
_weaponmagarr = ["20Rnd_B_765x17_Ball","30Rnd_9x19_UZI","6Rnd_45ACP","8Rnd_9x18_Makarov"];
_flee = 1; //if 1 the sleepers flee as long as they are disguised, if 0 they won't
_sleep = (round random(8)); //How long they sleep between being trigger and pulling a gun

_unit = _this select 0;

//If it fails the chance check there's no need to run anything else:
_chance = _this select 3;
if ((round(random 100))> _chance)exitWith{
_unit setSkill 0; _unit allowFleeing 1; {_unit disableAI _x} count ["AUTOTARGET","TARGET"];
};

//Unfortunately ArmA is sexist and women can't be assassins
//We delete the would-be assassiness (assassina? assassinette?) and have ALICE create a new one
if (_unit isKindOf "Woman") exitWith {deleteVehicle _unit};

//Variables taken from the array
_trgsize = _this select 4;
_switch = _this select 5; //0 for classname, 1 for specific unit
_target1 = _this select 6; //the legit target class (can be a side or a unit name)
_target2 = _this select 7; //the number of valid targets that have to be in the area
_focus = _this select 8; //0 for off
_skill = _this select 9;
_check = _this select 10; //switch for affecting all civs or just one

//If _check is set to 1 the script will launch itself again with the given variables.
if (_check == 1) exitWith {
	_civarray = [];
	{if ((side _x) == civilian) then {_civarray = _civarray + [_x]}} forEach allUnits;
	{[_x,"","",_chance,_trgsize,0,_target1,_target2,0,0,_skill,0] execVM "scripts\ws_assassins.sqf";} forEach _civarray;
};

//Weapon selection, Random if empty ("")
//If the first is empty there's no to check the second
if !(isNil (_this select 1)) then {_weapon = _this select 1;_weaponmag = _this select 2;}
else {
_ran = (floor(random(count _weaponarr)));
_weapon = _weaponarr select _ran;_weaponmag = _weaponmagarr select _ran;
};
//Helper variables / declaring variables we need later
_listclose = [];
_listclosealive = [];
_target = "";
_done = false;

//DEBUG
//player globalchat format ["ws_assassins1.sqf here. _unit:%1,_units:%2,_chance:%3,_trgsize:%4,_target1:%5,target2:%6,_count:%7,_weapon:%8,_mag:%9",_unit,_units,_chance,_trgsize,_target1,_target2,_check,_weapon,_weaponmag];
//player globalchat format ["ws_assassins.sqf here. Switch is %1,focus is %2",_switch,_focus];

//Group Creation
switch (_target1) do {
	case west: {_grp = createGroup east;_target="soldierWB"};
	case east: {_grp = createGroup west;_target="soldierEB"};
	case resistance: {if ((west getFriend resistance)<0.6)then{_grp = createGroup east;_target="soldierGB"}else{_grp = createGroup west;_target="soldierGB"};};
	default {_target="Man"};
};
if (_switch == 1) then {
switch (side _target1) do {
	case west: {_grp = createGroup east;_target="soldierWB"};
	case east: {_grp = createGroup west;_target="soldierEB"};
	case resistance: {if ((west getFriend resistance)<0.6)then{_grp = createGroup east;_target="soldierGB"}else{_grp = createGroup west;_target="soldierGB"};};
	default {_target="Man"};
};};

_unit allowfleeing _flee;
_unit setSkill _skill;
{_unit enableAI _x} count ["AUTOTARGET","TARGET"];

//The magical loop where it all happens
while {(alive _unit)&& !(_done)} do {
_unitloc = getPos _unit;
_listclose = nearestObjects [_unitloc,[_target],_trgsize];

if (_switch==0) then {
{if ((isplayer _x && alive _x)) then {_listclosealive set [(count _listclosealive),_x];};} foreach _listclose;
	if ((count _listclosealive) >_target2) exitWith {
	sleep _sleep;
	_unit addWeapon _weapon;
	_unit addMagazine _weaponmag;
	_unit addMagazine _weaponmag;
	[_unit] join _grp;
	_done = true;
	};
} else {
	if (_target1 in _listclose) exitWith {
	sleep _sleep;
	[_unit] join grpNull;
	sleep 0.1;
	[_unit] join _grp;
	_unit addWeapon _weapon;
	_unit addMagazine _weaponmag;
	_unit addMagazine _weaponmag;
		if ((_focus == 1)&&(_switch==1)) then {
			_unit disableAI "autotarget";
			_unit doTarget _target1;
			while {alive _unit} do {
			_unit doFire _target1;
			sleep 0.1;
			};
		};
	_done = true;
	};
 };
sleep 1;
};

deletegroup _grp;

//DEBUG
//player globalchat format ["ws_assassins2.sqf here. _unit:%1,_weapon:%2,_mag:%3,_grp:%4,_target1:%5,_target2:%6",_unit,_weapon,_weaponmag,_grp,_target1,_target2];