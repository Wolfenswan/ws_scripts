//Wait for clients to synch
sleep 0.1;
waitUntil {!(isNull player)};
waitUntil {(player == player)};
waitUntil { time > 0 };
player allowDamage false;
player enableSimulation false;
while {!(ws_initdone)} do {
_dots = "";
for "_i" from 0 to 3 do {
titleText [format["Preparing mission%1",_dots], "BLACK FADED", 0];
_dots = _dots + ".";
sleep 0.3;};};
player allowDamage true;
player enableSimulation true;
titleFadeout 1;