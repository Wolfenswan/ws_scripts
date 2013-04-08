//using the artillery module to have AI artillery firing at a marker location

if !(isServer) exitWith {};
private ["_hetemplate","_minsleep","_arty","_targetpos","_ransleep"];

_hetemplate = ["IMMEDIATE", "HE", 0, 20];
_minsleep = 60;
_ransleep = 180;

_arty = _this select 0;
_targetpos = getMarkerPos (_this select 1);

//waitUntil {_arty getVariable "BIS_ARTY_LOADED"};

while {true} do {

[_arty, _targetpos, _hetemplate] call BIS_ARTY_F_ExecuteTemplateMission;
waitUntil {_arty getVariable "ARTY_COMPLETE"};
sleep _minsleep + round random _ransleep;
 };