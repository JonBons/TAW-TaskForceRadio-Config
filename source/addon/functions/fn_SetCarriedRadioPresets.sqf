/*
 	Name: TAW_TFAR_fnc_SetCarriedRadioPresets

 	Author(s):
		JonBons

 	Description:


	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		call TAW_TFAR_fnc_SetCarriedRadioPresets;
*/
#include "common.sqf"

private ["_settingsSW", "_settingsLR", "_freqSW", "_freqLR", "_freqDD"];

_settingsSW = false call TFAR_fnc_generateSwSettings;
_settingsLR = false call TFAR_fnc_generateLrSettings;

_freqSW = [];
_freqLR = [];
_freqDD = DD_FREQ;

{ _freqSW = _freqSW + [_x select 3] } forEach taw_tfr_main_shortrange;
{ _freqLR = _freqLR + [_x select 3] } forEach taw_tfr_main_longrange;

// Set short wave freqs
_settingsSW set [2, _freqSW];
{
	[_x, _settingsSW] call TFAR_fnc_setSwSettings;

	if (dialog) then {
    	call TFAR_fnc_updateSWDialogToChannel;
	};

} forEach (call TFAR_fnc_radiosList);

// Set long range freqs
_settingsLR set [2, _freqLR];
{
	private ["_radio_object", "_radio_qualifier"];

	_radio_object = _x select 0;
  _radio_qualifier = _x select 1;
  [_radio_object, _radio_qualifier, _settingsLR] call TFAR_fnc_setLrSettings;


	if (dialog) then {
    	call TFAR_fnc_updateLRDialogToChannel;
	};

} forEach (call TFAR_fnc_lrRadiosList);

// Set diver radio freq
if (call TFAR_fnc_haveDDRadio) then {

	if ((_freqDD >= TF_MIN_DD_FREQ) and (_freqDD <= TF_MAX_DD_FREQ)) then {
		TF_dd_frequency = str (round (_freqDD * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER);

		if (dialog) then {
    	call TFAR_fnc_updateDDDialog;
		};
	};

};
