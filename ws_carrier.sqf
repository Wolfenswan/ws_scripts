// Based on BIS_EW_fnc_createLDH by ArMaTeC

if (isNil "ws_LHD_done") then {ws_LHD_done=false;};

//If it's not the server (i.e. a player client) the script exits into a loop that waits for the carrier script to be done
if !(isServer) exitWith {
	//Wait for players to synch and the carrier model to be completely loaded
	player allowDamage false;
	player enableSimulation false;
	waitUntil {!(isNull player) && (player == player)};
	while {!(ws_LHD_done)} do {
	_dots = "";
	for "_i" from 0 to 3 do {
	titleText [format["Preparing mission%1",_dots], "BLACK FADED", 0];
	_dots = _dots + ".";
	sleep 0.3;};};
	player allowDamage true;
	player enableSimulation true;
	titleFadeout 1;
};

publicvariable "ws_LHD_done";

_LHDspawn = _this select 0;
_LHDdir = getdir _LHDspawn;
_LHDspawnpoint = getposasl _LHDspawn;
//deletevehicle _LHDspawn;
_parts = 
[
	"Land_LHD_house_1",
	"Land_LHD_house_2",
	"Land_LHD_elev_R",
	"Land_LHD_1",
	"Land_LHD_2",
	"Land_LHD_3",
	"Land_LHD_4",
	"Land_LHD_5",
	"Land_LHD_6"
];
{
	_dummy = _x createvehicle _LHDspawnpoint;
	_dummy setdir _LHDdir;
	_dummy setpos _LHDspawnpoint;
}foreach _parts;

ws_LHD_done=true;publicvariable "ws_LHD_done";