// Group and wave spawn function
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature: 
// Spawns a group of units that can either patrol, attack or guard an area
//
// Usage:
// 1. Paste Code in init.sqf or a seperate.sqf that's executed from the init.sqf
// 2. Call the function during your mission with 
// nul = [side,["spawnmarker" OR object OR valid pos,"targetmarker" OR object OR valid pos],mode("attack","guard","patrol"),size of group, number of respawns] call ws_fnc_createGroup;
// 3. The Function Module must be placed in the editor
//
// Parameters:
// 1.The side of the group: east, west, resistence, civilian
// 2.Array consisting of:
//     spawnlocation: can either be a marker, an object or a valid pos array [x,y,z]
//   movelocation: can either be a marker, an object, a valid pos array [x,y,z]
// 3.Mode (string):
// "attack" - group moves to moveLocation and engages targets on sight
// "patrol" - group moves to moveLocation and starts randomized patrol
// "guard" - group moves to moveLocation and guards the area, manning static vehicles
// 4.Size of group (integer)
// 5.Times the group will respawn after they are died (integer), 0 to disable
//
// Modifyable variables in script
// - classes  the unit is composed of
// - unit combat behaviour
// - chance of stronger units
// - area the unit patrols
//
// ToDo:
// - include vehicle option
// - more flexibility ?


ws_fnc_createGroup = {

   private ["_forcedclasses","_commonclasses","_rareclasses","_rarechance","_patrolarea","_behaviour","_side","_pos","_spawnpos","_movepos","_mode","_size","_respawns","_sideHQ","_ws_fnc_selectrandom","_grp","_side","_availableclasses","_unitarray"];

   //LOCAL VARIABLES - modifyable
   //Edit these variables to your leisure
   
   _mode = ["AWARE","YELLOW"];                                              //Default behaviour and Combatmode
   _forcedclasses = ["GUE_Soldier_CO","GUE_Soldier_1","GUE_Soldier_AR"];               //each class in _forcedclasses will be in the group (only) once
   _commonclasses = ["GUE_Soldier_1","GUE_Soldier_2","GUE_Woodlander1","GUE_Worker1"];    //regular classes included in the group
   _rareclasses = ["GUE_Soldier_AT","GUE_Soldier_MG"];                              //special classes (of _rarechance chance to be in group)
   _rarechance = 25;
   _patrolarea = 250;                                                      //Maximum distance between waypoints for patrolmode
   
   _debug = true;                                                         //Debug mode, activate in case of wonky behaviour

   //LOCAL VARIABLES - scriptside
   
   _side = (_this select 0);
   _spawnpos = ((_this select 1) select 0);
   _movepos = ((_this select 1) select 1);
   _mode = _this select 2;
   _size = _this select 3;
   _respawns = _this select 4;
   
   switch (typename _spawnpos) do {
      case "STRING": {_spawnpos = getMarkerPos _spawnpos;};
      case "OBJECT": {_spawnpos = getPos _spawnpos;};
      case "ARRAY": {};
      default {player globalchat "ws_fnc_createGroup DEBUG: Error _spawnpos class is invalid!";};
   };
   
   switch (typename _movepos) do {
      case "STRING": {_movepos = getMarkerPos _movepos;};
      case "OBJECT": {_movepos = getPos _movepos;};
      case "ARRAY": {};
      default {player globalchat "ws_fnc_createGroup DEBUG: Error _movepos class is invalid!";};
   };
      
   //RANDOM SELECTION FUNCTION
   //To make the code look a bit nicer, we use a simple function to randomly select an element from an array
   //We could use BIS_fnc_selectRandom, but that would require the Funtion Module to be present in the mission
   
   _ws_fnc_selectrandom = {
   _selection = (_this select 0) select (floor round random (count (_this select 0)-1));
   _selection
   };
   
   //GROUP CREATION
   //First a center is created for safe measure (see http://community.bistudio.com/wiki/createCenter)
   //Second we create the group, then we loop as many times as _size and add the units from the three arrays above
   //Thirdly, combat behaviour is set
   
   _sideHQ = createCenter _side;
   _grp = createGroup _side;
   _unitarray = [];
   
   for "_x" from 1 to (_size) do {
      if (_x <= (count _forcedclasses)) then {
      player sidechat format ["%1",_x];
      _unit = _grp createUnit [_forcedclasses select (_x - 1),_spawnpos,[],5,"NONE"];
      } else {
         if ((floor round random 100) < _rarechance) then {
         _unit = _grp createUnit [[_rareclasses] call _ws_fnc_selectrandom,_spawnpos,[],5,"NONE"];
         } else {
         _unit = _grp createUnit [[_commonclasses] call _ws_fnc_selectrandom,_spawnpos,[],5,"NONE"];
         };
      };
   };

   _grp setBehaviour (_behaviour select 0);
   _grp setCombatMode (_behaviour select 1);
   
   
   //WAYPOINT CREATION
   
   _wp = _grp addWaypoint [_movepos,50];
   _wp setWaypointSpeed "NORMAL";
   
   switch (_mode) do {   
      case "attack": {
         _grp setBehaviour "AWARE";
         _grp setCombatMode "RED";
         _wp setWaypointType "SAD";
         _grp setCurrentWaypoint _wp;
      };

      case "guard": {
         _wp setWaypointStatements ["true", "[group this,getPos this] call BIS_fnc_taskDefend;"];
         _grp setCurrentWaypoint _wp;
      };

      case "patrol": {
         _wp setWaypointType "HOLD";
         _wp setWaypointStatements ["true", "[group this,getPos this,_patrolarea] call BIS_fnc_taskPatrol;"];
         _grp setCurrentWaypoint _wp;
      };
   };

   //DEBUG
   //Debug creates various markers and text messages helping to indicate where/when groups are spawned.
   
   if (_debug) then {
   player globalchat format ["DEBUG: ws_spawn. Group created. _grp:%1 of size: %2 with %3 respawns",_grp,count units _grp,_respawns];
   
      _mkr = createMarker [format ["Group_%1",_grp], _spawnpos];
      _mkr setMarkerType "Dot";
      _mkr setMarkerColor "ColorBlue";
      _mkr setMarkerText format ["DBG:group %1",_grp];
      
      _mkr = createMarker [format ["Group_%1-WP",_grp], _movepos];
      _mkr setMarkerType "Dot";
      _mkr setMarkerColor "ColorBlue";
      _mkr setMarkerText format ["DBG:Group_%1-WP",_grp];
      
      [_grp,_mkr] spawn {
         while {alive (leader (_this select 0))} do {
         sleep 5;
         (_this select 1) setMarkerPos (getPos (leader (_this select 0)));
         };
      };
   };
   
   //UNIT RESPAWN
   //Every 5 seconds we'll get a headcount of the group and if it's zero, a new group with the same conditions will spawn
   //To make this work we have to spawn a script run in parallel, as we can't use sleep in call space (where this function is run)
   //and don't need to check every frame, which a while loop without sleep does
   
   if (_respawns > 0) then {
      [_grp,[_side,[_spawnpos,_movepos],_mode,_size,(_respawns - 1)]] spawn {
      _grp = _this select 0;
      _args = _this select 1;
      
      _check = count units _grp;
      while {_check > 0} do {
         _check = {alive _x} count units _grp;
         sleep 5;
      };
      _args call ws_fnc_createGroup;
      };
   };
};