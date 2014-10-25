class CfgFunctions
{
	class TAW_TFAR
	{
		class TFAR
		{
			file="taw_task_force_radio\functions";
			class PreInit
			{
				preInit = 1;
			};
			class Init
			{
				postInit = 1;
			};
			class InitPlayer{};
			class RequestSWRadio{};
			class RequestLRRadio{};
			class SetCarriedRadioPresets{};
		};
	};
};