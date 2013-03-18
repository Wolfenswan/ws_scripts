//                     .-://+++//:.`                  
//                -+shdhhhshdshymmdddyo:`             
//             :sddmsym+hh+hd+symmoydomdmh+.          
//          .ommhoshshssmmhdddmdNddyodyoyhhNy:        
//        `smmymmhsmdmyo/:-....-:/ohmNhydmodymh:      
//       /mdssoyhNdo-` ``:/+ooo/-``.`-ommddyyydNs`    
//      omhymmsmmo:..:-/oo+syyyys:.:+//:hhmmsyhsmd.   
//     smyy/yhms/-:-hhyso//oyyyyyyos/.s o dNdhsyymm.  
//    +mhohyhd- .o/  ./yhhhhhhhdmo. `     :+mNomdymd` 
//   .mysoohm-`+hdd/`   :ymmhyho`          +.mmshssNo 
//   omyysym+ +hhddmd+. ``-smy.           +: /Nmsshdm 
//   hmmmmmN.`hhhhdddmNdo/+/`          .+o//.`mmmmmmN-
//   mmmmmmN`-dddhssyhmNNy-           sh+:/y/ dNmmmmN:
//   dmmmmNN:/o:       `.             .+yhyh: dNmmmmN-
//   smmmmmNo+/:.``..`                   .hd.-Nmmmmmm`
//   -mmmmmNd`-mNNNN+`         `:ss+///+hdho-ymmmmmms 
//    smmmmmNy`-mmy-         .odddNyh.` .h+ ommmmmmm` 
//    `hmmmmmNh./+so+ooosss. ymhhhhNm` --/.ymmmmmmm:  
//     `ymmmmmmmo`-smmmmNmh-ymddddmN+ -y.+dmmmmmmm:   
//       ommmmmymms-.+ymmmNdmddddmmh/.symdhymmmmh.    
//        -hmdshhsydmy+:-:/+oo+//:-/sNNddsddsmm+      
//         :hNdssydshyNmmmddddmmmNdNymosyyhd+`       
//            .oddhhsshoNmsNmoyydmosmmyyNmy:          
//               .+yddNhdhdMmdyyhhomddho:             
//                   `-/+osyyyyss+/-` 
//
//   
// ----------------------------------------------------------------------------------
// ADMIRE THE ARPS LOGO ABOVE
// WOLFENSWANS CIVILIAN ASSASSINS FOR FUN AND PROFIT  V2
//
// Troubleshooting and comments:
// http://www.rockpapershotgun.com/forums/showthread.php?3521-EDITING-Wolfenswan-s-random-and-not-so-random-armed-civilians-and- concealed-gunmen

1. Installation
2. Light Version
3. Advanced Version
4. Dynamic Version (tba.)
5. Disclaimer


============== Installation ================

1. Place the scripts Folder in your mission folder.

2.Use either one of the following methods, not both (the advanced/light) as that will create duplicates.
The ALICE version and the first one for preplaced units work fine together.

**For a single civilian unit:**
Add one of the following command lines to a unit's init, adapt them as described further below.

Light Version: 		nul = [this,100,west,10] execVM "scripts\ws_assassins_light.sqf";
Advanced Version: 	nul = [this,"","",100,10,0,west,1,0,1,0] execVM "scripts\ws_assassins.sqf";


**For all civilian units:**
See Advanced Version Point 11. on how to customize this method.
If you want to add it to all civilians put this in the init.sqf:

nul = ["","","",(round(random)100),(round((random)10)+10),0,west,(round(random)5),0,1,(random(1)),1] execVM "scripts\ws_assassins.sqf";


**Using with the ALICE module**
See Advanced Version on how to customize this method. DO NOT change the first and last parameter!

Put this in the ALICE module init:

[BIS_alice_mainscope,"ALICE_civilianinit",[{nul = [_this,"","",50,10,0,west,1,0,1,0] execVM 'scripts\ws_assassins.sqf'}]] call BIS_fnc_variableSpaceAdd;


