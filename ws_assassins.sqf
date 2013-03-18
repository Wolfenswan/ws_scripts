// Group and wave spawn function
// By Wolfenswan [FA]: wolfenswanarps@gmail.com | folkarps.com
//
//
// FEATURE
// Turns a select number or a randomized amount of all civilians into potential assassins, attacking either a side or a specific target
// ALICE compatible
//
//
// USAGE
// From unit init:
// nul = [unit,"weaponclass",chance (1-100),triggerarea (int),side OR unitname,number of targets present (1-n),skill (0-1),apply to all civilians (bool)] execVM "ws_assassins.sqf";
//
// For use with ALICE:
// Put this in the ALICE module init:
// [BIS_alice_mainscope,"ALICE_civilianinit",[{nul = [_this,"ran",number,number,side OR unitname,skill (0-1),apply to all civilians (bool)] execVM 'ws_assassins.sqf'}]] call BIS_fnc_variableSpaceAdd;
//
// For use with ARMA 3:
// Use different classes in _weaponarray (see below)
// Debug markers are broken. Search and replace for "DOT" with "mil_dot" before using _debug = true;
//
//
// PARAMETERS:
// From left to right:
// 1. Has to be this in a unit inititilization or the name of an existing (civilian) unit 					| (this or objectname)
//
// 2. The intended Weapon class. "ran" for random weapon from _weaponarr 									| (any legal weapon class) or ""
//
// 3. The chance in 100 that the civilian will actually pull a weapon and shoot. Can be random 				| (0-100)
//
// 4. The radius around the civilian that triggers him. Can be random 										| (any number)
//
// 5. MOST IMPORTANT. What the civilian will attack:															| west, east, resistance or civilian
//   If set to on west,east or resistance he will trigger when any alive unit of that type is near			| OR unitname
//   If set to a unitname, it will wait until the specified unit is in the area.
//	
// 6. How many units of the selected target side have to be in the area before the civilian					| (any number over 0)
//   triggers. Ignored when 6. is set to unitname
//
// 7. The skill level of the civilian. Can be anything from 0 to 1, including decimals.						| (any number 0 to 1)
//   See http://community.bistudio.com/wiki/setSkill
//
// 8.Switch to control wether settings apply to all civilians (true) or only the specified one (false)		| (true or false)
//   2. is ignored when set to (true)
//   3. and 4. are read in (true) and should be randomized.
//   5. is not ignored in (true) but should be a side
//	 6. and 7. are read in (true) as in the regular script
//   In (true) The Weapons are randonmly taken from an array. Modify this array in the ws_assassins.sqf.
//
//
// TODO
// Better group generation

if !(isServer) exitWith {};

private ["_count","_done","_check","_listclose","_listclosealive","_sleep","_ran","_flee",
"_unit","_units","_unitloc","_weaponarr","_weapon","_weaponmag","_target1","_target2","_trg","_trgsize","_debug","_chance",
"_grp","_target","_target_type","_perfomancesleep"];


//LOCAL VARIABLES - modifyable
_weaponarr = ["Sa61_EP1","UZI_EP1","revolver_EP1","Makarov"]; //Modify this array for the randomized weapon selection.
//Arma3: _weaponarr = ["hgun_Rook40_F","hgun_P07_F"];
_flee = 1; //if 1 the sleepers flee as long as they are disguised, if 0 they are less prone to (but still might)
_sleep = round random 8; //How long they sleep between being trigger and pulling a gun
_perfomancesleep = 1; //How often the loop is perfomanced. Only increase this in mission with tons of civilians.

_debug = true;


//LOCAL VARIABLES - scriptside
//parsed variables
_unit = _this select 0;
_weapon = _this select 1;
_chance = _this select 2;
_trgsize = _this select 3;
_target1 = _this select 4; //the legit target class (can be a side or a unit name)
_target2 = _this select 5; //the number of valid targets that have to be in the area
_skill = _this select 6;
_check = _this select 7; //switch for affecting all civs or just one

if (_debug) then {
player globalchat format ["ws_assassins.sqf DEBUG: _unit:%1,_target1:%2,target2:%3,_weapon:%4,chance:%5, _trigsize:%6",_unit,_target1,_target2,_weapon,_chance,_trgsize];
};

//LOCAL VARIABLES - helpers
//declaring variables we need later
_listclose = [];
_listclosealive = [];
_weaponmag = "";
_target = "";
_target_type = false;
_done = false;

//INITIAL CHECKS
//If _check is set to 1 the script will launch itself again with the given variables.
if (_check) exitWith {
	_civarray = [];
	{if ((side _x) == civilian) then {_civarray = _civarray + [_x]}} forEach allUnits;
	{[_x,"ran",_chance,_trgsize,_target1,_target2,_skill,false] execVM "ws_assassins.sqf";} forEach _civarray;
};

//If the civ fails the chance check there's no need to run anything else;
//Some AI features are disabled for the civ to save processing power
if ((round(random 100))> _chance)exitWith{
_unit setSkill 0; _unit allowFleeing 1; {_unit disableAI _x} count ["AUTOTARGET","TARGET"];
};

