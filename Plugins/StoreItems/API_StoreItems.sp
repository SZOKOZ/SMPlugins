#pragma semicolon 1

#define PLUGIN_AUTHOR "SZOKOZ/EXE KL"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include "store_items.inc"

#define ISEMPTY(%1) StrEqual(%1, "")
#define STRING(%1) %1,sizeof(%1)

enum _:eStoreItem
{
	Handle:hItemPlugin,
	ItemType:iIndex,
	String:szDescription[64],
	Function:fnEquip,
	Function:fnUnequip
}

new Handle:g_hStoreItems;

public Plugin:myinfo = 
{
	name = "StoreItems API",
	author = PLUGIN_AUTHOR,
	description = "Allows internal and third party plugins to explicitly equip and unequip items on a player. Effects are temporary.",
	version = PLUGIN_VERSION,
	url = "www.swoobles.com"
};

public OnPluginStart()
{
	g_hStoreItems = CreateArray(eStoreItem);
}

public APLRes:AskPluginLoad2(Handle:hMyself, bool:bLate, String:szError[], iErrmax)
{
	CreateNative("RegisterStoreItemType", Native_RegisterStoreItemType);
	CreateNative("RegisterStoreItemTypeByName", Native_RegisterStoreItemTypeByName);
	CreateNative("UnequipAllItems", Native_UnequipAllItems);
	CreateNative("UnequipAllItemsByType", Native_UnequipAllItemsByType);
	CreateNative("UnequipAllItemsByName", Native_UnequipAllItemsByName);
	
	return APLRes_Success;
}

public Native_RegisterStoreItemType(Handle:hPlugin, iNumParams)
{
	new iType = GetNativeCell(1);
	new Function:funcEquip = GetNativeCell(2);
	new Function:funcUnequip = GetNativeCell(3);
	
	new eItem[eStoreItem];
	eItem[hItemPlugin] = hPlugin;
	eItem[iIndex] = ItemType:iType;
	eItem[fnEquip] = funcEquip;
	eItem[fnUnequip] = funcUnequip;
	
	new eCurrentitem[eStoreItem];
	new iSize = GetArraySize(g_hStoreItems);
	if (iSize > 0 && iSize >= iType)
	{
		GetArrayArray(g_hStoreItems, iType, eCurrentitem);
	}
	SetArrayArray(g_hStoreItems, iType, eItem);
	
	if (eCurrentitem[iIndex] == ItemType:-1)
	{
		PushArrayArray(g_hStoreItems, eCurrentitem);
	}
}

public Native_RegisterStoreItemTypeByName(Handle:hPlugin, iNumParams)
{
	new String:szItemname[64];
	GetNativeString(1, STRING(szItemname));
	new Function:funcEquip = GetNativeCell(2);
	new Function:funcUnequip = GetNativeCell(3);
	
	new eItem[eStoreItem];
	eItem[hItemPlugin] = hPlugin;
	eItem[iIndex] = ItemType:-1;
	eItem[szDescription] = szItemname;
	eItem[fnEquip] = funcEquip;
	eItem[fnUnequip] = funcUnequip;
	
	PushArrayArray(g_hStoreItems, eItem);
}

public Native_UnequipAllItems(Handle:hPlugin, iNumParams)
{
	
}

public Native_UnequipAllItemsByType(Handle:hPlugin, iNumParams)
{
	new iClient = GetNativeCell(1);
	new iType = GetNativeCell(2);
	
	new iSize = GetArraySize(g_hStoreItems);
	if (!(iSize > 0 && iSize >= iType))
	{
		return;
	}
	
	new eCurrentitem[eStoreItem];
	GetArrayArray(g_hStoreItems, iType, eCurrentitem);
	
	if (GetPluginStatus(eCurrentitem[hItemPlugin]) != Plugin_Running)
	{
		return;
	}
	
	Call_StartFunction(eCurrentitem[hItemPlugin], eCurrentitem[fnUnequip]);
	Call_PushCell(iClient);
	Call_Finish();
}

public Native_UnequipAllItemsByName(Handle:hPlugin, iNumParams)
{
	
}