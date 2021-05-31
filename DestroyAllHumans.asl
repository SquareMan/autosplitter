state("DH-Win64-Shipping")
{
	//Checks if boolean for loadingscreen is set
	bool loading : 0x3C71F90;
	bool loading2 : 0x03D4AC58, 0x50, 0x1860;
	string128 map: 0x03D72BD0, 0x868, 0x0;
	bool inCutscene: 0x3B20974;
	// This value appears to be true when a mission has been lauched, but before it begins
	// (during pre-mission newspaper)
	bool preMission: 0x3B20978;
	bool loading3: 0x03D4AC48, 0x660, 0xBF0;
	// null: no objective
	string32 objective: 0x03B18E30, 0xC0, 0x0;
}

startup
{
	//Map name of the mothership for start/split functionality.
	vars.MOTHERSHIP = "/Game/Maps/Menus/Mothership/MothershipMenu_Main";
	//Final objective name for timer end
	vars.KILL_SILHOUETTE = "Kill Silhouette";

	//Load removal
    settings.Add("loadremoval", true, "Load Removal");
    settings.SetToolTip("loadremoval", "Enables Load Removal on Game Time Timer");
	//Pause on crash
    settings.Add("crashpause", true, "Pause on Crash");
    settings.SetToolTip("crashpause", "Enables automatic pause on crash of the game");
		
	//Split Settings
	settings.Add("splitMothership", true, "Split On Return To Mothership");
	settings.Add("splitBoss", true, "Split On Killing Silhouette");
}

start
{
	return !old.inCutscene && current.inCutscene  && current.map == vars.MOTHERSHIP;
}

split
{
	//Mission Finished
	if (settings["splitMothership"] && current.loading2 == true && current.map == vars.MOTHERSHIP && old.map != vars.MOTHERSHIP)
		return true;
		
	//Game completed
	if (settings["splitBoss"] && current.objective == null && old.objective != null && old.objective == vars.KILL_SILHOUETTE)
		return true;
}

isLoading
{
	if(settings["loadremoval"])
	{
		return current.loading || current.loading2 || (current.loading3 && !current.preMission && !current.inCutscene);
	}
}

exit
{
	if(settings["crashpause"])
	{
		timer.IsGameTimePaused = true;
	}
}