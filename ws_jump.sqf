//addaction

waitUntil {!isNull player};
player action [ "eject", vehicle player];
player spawn bis_fnc_halo;
player setvelocity [0,120*0.8,0];
player setdir 0;

while {((getposATL player)select 2) > 1} do
{
hintsilent format ["Altimeter: %1", round (getPosATL player select 2)];
};
if (((getposATL player)select 2) < 1) then
{
hintsilent "";
};