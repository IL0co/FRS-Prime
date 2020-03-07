#include <sdktools_stringtables>
#include <SteamWorks> 
#include <FakeRank_Sync>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name		= "[FRS] Prime",
	version		= "1.1",
	description	= "Fake Ranks for Prime status",
	author		= "ღ λŌK0ЌЭŦ ღ ™",
	url			= "https://github.com/IL0co"
}

ConVar cvar_Prime, cvar_NoPrime;
int c_Prime, c_NoPrime; 

#define IND "Prime"

public void OnPluginEnd()
{
	FRS_UnRegisterMe();
}

public void OnPluginStart()
{
	(cvar_Prime = CreateConVar("sm_prime_natives_fakerank_prime", "60997701", "RU: Номер таблички для прайма \nEN: Prime plate number")).AddChangeHook(OnVarChanged);
	c_Prime = cvar_Prime.IntValue;

	(cvar_NoPrime = CreateConVar("sm_prime_natives_fakerank_noprime", "60997702", "RU: Номер таблички для не прайма \nEN: Plate number for non prime")).AddChangeHook(OnVarChanged);
	c_NoPrime = cvar_NoPrime.IntValue;
	
	AutoExecConfig(true, "FRS_Prime");

	for(int i = 1; i <= MaxClients; i++) 	if(IsClientAuthorized(i) && IsClientInGame(i))
		FRS_OnClientLoaded(i);

	FRS_OnCoreLoaded();
}

public void OnVarChanged(ConVar cvar, char[] oldValue, char[] newValue)
{	
	if(cvar == cvar_Prime)
		c_Prime = cvar.IntValue;
	else if(cvar == cvar_NoPrime)
		c_NoPrime = cvar.IntValue;

	OnMapStart();
}

public void OnMapStart()
{
	char szBuffer[256];

	FormatEx(szBuffer, sizeof(szBuffer), "materials/panorama/images/icons/skillgroups/skillgroup%i.svg", c_NoPrime);
	if(FileExists(szBuffer)) AddFileToDownloadsTable(szBuffer);
	
	FormatEx(szBuffer, sizeof(szBuffer), "materials/panorama/images/icons/skillgroups/skillgroup%i.svg", c_Prime);
	if(FileExists(szBuffer)) AddFileToDownloadsTable(szBuffer);

}

public void FRS_OnCoreLoaded()
{
	FRS_RegisterKey(IND);
}

public void FRS_OnClientLoaded(int client)
{
	CreateTimer(2.0, TimerRegMe, GetClientUserId(client));
}

public Action TimerRegMe(Handle timer, any client)
{
	client = GetClientOfUserId(client);

	int iId = c_Prime;
	if (!CheckCommandAccess(client, "BypassPremiumCheck", ADMFLAG_ROOT, true) && IsClientInGame(client))
	{
		if(k_EUserHasLicenseResultDoesNotHaveLicense == SteamWorks_HasLicenseForApp(client, 624820))
			iId = c_NoPrime;
	}

	FRS_SetClientRankId(client, iId, IND);
}
