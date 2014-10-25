/*
 	Name: TAW_TFAR_fnc_RequestSWRadio

 	Author(s):
		JonBons

 	Description:


	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		call TAW_TFAR_fnc_RequestSWRadio;
*/
private ["_radioClass"];

if (call TFAR_fnc_haveSWRadio) exitWith { player sideChat "You already have a personal radio."; };

_radioClass = ((call TFAR_fnc_getDefaultRadioClasses) select 1);

player addItem _radioClass;
player assignItem _radioClass;

[] spawn {
	waitUntil {sleep 0.1; call TFAR_fnc_haveSWRadio};

	call TAW_TFAR_fnc_SetCarriedRadioPresets;
	player sideChat "You have been given a personal radio.";
};