//Unfortunately ArmA is sexist and women can't be assassins
//We delete the would-be assassiness (assassina? assassinette?) and have ALICE create a new one
if (_unit isKindOf "Woman") exitWith {deleteVehicle _unit};


//Set up sleeper
_unit allowfleeing _flee;
_unit setSkill _skill;
[_unit] joinsilent grpNull;
{_unit enableAI _x} count ["AUTOTARGET","TARGET"];

//Weapon selection, Random if empty ("")
if (_weapon == "ran") then {
_ran = (floor(random(count _weaponarr)));
_weapon = _weaponarr select _ran;
};
_weaponmag = (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0;

//GROUP CREATION
//Checking wether a side or an objectname was parsed.



switch (typename _target1) do {
	case "SIDE": {
	_target_type = true;
		switch (_target1) do {
			case west: {_center = createCenter east; _grp = createGroup east;};
			case east: {_center = createCenter west; _grp = createGroup west;};
			case resistance: {if ((west getFriend resistance)<0.6)then{_center = createCenter east;_grp = createGroup east;_target="soldierGB"}else{_center = createCenter west;_grp = createGroup west;_target="soldierGB"};};
			case civilian: {if ((west getFriend civilian)<0.6)then{_center = createCenter east;_grp = createGroup east;_target="soldierGB"}else{_center = createCenter west;_grp = createGroup west;_target="soldierGB"};};
			default {"ws_assassins DBG: ERROR:  _target1 recognized as SIDE but not a valid one"};
		};
	};
	
	case "OBJECT": {
	_string = format ["%1",typename _target1];
	player sidechat _string;
	_target_type = false;
		switch (side _target1) do {
			case west: {_grp = createGroup east;};
			case east: {_grp = createGroup west;};
			case resistance: {if ((west getFriend resistance)<0.6)then{_grp = createGroup east;}else{_grp = createGroup west;};};
		};
	};
	
	default {player globalchat "ws_assassins DBG: ERROR:  wrong type of target (must be side or name of unit).";};
};

//DEBUG
if (_debug) then {
player globalchat format ["ws_assassins.sqf DEBUG: _unit:%1,_target1:%2,target2:%3,_targettype:%4,_weapon:%5,_weaponmag:%6",_unit,_target1,_target2,_target_type,_weapon,_weaponmag,_chance,_trgsize];

	_string = format ["civ_%1",_unit];
	player sidechat _string;
	_mkr = createMarker [_string, (getPos _unit)];
    _mkr setMarkerType "Dot";
    _mkr setMarkerColor "ColorBlue";
    _mkr setMarkerText  _string;
	
	[_unit,_mkr] spawn {
         while {alive(_this select 0)} do {
         sleep 5;
         (_this select 1) setMarkerPos (getPos (_this select 0));
         };
    };
};

//Wait until 5 seconds in the mission before beginning the loop
waitUntil {time > 5};

//LOOPING
//The magical (and ugly) double loop where it all happens
while {alive _unit} do {
	while {!(_done)} do {
		_unitloc = getPos _unit;
		_listclose = (nearestObjects [_unitloc,["CAManBase"],_trgsize]) - [_unit];

			//DEBUG
			if (_debug) then {
			_string = format ["ws_assassins.sqf DEBUG: Outer Loop. _listclos: %1",_listclose];
			player globalchat _string;
			};
		
		if (_target_type) then {
			{if (((side _x == _target1) && alive _x)) then {_listclosealive set [(count _listclosealive),_x];};} foreach _listclose;
			if ((count _listclosealive) >= _target2) then {
			
					//DEBUG
					if (_debug) then {
					_string = format ["ws_assassins.sqf DEBUG: Civ targeting _listclosealive: %1, sleeping %2",_listclosealive,_sleep];
					player globalchat _string;
					};
					
				sleep _sleep;
				[_unit] join _grp;
				{_unit addMagazine _weaponmag;} forEach [1,2];
				_unit addWeapon _weapon;
				sleep 2+(random 4);							//2 - 4 second delay before the assassin starts engaging
				_unit doTarget (_listclosealive select 0);
				_done = true;
			};
		} else {
			if (_target1 in _listclose) then {
			
				//DEBUG
				if (_debug) then {
					_string = format ["ws_assassins.sqf DEBUG: Civ targeting _target1: %1, sleeping %2",_listclosealive,_sleep];
					player globalchat _string;
				};
				
			sleep _sleep;
			[_unit] join _grp;
			{_unit addMagazine _weaponmag;} forEach [1,2];
				_unit addWeapon _weapon;
			_unit disableAI "autotarget";
			sleep 2+(random 2);							//2 - 4 second delay before the assassin starts engaging
			_unit doTarget _target1;
			waitUntil {!alive _target1 || !alive _unit};
			if (alive _unit) then {_unit enableAI "autotarget";};
			_done = true;
			};
		};
	sleep _perfomancesleep;	
	};
sleep (_perfomancesleep*3);		
};

deletegroup _grp;