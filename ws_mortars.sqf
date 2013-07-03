// Mortar shelling & illumination function
// v1 (14.04.2013)
// By Wolfenswan [FA]: wolfenswanarps@gmail.com | folkarps.com
//
// Feature: 
// Spawns mortar shells where you want them without the need to use the arty module or physical mortar units. It shifts from parsed target to target then stops.
//
// Requires: ws_fnc library
//
// Usage:
// 1. Paste Code in file named ws_mortars.sqf and copy the file in a folder named scripts in your mission folder
// 2. Place the markers indicating the target center and name them "marker1", "marker2" (etc) or similar
// 2. Call: ["mkr1"] execVM "scripts\ws_mortars.sqf" during the mission
// 4. Full parameters: [["target1","target2"],500,15,[2,4,30,1,1],[10,20]
// 
// Returns:
// True
//
// Parameters:
// 1. Target or array of targets (can be marker, objects etc.)									 	| MANDATORY
// 2. Frequency of the shelling - the time until the barrage shifts to the next target				| OPTIONAL - default is 10 minutes
// 3. The time between the flare indicating the target area and the first splash					| OPTIONAL - default is 5 seconds
// 4. An array detailing the barrage:	
//		1. Numbers of barrages																| OPTIONAL - default is 2
// 		2. Shots per barrage																| OPTIONAL - default is 3
//		3. Sleep between each barrage														| OPTIONAL - default is 30 seconds
//		4. Randomization (up to this many extra shots could fall)							| OPTIONAL - default is 0
//		5. Randomization (up to this many extra full barrages could fall)					| OPTIONAL - default is 0
// 5. Array containing to integers for the minimal and maximum dispersion [0,0] = spot on	| OPTIONAL - default is [20,60];

if !(isServer)exitWith {};

private ["_shell","_illumshell","_height","_dispersionv","_dispersion",
"_frequency","_illumsleep","_barrages","_extrabarrages","_timebetweenbarrages","_shotsperbarrage","_extrashots","_count","_targets"];

//Modifyable variables
_shell = "ARTY_Sh_81_HE";       //type of shell. See http://browser.six-projects.net/cfg_ammo/classlist?utf8=%E2%9C%93&version=58&commit=Change
_illumshell = "F_40mm_red";    //illumination round.
_height = 250;                 //the minium height where the shell will spawn (250 is good)

//Setting default values
_frequency = 600;             //frequency of target changing in seconds
_illumsleep = 5;             //how long the illumination round lingers in seconds before the real rounds hit. (0 to deactivate)
_barrages = 2;                //minium number of barrages fired on one target before change
_timebetweenbarrages = 30;       //the time in seconds between each single barrage
_shotsperbarrage = 3;          //minimum shots/shells that come down per barrage
_extrashots = 0;            //Up to this many more shells COULD come down
_extrabarrages = 0;            //Up to this many more barrages COULD be fired
_dispersionv = [20,60];        //the default min-max disperson range of shells ([0,0] = all spot on)


//[["mkr1","mkr2"],600,3,[2,4,30,1,0]] call XYZ

//Getting variables from parsed arguments
_count = count _this;
_barray = [];
_targets = _this select 0; if (typename _targets != "ARRAY") then {_targets = [_targets]};
if (_count > 1) then {_frequency = _this select 1;};
if (_count > 2) then {_illumsleep = _this select 2;};
if (_count > 3) then {_barray = _this select 3;};
if (count _barray > 0) then {_barrages = _barray select 0;};
if (count _barray > 1) then {_shotsperbarrage = _barray select 1;};
if (count _barray > 2) then {_timebetweenbarrages = _barray select 2;};
if (count _barray > 3) then {_extrashots = _barray select 3;};
if (count _barray > 4) then {_extrabarrages = _barray select 4;};
if (_count > 4) then {_dispersionv = _this select 4;};

_dispersion = (round (random (_dispersionv select 1))) - (round (random (_dispersionv select 0)));

//The loop
while {count _targets > 0} do {
_target = _targets call ws_fnc_selectRandom;
_targets = _targets - [_target];
_pos = [_target,0,false,true,true] call ws_fnc_getPos;
sleep 1 + (random 2);

	for "_x" from 1 to (_barrages + round(random(_extrabarrages))) do {
	if (_illumsleep > 0) then {createVehicle [_illumshell, [_pos select 0,_pos select 1,150], [], _dispersion, "NONE"];sleep _illumsleep;};
		for "_x" from 1 to (_shotsperbarrage + round(random (_extrashots))) do {
			_boom = createVehicle [_shell, _pos, [], _dispersion, "NONE"];
			_boom setPos [getPos _boom select 0,getPos _boom select 1,_height + round random 50];
			sleep 1 + (random 5);
		};
	sleep _timebetweenbarrages;
	};
	sleep _frequency;
};

true