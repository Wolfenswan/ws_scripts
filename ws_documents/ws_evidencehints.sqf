if !(isserver) exitWith {};


waitUntil {scriptDone f_processParamsArray};
private ["_sleep","_mkr","_pos","_mkrpos"];
_pos = _this select 0;

//This is the first marker pinpointing the rough location of the evidence.
//According to parameters this will later be narrowed down (or not)
_mkrpos = [(_pos select 0)+(random(100)- random(100)),(_pos select 1)+(random(100)- random(100)),0];
_mkr = createMarker ["Hint",_mkrpos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerSize [400,400];
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush "BORDER";

sleep 0.0001;
_sleep = ws_var_hint;
if (_sleep == 9999)exitWith{};
sleep _sleep;

hint "The evidence location has been narrowed down.";
_mkrpos = [(_pos select 0)+(random(100)- random(100)),(_pos select 1)+(random(100)- random(100)),0];
_mkr = createMarker ["Hint2",_mkrpos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerSize [200,200];
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush "BORDER";

switch (_sleep) do {
case 1: {sleep 1;};
default {sleep 300};};

hint "The evidence location has further been narrowed down.";
_mkrpos = [(_pos select 0)+random(50)-random(50),(_pos select 1)+(random(50)- random(50)),0];
_mkr = createMarker ["Hint3",_mkrpos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerSize [100,100];
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush "BORDER";

switch (_sleep) do {
case 1: {sleep 1;};
default {sleep 300};};

hint "The evidence location has been pinpointed.";
_mkrpos = [(_pos select 0)+(random(20)- random(20)),(_pos select 1)+(random(20)- random(20)),0];
_mkr = createMarker ["Hint4",_mkrpos];
_mkr setMarkerShape "ELLIPSE";
_mkr setMarkerSize [30,30];
_mkr setMarkerColor "ColorRed";
_mkr setMarkerBrush "BORDER";