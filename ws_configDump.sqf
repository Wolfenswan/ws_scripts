///////// ARMA3 Config CSV EXPORT
///////// Usage: [name,CfgPatches name]
///////// Usage: [name] to export bis stuff
///////// Usage: Paste everything below in the debug console and run it (or exec as script)

private ["_CfgPatches","_configPath","_collectionName","_getClass","_out","_wepsEx","_itemsEx","_magsEx","_backEx","_weapons","_backpacks","_magazines","_configName","_picture","_parents","_type","_classname","_mags","_mass","_capacity","_armor","_passthrough","_append","_ammo"];

_CfgPatches = false;
_configPath = "";
_collectionName = "test";
if(count [] > 1) then
{
	_configPath = _configPath + _this select 1;
	_CfgPatches = true;
};

_getClass = {
	_out = "";
	if(typename _this == "STRING") then
	{
		_out = _this;
	}
	else
	{
		_out = configName _this;
	};
	_out;
};


_wepsEx = [];
_itemsEx = [];
_magsEx = [];
_backEx = [];
_weapons = [];
_backpacks = [];
_magazines = [];
if(_CfgPatches) then
{
	_weapons = _weapons + getArray(configfile >> "CfgPatches" >> _configPath >> "weapons");
	_backpacks = _backpacks + getArray(configFile >> "CfgPatches" >> _configPath >> "units");
}
else
{
	_magazines = [configfile >> "CfgMagazines"] call BIS_fnc_returnChildren;
	_weapons = [configFile >> "CfgWeapons"] call BIS_fnc_returnChildren;
	_backpacks = [configFile >> "CfgVehicles"] call BIS_fnc_returnChildren;
};

{
	_configName = _x call _getClass;
	_name = getText(configFile >> "CfgWeapons" >> _configName >> "displayname");
	_picture = getText(configFile >> "CfgWeapons" >> _configName >> "picture");
	if(_name != "" && _picture != "" && !(isClass (configFile >> "CfgWeapons" >> _configName >> "LinkedItems"))) then
	{
		_parents = [_x, true] call BIS_fnc_returnParents;
		_type = switch true do {
			case ((configname inheritsFrom (Configfile >> "CfgWeapons" >> _configName >> "ItemInfo")) == "InventoryOpticsItem_Base_F"): {"OpticAttachment"};
			case ((configname inheritsFrom (Configfile >> "CfgWeapons" >> _configName >> "ItemInfo")) == "InventoryMuzzleItem_Base_F" || getText(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "muzzleend") != ""): {"MuzzleAttachment"};
			case ((configname inheritsFrom (Configfile >> "CfgWeapons" >> _configName >> "ItemInfo")) == "InventoryFlashLightItem_Base_F"): {"SideAttachment"};
			case ("Rifle" in _parents):				{"PrimaryWeapon"};
			case ("Pistol" in _parents):			{"SecondaryWeapon"};
			case ("Launcher" in _parents):			{"Launcher"};
			case ("H_HelmetB" in _parents):			{"HeadGear"};
			case ("Uniform_Base" in _parents):		{"Uniform"};
			case ("Vest_Camo_Base" in _parents || "Vest_NoCamo_Base" in _parents): {"Vest"};
			case ("ItemCore" in _parents || "DetectorCore" in _parents): {"CommonItem"};
			case ("ItemMap" in _parents):		{"Map"};
			case ("ItemWatch" in _parents):		{"Watch"};
			case ("ItemCompass" in _parents):		{"Compass"};
			case ("ItemGPS" in _parents):		{"GPS"};
			case ("ItemRadio" in _parents):		{"Radio"};
			case ("NVGoggles" in _parents || _configName == "NVGoggles"): {"NVGoggles"};
			case ("Binocular" in _parents): {"Binocular"};
			default {"unknown"};
		};

		if(_type == "unknown") exitWith {systemChat _configName};
		_classname = _configName;
		_mags = getArray(configFile >> "CfgWeapons" >> _configName >> "magazines");

		if(_CfgPatches) then
		{
			_magazines = _magazines + _mags;
		};

		if(_type in ["PrimaryWeapon","SecondaryWeapon","Launcher"]) then
		{
			_mass = getNumber(configFile >> "CfgWeapons" >> _configName >> "WeaponSlotsInfo" >> "mass");
			_capacity = 0;
			_wepsEx = _wepsEx + [[_name,_type,_classname,_mags,_mass]];
		};

		if(_type != "unknown" && !(_type in ["PrimaryWeapon","SecondaryWeapon","Launcher"]) ) then
		{
			_mass = getNumber(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "mass");
			_capacity = getText(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "containerclass");

			if(_capacity != "") then
			{
				_capacity = getNumber(configFile >> "CfgVehicles" >> _capacity >> "maximumload");
			}
			else
			{
				_capacity = "N/A";
			};

			_armor = 0;
			switch (_type) do {
				case "HeadGear": {_armor = (getNumber(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "armor"))};
				case "Vest": {
					_armor = [];
					{
					_armor pushback format ["%1:%2",_x,getNumber(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "armor")];
					} forEach ["Neck","Arms","Chest","Diaphragm","Abdomen","Body"];
				};
				default {_armor = "N/A"};
			};

			_passthrough = 0;
			switch (_type) do {
				case "HeadGear": {_passthrough = getNumber(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "HitpointsProtectionInfo" >> "Head" >> "passthrough")};
				case "Vest": {
					_passthrough = [];
					{ _passthrough pushback format ["%1:%2",_x,getNumber(configFile >> "CfgWeapons" >> _configName >> "ItemInfo" >> "HitpointsProtectionInfo" >> _x >> "passthrough")];
					} forEach ["Neck","Arms","Chest","Diaphragm","Abdomen","Body"];
				};
				default {_passthrough = "N/A"};
			};


			_itemsEx append [[_name,_type,_classname,_mass,_capacity,_armor,_passthrough]];
		};
	};
} foreach _weapons;

