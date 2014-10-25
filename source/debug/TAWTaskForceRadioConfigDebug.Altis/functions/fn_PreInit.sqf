/*
 	Name: TAW_TFAR_fnc_PreInit

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

#include "script_component.hpp"

["CBA_MISSION_START", {if ([configFile >> QUOTE(PREFIX) >> "version", "number", 0] call CBA_fnc_getConfigEntry < TAW_TFR_USERCFG_VERSION) then {player sideChat "WARNING: TAW TFR USERCONFIG OUTDATED!"}}] call CBA_fnc_addEventHandler;

//determine config class root
GVAR(cfg) = [[QUOTE(PREFIX),QUOTE(COMPONENT)],configfile>>QUOTE(PREFIX)>>QUOTE(COMPONENT)] call bis_fnc_loadClass;
TRACE_1("",GVAR(cfg));

TAW_TFR_CFGREAD(enabled,number,1);
if (GVAR(enabled) == 0) exitWith {
	LOG("disabled");
};
LOG(MSG_INIT);

//read longrange channels and shortrange channels from config
_longrange = [];
for "_i" from 0 to (count(GVAR(cfg) >> "longrange") - 1) do {
	PUSH(_longrange,[]);
	_thisLevel = (GVAR(cfg) >> "longrange") select _i;
	for "_j" from 0 to (count(_thisLevel) - 1) do {
		if (isText ((_thisLevel) select _j)) then {
			_cn = configName ((_thisLevel) select _j);
			_a = [(_thisLevel) select _j, "text", ""] call CBA_fnc_getConfigEntry;

			PUSH(_longrange select _i,_cn);
			PUSH(_longrange select _i,_a);
		};
	};
};
if (isNil QGVAR(longrange)) then {GVAR(longrange) = _longrange};
TRACE_1("",GVAR(longrange));

_shortrange = [];
for "_i" from 0 to (count(GVAR(cfg) >> "shortrange") - 1) do {
	PUSH(_shortrange,[]);
	_thisLevel = (GVAR(cfg) >> "shortrange") select _i;
	for "_j" from 0 to (count(_thisLevel) - 1) do {
		if (isText ((_thisLevel) select _j)) then {
			_cn = configName ((_thisLevel) select _j);
			_a = [(_thisLevel) select _j, "text", ""] call CBA_fnc_getConfigEntry;

			PUSH(_shortrange select _i,_cn);
			PUSH(_shortrange select _i,_a);
		};
	};
};
if (isNil QGVAR(shortrange)) then {GVAR(shortrange) = _shortrange};
TRACE_1("",GVAR(shortrange));

//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

if (!hasInterface && !isDedicated) exitWith {};

private ["_runningTFR"];

// Don't run the task force radio enhancements if you're not running TFR
_runningTFR = isClass (configFile >> "CfgPatches" >> "task_force_radio");
if (!_runningTFR) exitWith { diag_log "TAW TFR : Not initializing TAW TFR mod because TFR mod was not found."; };

#include "common.sqf"

// server only
if (isDedicated || (isServer && !isDedicated)) then {
	publicVariable "taw_tfr_main_shortrange";
	publicVariable "taw_tfr_main_longrange";

	TF_terrain_interception_coefficient = 1.0;
	publicVariable "TF_terrain_interception_coefficient";

	_settingsSW = false call TFAR_fnc_generateSwSettings;
	_settingsLR = false call TFAR_fnc_generateLrSettings;

	_freqSW = [];
	_freqLR = [];
	{ _freqSW = _freqSW + [_x select 3] } forEach taw_tfr_main_shortrange;
	{ _freqLR = _freqLR + [_x select 3] } forEach taw_tfr_main_longrange;

	_settingsSW set [2, _freqSW];
	_settingsLR set [2, _freqLR];

	{
		if (isNil (format ["taw_tf_freq_%1", _x])) then {
			private ["_prefix", "_sw", "_lr"];

			_prefix = format ["taw_tf_freq_%1", _x];
			_prefixTFR = format ["tf_freq_%1", _x];


			// TFR var
			_sw = format ["%1 = _settingsSW", _prefixTFR];
			_lr = format ["%1_lr = _settingsLR", _prefixTFR];

			call compile _sw;
			call compile _lr;

			publicVariable (format ["%1", _prefixTFR]);
			publicVariable (format ["%1_lr", _prefixTFR]);

			// TAW var
			_sw = format ["%1 = _settingsSW", _prefix];
			_lr = format ["%1_lr = _settingsLR", _prefix];

			call compile _sw;
			call compile _lr;

			publicVariable (format ["%1", _prefix]);
			publicVariable (format ["%1_lr", _prefix]);
		};
	} forEach ["west","east","guer"];

	if (true) exitWith {};
};

// client only
taw_tfr_no_auto_long_range_radio = false;

[] spawn
{
	waitUntil {sleep 0.1; !(isNull player)};
	waitUntil {player == player}; // jip
	waitUntil {sleep 0.1; alive player};
	waitUntil {sleep 1; !isNil "TFAR_fnc_forceSpectator"};
	waitUntil {sleep 1; !isNil "taw_tfr_main_longrange"};

	_currentSide = side player;
	if (_currentSide == independent || {_currentSide == civilian}) then {
		_currentSide = "guer";
	};

 	_sw = taw_tfr_main_shortrange;
	_lr = taw_tfr_main_longrange;

	_freqSW = _sw;
	_freqLR = _lr;
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
