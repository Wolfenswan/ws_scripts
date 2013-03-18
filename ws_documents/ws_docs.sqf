if !(isserver) exitWith {};
waitUntil {scriptDone f_processParamsArray};
private ["_sleep","_mkr","_pos","_mkrpos","_building","_ran","_dbgstring"];

sleep 0.0001;
{deleteVehicle _x;} forEach ws_allsearches;

if (isNil "ws_evidenceplaced") then {ws_evidenceplaced = false;
publicvariable "ws_evidenceplaced";};
if (ws_evidenceplaced) exitWith {};

_pos = [0,0,0];
_ran = floor(random(17));
//this is very ugly but the safest way to do it.
switch _ran do {

case 0:{

  _pos =  [3756.9949, 4282.7983, 3.6451786];
  _dbgstring = 0;
};


case 1:{

  _pos =  [3754.696, 4288.1563, 6.4311037];
  _dbgstring = 1;
};


case 2:{

  _pos =  [4252.3169, 4145.0737, 16.054905];
  _dbgstring = 2;
};


case 3:{

  _pos =  [3942.8933, 4101.7466, 3.2942357];
  _dbgstring = 3;
};


case 4:{

  _pos =  [4248.7603, 4157.4038, 10.250525];
  _dbgstring = 4;
};


case 5:{

  _pos =  [4371.2266, 4236.4087, 3.1099775];
  _dbgstring = 5;
};


case 6:{

  _pos =  [4540.083, 4047.3074, 5.7298365];
  _dbgstring = 6;
};


case 7:{

  _pos =  [4559.1948, 4095.9036, 0.74457139];
  _dbgstring = 7;
};


case 8:{

  _pos =  [4099.917, 4508.2793, 5.5140395];
  _dbgstring = 8;
};


case 9:{

  _pos =  [4103.1318, 4101.6943, 0.00093344215];
  _dbgstring = 9;
};


case 10:{

  _pos =  [4074.8403, 4234.0918, 5.1662273];
  _dbgstring = 10;
};


case 11:{

  _pos =  [4446.77, 4163.9297, 1.1335498];
  _dbgstring = 11;
};


case 12:{

  _pos =  [4626.4546, 4237.8799, 0.80627674];
  _dbgstring = 12;
};


case 13:{

  _pos =  [4843.915, 4605.4492, 4.841043];
  _dbgstring = 13;
};


case 14:{

  _pos =  [4836.7568, 4609.1118, 4.3196096];
  _dbgstring = 14;
};

case 15:{

  _pos =  [4939.8853, 4612.8052, 0.68480092];
  _dbgstring = 15;
};


case 16:{

  _pos =  [4717.189, 3910.7659, 7.2742023];
  _dbgstring = 16;
};

default {
  _pos =  [4717.189, 3910.7659, 7.2742023];
};
};

nul=[_pos]execVM "scripts\ws_evidencehints.sqf";
//DEBUG
if (f_var_debugMode == 1) then {_pos = getPos evidence;_mkr = createMarkerLocal ["dbg_gen",_pos];_mkr setMarkerShapeLocal "ICON";_mkr setMarkerTypeLocal "Dot";_mkr setMarkerTextLocal format ["case:%1",_dbgstring];;};

sleep 1;

evidence setPos _pos;

ws_evidenceplaced = true;
publicvariable "ws_evidenceplaced";


