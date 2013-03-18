private ["_pos","_ran","_ranstring","_nearlist","_nearlistvalid","_lastvalidunit"];

//only to be safe
waitUntil {scriptDone f_script_setLocalVars};

_pos = getPos evidence;
evidence setPos [-200,-200];

_nearlist = [];
_nearlistvalid = [];
_nearlist = nearestObjects [_pos,["Man"],20];
{if ((isplayer _x && alive _x)) then {_nearlistvalid set [(count _nearlistvalid),_x];};} foreach _nearlist;
_lastvalidunit = name (_nearlistvalid select 0); 

(_nearlistvalid select 0) addWeapon "EvMoscow";
HQlogic globalchat format ["%1 has collected the documents.",_lastvalidunit];

ws_documentsfound = true;
publicvariable = "ws_documentsfound";