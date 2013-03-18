private ["_pos","_building"];

//And make the building closest to it (which should be the one it's in) indestructible.
_pos = getPos evidence;
_building = _pos nearestObject "Building";
_building allowDamage false;

//This is the action attached to the Evidence object.
//evidence addAction["Collect the evidence.","scripts\ws_collectevidence.sqf", nil, 6, True, True, "", "(_target distance _this) < 2"];
evidence addAction["Collect the evidence.","scripts\ws_collectevidence.sqf", nil, 8, True, True, "", "(_target distance _this) < 2.5"];

if (isNil "ws_documentsfound") then {ws_documentsfound = false;
publicvariable "ws_documentsfound";};