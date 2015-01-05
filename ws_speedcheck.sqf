// Check the speed of a unit passing the trigger against an allowed limit

private ["_unit","_speed","_allowedSpeed","_trigger","_ammotype","_chance","_variance","_variancey","_rand"];

_trigger = _this select 0;
_unit = _this select 1;

_speed = sqrt ( (velocity _unit select 0)^2 + (velocity _unit select 1)^2 + (velocity _unit select 2)^2 ); // getspeed is in different units
_allowedSpeed = 3.9; //(_unit getSpeed "Normal")-0.1;
                     // For an infantry unit, slow/norm/fast are 2.7/4/6.666 or thereabouts

// Check speed
if (_speed > _allowedSpeed) then {
	_trigger setpos [-200,-200];
	deleteVehicle _trigger;
};