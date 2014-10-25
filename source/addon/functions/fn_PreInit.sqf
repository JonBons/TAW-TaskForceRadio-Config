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
