closed_chest 0.5
Copyright (c) 2013 pandaro <padarogames@gmail.com>

sourcecode:https://github.com/pandaro/closed_by_key
code:GPLv3
pictures:WTFPL
depends:default
contributors:0gb.us(chest start code) & PilzAdam(door start code)

THIS MOD ADD:CHEST and DOOR closed by KEY, an EMPTY KEYRING for store keys in a FULL KEYRING.And a KEY-MANAGER to handle their 

CRAFTING:

O=empty slot
S=steel ingot
C=chest
D=dry shrub
M=Mese
T=Stone

-Steel chest:

SSS
SOS
SSS

-Steel door:
SS
SS
SS

-Disguised chest:
TTT
TOT
TTT

-Disguised door:
TT
TT
TT

Mese chest:
MMM
MOM
MMM

Mese door:
MM
MM
MM

-Empty keyring:
DOD
ODO
DOD

-Key-manager:
M
C



How to:
CHEST:
-place the chest; in your inventory you find the key.
-If you remove the chest: the key is still valid
-if you lose the key: forget your chest!

DOOR:
-place the door; in your inventory you find the key.
-If you remove the door: the key is still valid
-if you lose the key: forget your door!

KEY:
If the correct key is in your inventory or in the chest: you can open the chest.
If the correct key is in your inventory:you can open the door.

KEYRING:
Merge multiple keys on a keyring.

KEY-MANAGER:
If a KEY is in the slot in the middle and at least one steel ingot in the KEY-MANAGER main menu:
press "copy" to copy the key(
If a EMPTY KEYRING is in the slot in the middle:
press "make" to merge all the keys of the key inventory-manager on a keychain;
If a FULL KEYRING is in the slot in the middle:
-press "unmake" to undo.
-press "copy" to copy all the keyring(you need 1 steel ingot for each key)


CHANGELOG:
closed_chest_v0.1:	-place the chest, soon appears above him his key. Take it, and put it in your inventory.
			-if the key is in your inventory you can place, move, remove items from the chest, otherwise not.
			-If you remove and/or move the chest: it is not the same chest and another key will be created.The old key not work.
			-if you lose the key: forget your chest!

closed_chest_v0.2:	-fix:if the key is in his basket, the chest is opened!
			-fix:facedir now work fine.
			
closed_chest_v0.3:	-improved:place the chest, The KEY appears in the chest. Take it, and put it in your inventory.
			-add:infotext
			-add:EMPTY KEYRING
			-add:FULL KEYRING
			-add:KEY-MANAGER

closed_chest_v0.4:	-add:Only those who have the key can see the contents;
			-add:key can return in steel ingot;
			-change:stack max(1) and behavior of closed chest(the key is still valid after move a chest); 
			-improved:check player privilege(has key);
			-improved:node definition;
			-change: key and keyring now are craftitem;
			-change:original chest tiles;
			-test:improved:mod architecture, now node and item definition are store in chest.init;
			-ONLY IF YOU WANT:uncomment line from-to to add explosion sensity.
			
closed_chest_v0.5:	-add:closed by key door;
			-test:improved:mod architecture, now chest and item definition are store in chest.init;function in init.lua;door 				 in door.lua.

closed_by_key_v0.6	-rename my mod, now called: "closed by key";
			-open door and chest with rightclick;
			-add disguised chest and door: very mimetic, but destructable;
			-add mese chest and door: you can not destroy them;
			-add on explode drop item if the chest is destructable;
			-texture update a little bit;
			-push code on GITHUB;
			-minor change.
			
			  

TO DO:
-maybe:key colour
-better crafting;
-much more.
      
