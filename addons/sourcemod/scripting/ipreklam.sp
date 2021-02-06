#include <sourcemod>

#pragma newdecls required
#pragma semicolon 1

ConVar g_Discord_Link = null,
g_SunucuIP = null;

char Discord_Link[64],
SunucuIP[64];

bool kontrol[MAXPLAYERS];

public Plugin myinfo = 
{
	name = "Sol üst ip reklam", 
	description = "Sol üstte hudsay şeklinde reklamınız çıkar.", 
	author = "phiso", 
	version = "1.0", 
	url = "phiso#5523"
};
public void OnMapStart()
{
	CreateTimer(1.0, Reklam, _, TIMER_REPEAT | TIMER_FLAG_NO_MAPCHANGE);
}
public void OnClientPostAdminCheck(int client){kontrol[client] = true;}
public void OnPluginStart()
{
	RegConsoleCmd("sm_reklam", Command_Reklam);
	
	g_Discord_Link = CreateConVar("discord_link", "DİSCORD LİNKİ", "← Discord davet linki");
	g_SunucuIP = CreateConVar("sunucu_ip", "SUNUCU IP", "← Sunucunuzun ipsi");
	
	AutoExecConfig(true, "ipdc_reklam", "phiso");
}
public Action Command_Reklam(int client, int args)
{
	if (kontrol[client])
	{
		kontrol[client] = false;
		PrintToChat(client, "[SM] \x04Sol üst ip reklam \x02kapandı.");
	}
	else
	{
		kontrol[client] = true;
		PrintToChat(client, "[SM] \x04Sol üst ip reklam \x02açıldı.");
	}
}
public Action Reklam(Handle timer)
{
	g_Discord_Link.GetString(Discord_Link, sizeof(Discord_Link));
	g_SunucuIP.GetString(SunucuIP, sizeof(SunucuIP));
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && kontrol[i])
		{
			Handle hHudText = CreateHudSynchronizer();
			SetHudTextParams(0.0, -0.95, 1.0, GetRandomInt(0, 255), GetRandomInt(0, 255), GetRandomInt(0, 255), 255);
			ShowSyncHudText(i, hHudText, "IP Adresi: %s \nDiscord: %s", SunucuIP, Discord_Link);
			delete hHudText;
		}
	}
} 
