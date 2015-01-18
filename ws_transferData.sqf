/*
ws_transferData

Simulates transfer of data from any object, which can then be collected by a unit.
When using the action on  the object the script will create a laptop and display a countdown to all players. Once the countdown finishes the data can be collected from the Laptop.
On collection a message will display who picked up the data and a marker will follow the unit. Should the unit die the data needs to be re-collected from it's corpse.

USAGE
[object to transfer from,timeForTransfer in s] execVM "ws_transferData.sqf";
ideally from the object's init.

To test if a unit has the Data use
(unitName getVariable ["ws_transferData_dataCarrier",false])
it will return true if the unit is in posession of the data.

TODO
Add a convenient way to restrict it to a side for adversarials.
*/

// Configuration
_obj = (_this select 0);

["ws_transferData_runtime",(_this select 1)] call ws_fnc_setGVar;
["ws_transferDone",false] call ws_fnc_setGVar;
["ws_transferStarting",false] call ws_fnc_setGVar;
["ws_transferCollected",false] call ws_fnc_setGVar;

ws_transferData_objAction =
{[
	[_this, {
			if (isServer) then {
				ws_transferStarting = true; publicvariable "ws_transferStarting";
				ws_transferLaptop = "Land_Laptop_unfolded_F" createVehicle (getPosATL (_this select 1));

				ws_transferData_carrierMarker = createMarker ["ws_transferData_carrierMarker",getPosATL (_this select 1)];
				ws_transferData_carrierMarker setMarkerType "mil_dot";
				ws_transferData_carrierMarker setMarkerColor "ColorOrange";
				ws_transferData_carrierMarker setMarkerText "DATA";
			};

			if !(isDedicated) then {
				(_this select 0) removeAction (_this select 2);

				_tick = 0;
				while {_tick != ws_transferData_runtime} do {
							_dots = "";
							for "_i" from 0 to 5 do {
								hintsilent format ["Transfering%1",_dots];
								_dots = _dots + ".";
								uisleep 0.1;};
								uisleep 5;
							_dots = "";
							for "_i" from 0 to 5 do {
							hintsilent format ["Transfering%1",_dots];
							_dots = _dots + ".";
							uisleep 0.1;};
						uisleep 5;
						_tick = _tick + 10;
				};

				ws_transferDone = true; publicVariable "ws_transferDone";
				hintsilent "Transfer finished!";
				cutText [format ["Transfer finished, data can now be collected."],"PLAIN",1];

				ws_transferLaptop addAction ["Collect Data",ws_transferData_collectDataAction,"",5,true,true,"_target distance _this <= 3 && cursorTarget _this == _target"];
			};
		}],"BIS_fnc_spawn",true] spawn BIS_fnc_MP;};

// The action to collect the Data:
ws_transferData_collectDataAction =
{[
	[_this,{
		if (isServer) then {
			(_this select 1) spawn ws_transferData_dataCarrier;
			//(_this select 1) addItem "B_UavTerminal";
			ws_transferCollected = true; publicVariable "ws_transferCollected";
		};

		if !(isDedicated) then {
			(_this select 0) removeAction (_this select 2);
			cutText [format ["%1 has collected the Data",name (_this select 1)],"PLAIN",1];
		};
	}],"BIS_fnc_spawn",true] spawn BIS_fnc_MP;};

// Function to follow the data carrier:
ws_transferData_dataCarrier = {
	_carrier = _this;
	_carrier setVariable ["ws_transferData_dataCarrier",true,true];

	while {alive _carrier} do {
		ws_transferData_carrierMarker setMarkerPos (getPosATL _carrier);
		sleep 1;
	};
	_carrier setVariable ["ws_transferData_dataCarrier",false,true];
	cutText [format ["%1 has died!",name _carrier],"PLAIN",1];
	ws_transferCollected = false; publicVariable "ws_transferCollected";
	_carrier addAction ["Collect Data",ws_transferData_collectDataAction,"",5,true,true,"_target distance _this <= 3 && cursorTarget _this == _target"];
};

_obj addAction ["Begin Transfer",ws_transferData_objAction,"",5,true,true,"_target distance _this <= 5"];