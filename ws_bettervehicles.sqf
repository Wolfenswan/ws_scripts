// better vehicle behaviour miniscript
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature: Vehicle crews will only bail when the vehicle damage is over x (by default 0.8) or the guns are destroyed
//
// Usage: [] execVM "ws_bettervehicles.sqf" in the init.sqf
//
// Customization: 
// To remove dependency on F2, remove the waituntil and change _vehicles = f_var_vehicles to _vehicles = vehicles;

if !(isServer) exitWith {}; 
sleep 0.0001;

// WAIT FOR COMMON VARIABLES TO BE SET
// Before executing this script, we wait for the script 'f_setLocalVars.sqf' to run:

waitUntil {scriptDone f_setLocalVars};

// _vehicles = vehicles;
_vehicles = f_var_vehicles; //f_var_vehicles_BLU f_var_vehicles_RES f_var_vehicles_OPF for faction specific vehicles
_sleep = 1; //increase _sleep when using a lot of vehicles  or you're experiencing sever strain
_alloweddamage = 0.8; //damage allowed before the group bails no matter what

{
_x lockDriver true;
_x allowCrewInImmobile true;
[_x] spawn {
	_unit = _this select 0;
	while {damage _unit < _alloweddamage && canFire _unit} do 
	{
	sleep _sleep;
	};
	_unit allowCrewInImmobile false;
	{_x action ["eject", _unit];} forEach crew _unit;
   };
} forEach _vehicles;