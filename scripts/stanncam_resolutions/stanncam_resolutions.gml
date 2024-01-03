//more common tablet and phone resolutions can be found here 
// https://gist.github.com/JujuAdams/dcae208b947c337a5e2f55f05bb64fdc

//more old console resolutions can be found here
// https://emulation.gametechwiki.com/index.php/Resolution

//add or remove resolutions as needed for your game

//you most likely want to just pick one retro resolution for your game and gui
//and then expose the desktop resolutions to the player in a settings menu, but it's up to you
enum STANNCAM_RES
{
	//Retro consoles
	ATARI_192P,
	NES_240P,
	SEGA_MS_256_X_224,
	GAME_BOY_144P,
	GAME_BOY_ADVANCE_160P,
	NINTENDO_64_320_X_200,
	NINTENDO_64_320_X_240,
	PLAYSTATION_512_X_224,
	
    //Desktop and console
    DESKTOP_720P,
    DESKTOP_1366_X_768,
    DESKTOP_1080P,
    DESKTOP_1440P,
    DESKTOP_4K,
}

global.stanncam_res = [];

//Retro consoles
global.stanncam_res[@ STANNCAM_RES.ATARI_192P				] = { width: 160, height:  192 };
global.stanncam_res[@ STANNCAM_RES.NES_240P					] = { width: 256, height:  240 };
global.stanncam_res[@ STANNCAM_RES.SEGA_MS_256_X_224		] = { width: 256, height:  224 };
global.stanncam_res[@ STANNCAM_RES.GAME_BOY_144P			] = { width: 160, height:  144 };
global.stanncam_res[@ STANNCAM_RES.GAME_BOY_ADVANCE_160P    ] = { width: 240, height:  160 };
global.stanncam_res[@ STANNCAM_RES.NINTENDO_64_320_X_200    ] = { width: 320, height:  200 };
global.stanncam_res[@ STANNCAM_RES.NINTENDO_64_320_X_200    ] = { width: 320, height:  200 };
global.stanncam_res[@ STANNCAM_RES.NINTENDO_64_320_X_240    ] = { width: 320, height:  240 };
global.stanncam_res[@ STANNCAM_RES.PLAYSTATION_512_X_224    ] = { width: 512, height:  224 };

//Desktop and console
global.stanncam_res[@ STANNCAM_RES.DESKTOP_720P				] = { width: 1280, height:  720 };
global.stanncam_res[@ STANNCAM_RES.DESKTOP_1366_X_768		] = { width: 1366, height:  768 };
global.stanncam_res[@ STANNCAM_RES.DESKTOP_1080P			] = { width: 1920, height: 1080 };
global.stanncam_res[@ STANNCAM_RES.DESKTOP_1440P			] = { width: 2560, height: 1440 };
global.stanncam_res[@ STANNCAM_RES.DESKTOP_4K				] = { width: 3840, height: 2160 };