/*
Turns a civilian offroad into a black police offroad with working beacons

This execVM "ws_copcar.sqf" from unit init. No locality restrictions, needs to run for each client.
*/

_this addAction ["Beacons On",{(_this select 0) animate ["BeaconsStart",1]},[],50,false,true,"","_target animationPhase 'BeaconsStart' < 0.5 AND Alive(_target) AND driver _target == _this"];
_this addAction ["Beacons Off",{(_this select 0) animate ["BeaconsStart",0]},[],51,false,true,"","_target animationPhase 'BeaconsStart' > 0.5 AND Alive(_target) AND driver _target == _this"];
{_this setObjectTexture [_x,'#(argb,8,8,3)color(0.03,0.03,0.03,0.5)'];} forEach [0,1,2];
_this animate["hidePolice",0];
_this animate ["HideBumper1", 0];
_this animate ["HideBumper2", 0];
_this animate ["HideDoor1", 0];
_this animate ["HideDoor2", 0];
_this animate ["HideDoor3", 0];
_this animate ["HideGlass2", 0];
_this animate ["BeaconsStart",1];
