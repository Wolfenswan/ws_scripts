/*
ws_transferData

Simulates transfer of data from any object to a laptop which can then be collected.

*/

// Configuration

ws_transferData_runtime = 60;
//ws_transferData_side = true;

_obj = _this;

if (isNil "ws_transferDone") then {ws_transferDone = false};
if (isNil "ws_transferStarting") then {ws_transferStarting = false};
if (isNIl "ws_transferCollected") then {ws_transferCollected = false};

ws_transferData_objAction =
{[
	[_this, {
			if (isServer) then {
				ws_transferStarting = true; publicvariable "ws_transferStarting";
				ws_transferLaptop = (getPos (_this select 1)) createVehicle /*Latop*/;
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
				cutText [format ["Transfer finished, data has been transfered."],"PLAIN",1]; // TODO Notification?

				ws_transferLaptop addAction ["Pickup Laptop",ws_transferData_laptopAction]; // TODO Conditions etc
			};
		}],"BIS_fnc_spawn",true] spawn BIS_fnc_MP;};

// The action added to the Laptop:
ws_transferData_laptopAction =
{[
	[_this,{
		if (isServer) then {
			deleteVehicle (_this select 0);
			(_this select 1) addItem "B_UavTerminal";
			ws_transferCollected = true; publicVariable "ws_transferCollected";
		};

		if !(isDedicated) then {
			(_this select 0) removeAction (_this select 2);
			[["DataCollected",[format ["%1",name (_this select 1)]]],"bis_fnc_showNotification",true] spawn BIS_fnc_MP;
		};
	}],"BIS_fnc_spawn",true] spawn BIS_fnc_MP;};

_obj addAction ["Collect Data",ws_transferData_objAction]; // TODO Conditions etc