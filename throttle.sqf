//Throttle script by [ARPS] Wolfenswan
//This simple scripts checks if a unit is going over the desired speed 
// and if so disables engine and fuel for a set period

private ["_unit","_speed","_allowedSpeed","_running"];

_unit = _this select 0;
_speed = 0;
//triangulation reduces the array velocity returns to a single number

_allowedSpeed = ((_unit getSpeed "Normal")-1.5);
//we define the allowed movement speed (for infantry "Normal" is a jog at 4.0)

//player sideChat format ["DEBUG throttle running, %1, %2",_speed,_allowedspeed];

while {(true)} do {
//player sideChat format ["DEBUG Loop start, sleeping 10s, %1,%2",_speed,_allowedspeed];
sleep 2;
_speed = sqrt ( (velocity _unit select 0)^2 + (velocity _unit select 1)^2 + (velocity _unit select 2)^2 );
if (_speed > _allowedSpeed) then {
hint "We need to slow down!";
sleep ((random(2))+2);
_speed = sqrt ( (velocity _unit select 0)^2 + (velocity _unit select 1)^2 + (velocity _unit select 2)^2 );
if (_speed > _allowedSpeed) then {
hint "Oh no! Engine failure!";
//player sideChat format ["DEBUG Too fast!, %1,%2",_speed,_allowedspeed];
_unit setHit ["motor", 0.9];
_unit setFuel 0;
sleep (90+(random(30)));
_unit setHit ["motor", 0];
_unit setFuel 1;
hint "Engine was fixed!";
}
}
};