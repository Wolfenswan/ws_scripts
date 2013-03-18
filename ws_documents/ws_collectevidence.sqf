private ["_object","_action"];

_object = _this select 0;
_action = _this select 2;
_object removeaction _action;
ws_documentsfound = true;
publicvariable = "ws_documentsfound";