3. If everything's working the civilian will wait for 0-8 seconds when a target unit enters his radius, pull his gun  and start shooting.
Modify the _sleep var in the sqf for a shorter/longer sleeping span.
Change the _flee var in the sqf to 1 if you want the "sleepers" to flee like normal civs as long as they aren't attacking.


=============== LIGHT VERSION =================

//nul = [this,100,west,10] execVM "scripts\ws_assassins_light.sqf";

From left to right:
1. Has to be this in the light version							| (this)

2. The chance in 100 that the civilian will actually pull a weapon and shoot 		| (0-100) or random X
								

3. MOST IMPORTANT. What the civilian will attack:
   If set to on west,east or resistance he will trigger when any alive unit of that type is near
   By default the weapon is a randomized small arm. For different weapons edit the two arrays in ws_assassins_light.sqf or use the advanced Version


4. The radius around the civilian where his target triggers him					| (any number) or random

=============== ADVANCED Version =========================
nul = [this,"Sa61_EP1","20Rnd_B_765x17_Ball",100,10,0,west,1,0,1,0] execVM "scripts\ws_assassins.sqf";


From left to right:
1. Has to be this in a unit inititilization or the name of an existing (civilian) unit 		| (this or objectname)

2. The intended Weapon class or "" for random weapon from the _weaponarr in ws_assassins.sqf	| (any legal weapon class) or ""

3. The magazine of the intended class or "" for the correct magazine for a random weapon	| (any legal magazine class) or ""

4. The chance in 100 that the civilian will actually pull a weapon and shoot 			| (0-100) or random X

5. The radius around the civilian that triggers him 						| (any number)

6. The Switch for target mode - relevant for 7.,8. & 9. See those entries			| (0 or 1)

7. MOST IMPORTANT. 
   What the civilian will attack:
   If set to on west,east or resistance it will trigger when any alive unit of that type is near
   If 6. is set to (1) and 7 is a unitname, it will wait until the specified unit is in the area.
	
8. How many units of the selected target side have to be in the area before the civilian	| (any number over 0) or random
   triggers. Should be (1) in target mode (1). Any number for target mode (0)

9. Focus switch - only works in target mode (1). The civilian will focus on the target alone	| (0 or 1)
   he won't attack any other units

10. The skill level of the civilian. Can be anything from 0 to 1, including decimals.		| (any number 0 to 1) or random
   See http://community.bistudio.com/wiki/setSkill

11.Switch to control between apply to all civilians (1) or only the specified one (0)		| (0 or 1)
   1.,2.,3.,9. are ignored when set to (1)
   6. and 7. are read in (1) but should be set to (0) and a side.
   4.,5. and 8. are read in (1) and should be randomized.
   In (1) The Weapons are randomly taken from an array. Modify this array in the ws_assassins.sqf.
   Note that the weapon and it's corresponding magazine have to be in the same place in their 
   respective arrays.

*Examples:
Default: random weapon, 100% chance, radius of 10, enemy is a side (west)
nul = [this,"","",100,10,0,west,1,0,1,0] execVM "scripts\ws_assassins.sqf";

specific weapon weapon, 25-50% chance, radius of 10, enemy is a unit (unit1) - note the switch before unit 1 is set to (1).
nul = [this,"Sa61_EP1","20Rnd_B_765x17_Ball",(random(25))+25),10,1,unit1,1,0,1,0] execVM "scripts\ws_assassins.sqf";

all civilians (last switch is set to (1)), random weapon, 0-50% chance, radius of 10-20, enemy is a side (east)
nul = ["","","",random(50),10+random(10),0,east,1,0,1,1] execVM "scripts\ws_assassins.sqf";

=============== DISCLAIMER ================================

As if I'd care.
Well don't use my script to distribute Child Porn.
Or filthy imperialist propaganda.
If your box blows up it's not my fault. Ever.
If you say it's my fault I'll just put my hands on my ears and sing very very loud until you go away.
