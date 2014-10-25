/*
 	Name: TAW_TFAR_fnc_RequestLRRadio

 	Author(s):
		JonBons

 	Description:


	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		call TAW_TFAR_fnc_RequestLRRadio;
*/
private ["_items", "_backPack", "_newItems"];

if ([(backpack player), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {
	player sideChat "You already have a long range radio.";
};

if (taw_tfr_gettingBackpack) exitWith {};

taw_tfr_gettingBackpack = true;

[] spawn {
	_items = backpackItems player;
	_backPack = unitBackpack player;
	player action ["putbag", player];

	sleep 3;

	player addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);
	_newItems = [];
	{
		if (player canAddItemToBackpack _x) then
		{
			player addItemToBackpack _x;
		}
		else
		{
			_newItems set [count _newItems, _x];
		};
	} count _items;

	clearItemCargoGlobal _backPack;
	clearMagazineCargoGlobal _backPack;
	clearWeaponCargoGlobal _backPack;
	{
		if (isClass (configFile >> "CfgMagazines" >> _x)) then
		{
			_backPack addMagazineCargoGlobal [_x, 1];
		}
		else
		{
			_backPack addItemCargoGlobal [_x, 1];
			_backPack addWeaponCargoGlobal [_x, 1];
		};
	} count _newItems;

	taw_tfr_gettingBackpack = false;

	player sideChat "You have been given a long range radio.";

	call TAW_TFAR_fnc_SetCarriedRadioPresets;
};