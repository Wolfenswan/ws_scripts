// Wolfenswan - Tripwire Init
//[[UnitName1,UnitName2],15,5,east] execVM "ws_PlaceTrigger_init.sqf";

// DECLARE VARIABLES AND FUNCTIONS

private ["_units"];

_str = "action";

_units = _this select 0;
_size1 = _this select 1; //Length
_size2 = _this select 2; //Width
_side = _this select 3;


if (isNil "ws_PlaceTrigger") then {ws_PlaceTrigger = []};

ws_fnc_PlaceTrigger = {
		_pos = ws_tripwire select 0;
		_size1 = ws_tripwire select 1;
		_size2 = ws_tripwire select 2;
		_side = ws_tripwire select 3;
		_dir = ws_tripwire select 4;
		_sidestr = format ["%1",_side];
		
		_trg=createTrigger["EmptyDetector",_pos];
		_trg setTriggerArea[_size2,_size1,_dir,true];
		_trg setTriggerActivation[_sidestr,"PRESENT",false];
		_trg setTriggerStatements["this","nul = [thisList,thisTrigger] execVM ""script.sqf"";", ""];
		
		if (side player == _side) exitWith {};
		_mkr = createMarkerLocal [format["%1",_pos], _pos];
		_mkr setMarkerShapeLocal "RECTANGLE";
		_mkr setMarkerSizeLocal [_size2,_size1];
		_mkr setMarkerDirLocal _dir;
		_mkr setMarkerColorLocal "ColorRed";
		_mkr setMarkerBrushLocal "BORDER";
	};

//ADD ACTION
//All designated units have the action to place a trip wire added to their action menu	
	
{_x addAction [_str,"ws_PlaceTriggerAction.sqf",[_size1,_size2,_side],1,false,true,"","(driver _target == _this)"];} forEach _units;

//CREATE EVENTHANDLER

"ws_PlaceTrigger" addPublicVariableEventHandler {call ws_fnc_PlaceTrigger;};