#include <sourcemod>
#pragma newdecls required
#pragma semicolon 1
ConVar g_Discord_Link = null;
char Discord_Link[64];
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
	
	char address[35];
	char port[5];
	FindConVar("hostport").GetString(port, sizeof(port));
	
	char pieces[4];
	int longip = GetConVarInt(FindConVar("hostip"));
	
	pieces[0] = (longip >> 24) & 0x000000FF;
	pieces[1] = (longip >> 16) & 0x000000FF;
	pieces[2] = (longip >> 8) & 0x000000FF;
	pieces[3] = longip & 0x000000FF;
	
	Format(address, sizeof(address), "%d.%d.%d.%d:%s", pieces[0], pieces[1], pieces[2], pieces[3], port);
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && kontrol[i])
		{
			Handle hHudText = CreateHudSynchronizer();
			SetHudTextParams(0.0, -0.95, 1.0, GetRandomInt(0, 255), GetRandomInt(0, 255), GetRandomInt(0, 255), 255);
			ShowSyncHudText(i, hHudText, "IP Adresi: %s \nDiscord: %s", address, Discord_Link);
			delete hHudText;
		}
	}
} 