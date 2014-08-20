/*
 TAW TFR settings
 this file must be found in <game folder>\userconfig\task_force_radio_taw\
 
 All config entries are turned into global variables following a standard naming scheme. For example:
 taw_tfr_main_longrange_channels_1 = getNumber (configFile >> "taw_tfr" >> "main" >> "longrange" >> "channels_1")
 Mission makers can control these features by setting these global variables in init.sqf or by setting
 a similar taw_tfr class in description.ext
*/

class taw_tfr {

	class main {

		enabled = 1;

		class longrange {

			class channels_1 {
				name = "1st Platoon";
				freq = "71";
			};

			class channels_2 {
				name = "2nd Platoon";
				freq = "72";
			};

			class channels_3 {
				name = "Battalion Net";
				freq = "80";
			};

			class channels_4 {
				name = "Air Squad";
				freq = "60";
			};

			class channels_5 {
				name = "Cavalry Squad";
				freq = "50";
			};

			class channels_6 {
				name = "Unspecified";
				freq = "55";
			};

			class channels_7 {
				name = "Unspecified";
				freq = "56";
			};

			class channels_8 {
				name = "Unspecified";
				freq = "57";
			};

			class channels_9 {
				name = "Unspecified";
				freq = "58";
			};

		};

		class shortrange {

			class channels_1 {
				name = "Alpha Squad";
				freq = "41";
			};

			class channels_2 {
				name = "Bravo Squad";
				freq = "42";
			};

			class channels_3 {
				name = "Charlie Squad";
				freq = "43";
			};

			class channels_4 {
				name = "Delta Squad";
				freq = "44";
			};

			class channels_5 {
				name = "Cavalry Squad";
				freq = "50";
			};

			class channels_6 {
				name = "Air Squad";
				freq = "60";
			};

			class channels_7 {
				name = "Unspecified";
				freq = "45";
			};

			class channels_8 {
				name = "Unspecified";
				freq = "46";
			};

		};

	};

	version = 1; // will increment this when structure changes

};
