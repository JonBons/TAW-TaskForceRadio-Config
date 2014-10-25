/*
 	Name: TAW_TFAR_fnc_InitPlayer

 	Author(s):
		JonBons

 	Description:


	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		call TAW_TFAR_fnc_InitPlayer
*/

[] spawn {
	waitUntil {!(isNull player)};
	waitUntil {player == player}; // jip
	waitUntil {sleep 0.5; !isNil "TFAR_fnc_haveSWRadio"};
	waitUntil {sleep 0.5; ((call TFAR_fnc_haveSWRadio) || (call TFAR_fnc_haveLRRadio) || (call TFAR_fnc_haveDDRadio))}; // do we have a radio?

	if (isNil "taw_tfr_allowed") then { taw_tfr_allowed = true };
	if !( taw_tfr_allowed ) exitWith {};

	TF_terrain_interception_coefficient = 1.0;

	sleep 1;

	call TAW_TFAR_fnc_SetCarriedRadioPresets;
};