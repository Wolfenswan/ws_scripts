// Simple mine detector script. Mine detector will behave similarly to a geiger counter and play a crescending beep the closer to a mine the unit is.

// Radius in which to detect mines
_radius = 80;

// wait into the mission
sleep 0.1;

// begin main loop
while {alive player} do {

	// Only proceed if the player does have a mine detector
	waitUntil {sleep 0.1;"MineDetector" in (items player)};

	// Get all mines in the given radius
	_nearmines = [];
	{
		if (_x distance player <= _radius) then {
			_nearmines pushback (_x);
		};
	} forEach allMines;


	// Resize the array until only one mine is left
	while {count _nearmines > 1} do {
		if (((_nearmines select 0) distance player > (_nearmines select 1) distance player)) then {_nearmines deleteAt 0} else {_nearmines deleteAt 1};
	};

	if (count _nearmines == 1) then {
		_nearestmine = _nearmines select 0;
		uisleep (((_unit distance _nearestmine)/25) max 0.1); //sleep in shorter intervals but at least 0.1 seconds

		// "Tock"
		//playSound3D ["A3\missions_f\data\sounds\click.wss", _unit, false, eyePos _unit, 4, 5, 3];

		// "Ping"
		playSound3D ["a3\missions_f_beta\data\sounds\firing_drills\drill_start.wss", _unit, false, eyePos _unit, 3, 2, 3];
	};

	sleep 0.1;
};