{

	private ["_configName","_picture","_mass","_ammocount","_ammo"];
	_configName = _x call _getClass;
	_name = getText(configFile >> "CfgMagazines" >> _configName >> "displayname");
	_picture = getText(configFile >> "CfgMagazines" >> _configName >> "picture");
	_mass = getNumber(configFile >> "CfgMagazines" >> _configName >> "mass");
	_ammocount = getNumber(configFile >> "CfgMagazines" >> _configName >> "count");
	_ammo = getText(configFile >> "CfgMagazines" >> _configName >> "ammo");
	if(_name != "" && _picture != "") then
	{
		_classname = _configName;
		_magsEx append [[_name,"magazine",_classname,_mass,_ammocount,_ammo]];
	};
} foreach _magazines;

{
	private ["_configName","_parents","_picture","_mass","_capacity"];
	_configName = _x call _getClass;
	_parents = [(configFile >> "CfgVehicles" >> _configName), true] call BIS_fnc_returnParents;
	_name = getText(configFile >> "CfgVehicles" >> _configName >> "displayname");
	_picture = getText(configFile >> "CfgVehicles" >> _configName >> "picture");
	_mass = getNumber(configFile >> "CfgVehicles" >> _configName >> "mass");
	_capacity = getNumber(configFile >> "CfgVehicles" >> _configName >> "maximumload");
	if(_name != "" && _picture != "" && !(isClass (configFile >> "CfgVehicles" >> _configName >> "TransportItems")) && "Bag_Base" in _parents && _configName != "Bag_Base") then
	{
		_backEx append [[_name,"bag",_configName,_mass,_capacity]];

	};
} foreach _backpacks;

diag_log "--- CONFIG DUMP SHEET 1 CSV START ---";
diag_log text("name;type;class name;mass;capacity;mags/calibre");
{
	_name = _x select 0;
	_type = _x select 1;
	_classname = _x select 2;
	_magazines = _x select 3;
	_mass = _x select 4;
	diag_log text(format["%1;%2;%3;%4;%5;%6",_name,_type,_classname,_mass,"N/A",_magazines]);
} forEach _wepsEx;

{
	_name = _x select 0;
	_type = _x select 1;
	_classname = _x select 2;
	_mass = _x select 3;
	_capacity = _x select 4;
	_ammo = _x select 5;
	diag_log text(format["%1;%2;%3;%4;%5;%6",_name,_type,_classname,_mass,_capacity,_ammo]);
} forEach _magsEx;

diag_log "--- CONFIG DUMP CSV SHEET 1 END ---";

diag_log "--- CONFIG DUMP SHEET 2 CSV START ---";
diag_log text("name;type;class name;mass;capacity;armor;passthrough");
{
	_name = _x select 0;
	_type = _x select 1;
	_classname = _x select 2;
	_mass = _x select 3;
	_capacity = _x select 4;
	_armor = _x select 5;
	_passthrough = _x select 6;
	diag_log text(format["%1;%2;%3;%4;%5;%6;%7;%8", _name,_type,_classname,_mass,_capacity,_armor,_passthrough]);
} forEach _itemsEx;

{
	_name = _x select 0;
	_type = _x select 1;
	_classname = _x select 2;
	_mass = _x select 3;
	_capacity = _x select 4;
	diag_log text(format["%1;%2;%3;%4;%5",_name,_type,_classname,_mass,_capacity]);
} forEach _backEx;

diag_log "--- CONFIG DUMP CSV SHEET 2 END ---";