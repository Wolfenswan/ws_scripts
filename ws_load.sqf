// Load cargo space miniscript
// By Wolfenswan: wolfenswanarps@gmail.com 
//
// Feature: Easy way to adjust cargospace in vehicles/ammo boxes
//
// Usage: 
// nul = [this,"type"] execVM "scripts\ws_load.sqf";
// replace "type" with any case given below
//
// Customization: 
// Add a or tweak a case following the examples below

private ["_unit","_type"];

_unit = _this select 0;
_type = _this select 1;

clearWeaponCargoGlobal _unit;
clearMagazineCargoGlobal _unit;

switch (_type) do {


case "usmc": {
_unit addWeaponCargoGlobal ["M16A2", 8];
_unit addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 48];
_unit addMagazineCargoGlobal ["HandGrenade_West", 10]; 
_unit addMagazineCargoGlobal ["SmokeShell", 10];
};

case "ru": {
_unit addWeaponCargoGlobal ["AK_107_kobra", 6];
_unit addMagazineCargoGlobal ["30Rnd_545x39_AK", 60];
_unit addMagazineCargoGlobal ["AT13", 2];  
_unit addMagazineCargoGlobal ["SmokeShell", 20];
_unit addMagazineCargoGlobal ["HandGrenade_East", 20]; 
_unit addMagazineCargoGlobal ["Igla", 2]; 
_unit addMagazineCargoGlobal ["RPG18", 12]; 
_unit addMagazineCargoGlobal ["100Rnd_556x45_BetaCMag",20];
_unit addMagazineCargoGlobal ["100Rnd_762x54_PK",4];
};

case "ammo": {
_unit addMagazineCargoGlobal ["30Rnd_545x39_AK", 40];
_unit addMagazineCargoGlobal ["SmokeShell", 20];
_unit addMagazineCargoGlobal ["HandGrenade_East", 20]; 
_unit addMagazineCargoGlobal ["100Rnd_556x45_BetaCMag",20];
};

case "cdf": {
_unit addMagazineCargoGlobal ["30Rnd_545x39_AK", 40];
_unit addMagazineCargoGlobal ["AT13", 2]; 
_unit addMagazineCargoGlobal ["1Rnd_HE_GP25", 20]; 
_unit addMagazineCargoGlobal ["1Rnd_Smoke_GP25", 20];
_unit addMagazineCargoGlobal ["RPG18", 10]; 
_unit addMagazineCargoGlobal ["100Rnd_556x45_BetaCMag",40];
 _unit addMagazineCargoGlobal ["100Rnd_762x54_PK",20];
 _unit addMagazineCargoGlobal ["HandGrenade_East", 20]; 
 };
 
 case "gue": {
_unit addMagazineCargoGlobal ["30Rnd_545x39_AK", 80];
_unit addMagazineCargoGlobal ["1Rnd_HE_GP25", 20]; 
_unit addMagazineCargoGlobal ["1Rnd_Smoke_GP25", 20]; 
_unit addMagazineCargoGlobal ["AT13", 6];  
_unit addMagazineCargoGlobal ["SmokeShell", 20]; 
_unit addMagazineCargoGlobal ["Igla", 10]; 
_unit addMagazineCargoGlobal ["RPG18", 20]; 
_unit addMagazineCargoGlobal ["100Rnd_556x45_BetaCMag",40];
 _unit addMagazineCargoGlobal ["100Rnd_762x54_PK",20];
 _unit addMagazineCargoGlobal ["5Rnd_127x108_KSVK",10]; 
 _unit addMagazineCargoGlobal ["pipebomb",10];
 _unit addMagazineCargoGlobal ["HandGrenade_East", 20];
 };

case "chinook": {
_unit addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 100];
_unit addMagazineCargoGlobal ["M136", 20];  
_unit addMagazineCargoGlobal ["SmokeShell", 20];
_unit addMagazineCargoGlobal ["HandGrenade_West", 20]; 
_unit addMagazineCargoGlobal ["MAAWS_HEAT", 10]; 
_unit addMagazineCargoGlobal ["MAAWS_HEDP", 10];
_unit addMagazineCargoGlobal ["Javelin", 10];
_unit addMagazineCargoGlobal ["Stinger", 10]; 
_unit addMagazineCargoGlobal ["100Rnd_762x51_M240",40];
_unit addMagazineCargoGlobal ["100Rnd_556x45_M249",40];
};

case "merlin": {
_unit addMagazineCargoGlobal ["30Rnd_556x45_Stanag", 40];
_unit addMagazineCargoGlobal ["M136", 10];  
_unit addMagazineCargoGlobal ["SmokeShell", 10];
_unit addMagazineCargoGlobal ["HandGrenade_West", 10]; 
_unit addMagazineCargoGlobal ["MAAWS_HEAT", 5]; 
_unit addMagazineCargoGlobal ["MAAWS_HEDP", 5];
_unit addMagazineCargoGlobal ["Javelin", 2];
_unit addMagazineCargoGlobal ["Stinger", 2]; 
_unit addMagazineCargoGlobal ["100Rnd_762x51_M240",20];
_unit addMagazineCargoGlobal ["100Rnd_556x45_M249",20];
};
 
 case "acre": {
_unit addWeaponCargoGlobal ["ACRE_PRC343", 50];
_unit addWeaponCargoGlobal ["ACRE_PRC148_UHF", 50];
_unit addWeaponCargoGlobal ["ACRE_PRC148", 50];
_unit addWeaponCargoGlobal ["ACRE_PRC119", 50];
_unit addWeaponCargoGlobal ["ACRE_PRC117F", 50];
}; 

 
 case "acre_heli": {
_unit addWeaponCargoGlobal ["ACRE_PRC343", 10];
_unit addWeaponCargoGlobal ["ACRE_PRC148_UHF", 10];
_unit addWeaponCargoGlobal ["ACRE_PRC148", 10];
_unit addWeaponCargoGlobal ["ACRE_PRC119", 10];
_unit addWeaponCargoGlobal ["ACRE_PRC117F", 10];
}; 

};
