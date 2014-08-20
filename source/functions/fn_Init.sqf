/*
 	Name: TAW_TFAR_fnc_Init

 	Author(s):
		JonBons

 	Description:


	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		Called by ArmA via functions library.
*/
if (isServer && isDedicated) exitWith {};
if (!hasInterface) exitWith {};

private ["_runningTFR"];

// Don't run the task force radio enhancements if you're not running TFR
_runningTFR = isClass (configFile >> "CfgPatches" >> "task_force_radio");
if (!_runningTFR) exitWith { diag_log "TAW TFR : Not initializing TAW TFR mod because TFR mod was not found."; };

#include "common.sqf"

taw_tfr_no_auto_long_range_radio = false;

[] spawn
{
	waitUntil {
		waitUntil {sleep 0.1; !(isNull player)};
		waitUntil {sleep 0.1; alive player};
		waitUntil {sleep 3; !isNil "TAW_TFAR_fnc_InitPlayer"};

		[player, false] call TFAR_fnc_forceSpectator;

		diag_log "TAW TFR : Player setting default freqs.";
		call TAW_TFAR_fnc_InitPlayer;

		sleep 1;

		waitUntil {sleep 0.1; !alive player};

		if (!isNil "BTC_respawn_cond") then {
			diag_log "TAW TFR : Player died via BTC and is in revive state.";

			waitUntil {sleep 0.1; BTC_respawn_cond};
			diag_log "TAW TFR : Player starting respawn code.";
			waitUntil {sleep 0.1; format ["%1", player getVariable "BTC_need_revive"] == "0"};
			waitUntil {sleep 0.1; !BTC_respawn_cond};
			waitUntil {sleep 0.5; BTC_respawn_time == 0};

			diag_log "TAW TFR : Player ended respawn state, fully respawned.";
		};

		sleep 1;

		false // infinite loop
	};
};

[] spawn
{
	waitUntil {sleep 0.1; !(isNull player)};
	waitUntil {player == player}; // jip
	waitUntil {sleep 0.1; alive player};
	waitUntil {sleep 1; !isNil "taw_tfr_main_shortrange"};
	waitUntil {sleep 1; !isNil "TFAR_fnc_haveSWRadio"};

	sleep 5;

	_freqSW = taw_tfr_main_shortrange;
	_freqLR = taw_tfr_main_longrange;
	_freqDD = DD_FREQ;

	_freqSWString = "";
	{
		_freqSWString = _freqSWString + "  " + (str (_forEachIndex + 1)) + " : (" + (_x select 3) + ") - " + (_x select 1) + "<br />";
	} forEach _freqSW;

	_freqLRString = "";
	{
		_freqLRString = _freqLRString + "  " + (str (_forEachIndex + 1)) + " : (" + (_x select 3) + ") - " + (_x select 1) + "<br />";
	} forEach _freqLR;

	player createDiarySubject ["TAWTFRNotes", "TAW TFR Notes"];


	_spawnRecord = "Long range radio: <executeClose expression='call TAW_TFAR_fnc_RequestLRRadio'>SPAWN RADIO</executeClose><br />";
	_spawnRecord = _spawnRecord + "Personal radio: <executeClose expression='call TAW_TFAR_fnc_RequestSWRadio'>SPAWN RADIO</executeClose><br />";

	player createDiaryRecord ["TAWTFRNotes", ["Spawn radios", _spawnRecord]];


	_setStandardFreqs = "[] call fn_taw_tfr_setCarriedRadioFreqs; player sideChat ""All of your radios have been set to the standard frequencies.""";

	_standardFreq = "Shortwave channels:<br />" + _freqSWString + "<br />";
	_standardFreq = _standardFreq + "Long range channels:<br />" + _freqLRString + "<br />";
	_standardFreq = _standardFreq + "Diver radio channel:<br />" + "  1 : (" + (str _freqDD) + ")<br /><br />";
	_standardFreq = _standardFreq + "Set all carried radios to standard frequencies by clicking <executeClose expression='" + _setStandardFreqs + "'>THIS TEXT</executeClose>";

	player createDiaryRecord ["TAWTFRNotes", ["Standard Frequencies", _standardFreq]];

	// Telling TFR to bugger off as BTC & TFR cause backpack race conditions with LR radio.
	if (!isNil "tf_no_auto_long_range_radio" && !isNil "BTC_respawn_cond" && !isNil "BTC_fnc_handledamage_gear") then {
		taw_tfr_no_auto_long_range_radio = tf_no_auto_long_range_radio;
		diag_log text format["TAW TFR : Setting taw_tfr_no_auto_long_range_radio to %1.", tf_no_auto_long_range_radio];

		tf_no_auto_long_range_radio = true;

		// BTC grabs initial gear before TFR sets up radios causing potential gear issues.
		[player] spawn BTC_fnc_handledamage_gear;
	};
};
