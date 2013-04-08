// better vehicle behaviour miniscript
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature: Vehicle crews will only bail when the vehicle damage is over x (by default 0.8) or the guns are destroyed
//
// Usage: [side,0.8] execVM "ws_bettervehicles.sqf" in the init.sqf
//

if !(isServer) exitWith {}; 

private ["_alloweddamage","_debug","_selection","_vehicles","_selection","_side"];

_debug = false; if !(isNil "ws_debug") then {_debug = ws_debug};   //Debug mode. If ws_debug is globally defined it overrides _debug

// Usage with F2:
// waitUntil {scriptDone f_setLocalVars};
// _vehicles = f_var_vehicles; //f_var_vehicles_BLU f_var_vehicles_RES f_var_vehicles_OPF
_selection = vehicles;

// We collect all crewed vehicles on the map
_side = _this select 0;
_alloweddamage = _this select 1; //damage allowed before the group bails no matter what

_vehicles = [];
{if ((count crew _x > 0) && !(_x isKindOf "StaticWeapon")&& side _x == _side) then [{
	_vehicles = _vehicles + [_x];},{if _debug then {player sidechat format ["ws_bettervehicles DBG: %1 has no crew or is a static weapon",_x]};}];
} forEach _selection;



if _debug then {player sidechat format ["ws_bettervehicles DBG: _vehicles: %1",_vehicles]};

{
if (isNil format["%1",(_x getVariable "ws_better_vehicle")]) then {
	[_x,_alloweddamage,_debug] spawn {
		private ["_unit","_alloweddamage"];
		_unit = _this select 0;
		_unit allowCrewInImmobile true;
		_unit setvariable ["ws_better_vehicle",true];	
		_alloweddamage = _this select 1;
		
		while {damage _unit < _alloweddamage && canFire _unit} do 
		{
			sleep 2.5;
		};
		_unit allowCrewInImmobile false;
		{_x action ["eject", _unit];} forEach crew _unit;
		if (_this select 2) then {player sidechat format ["ws_bettervehicles DBG: %1 has taken enough damage or can't fire any more. crew bailing",_unit]};
	   };
   };
} forEach _vehicles;