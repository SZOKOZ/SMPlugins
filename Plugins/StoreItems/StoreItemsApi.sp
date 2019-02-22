#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "SZOKOZ/EXE KL"
#define PLUGIN_VERSION "1.00"

#include <sourcemod>
#include "StoreItemsApi.inc"

#define ISEMPTY(%1) StrEqual(%1, "")
#define STRING(%1) %1,sizeof(%1)

enum _:StoreItem
{
	Handle:itemPlugin,
	ItemType:index,
	String:description[64],
	Function:equip,
	Function:unequip
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
	g_hStoreItems = CreateArray(StoreItem);
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("RegisterStoreItemType", Native_RegisterStoreItemType);
	CreateNative("RegisterStoreItemTypeByName", Native_RegisterStoreItemTypeByName);
	CreateNative("UnequipAllItems", Native_UnequipAllItems);
	CreateNative("UnequipAllItemsByType", Native_UnequipAllItemsByType);
	CreateNative("UnequipAllItemsByName", Native_UnequipAllItemsByName);
	
	return APLRes_Success;
}

public Native_RegisterStoreItemType(Handle:plugin, numParams)
{
	new eType = GetNativeCell(1);
	new Function:funcEquip = GetNativeCell(2);
	new Function:funcUnequip = GetNativeCell(3);
	
	new item[StoreItem];
	item[itemPlugin] = plugin;
	item[index] = ItemType:eType;
	item[equip] = funcEquip;
	item[unequip] = funcUnequip;
	
	new currentitem[StoreItem];
	new size = GetArraySize(g_hStoreItems);
	if (size > 0 && size >= eType)
	{
		GetArrayArray(g_hStoreItems, eType, currentitem);
	}
	SetArrayArray(g_hStoreItems, eType, item);
	
	if (currentitem[index] == ItemType:-1)
	{
		PushArrayArray(g_hStoreItems, currentitem);
	}
}

public Native_RegisterStoreItemTypeByName(Handle:plugin, numParams)
{
	new String:itemname[64];
	GetNativeString(1, STRING(itemname));
	new Function:funcEquip = GetNativeCell(2);
	new Function:funcUnequip = GetNativeCell(3);
	
	new item[StoreItem];
	item[itemPlugin] = plugin;
	item[index] = ItemType:-1;
	item[description] = itemname;
	item[equip] = funcEquip;
	item[unequip] = funcUnequip;
	
	PushArrayArray(g_hStoreItems, item);
}

public Native_UnequipAllItems(Handle:plugin, numParams)
{
	
}

public Native_UnequipAllItemsByType(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new eType = GetNativeCell(2);
	
	new size = GetArraySize(g_hStoreItems);
	if (!(size > 0 && size >= eType))
	{
		return;
	}
	
	new currentitem[StoreItem];
	GetArrayArray(g_hStoreItems, eType, currentitem);
	
	if (GetPluginStatus(currentitem[itemPlugin]) != Plugin_Running)
	{
		return;
	}
	
	Call_StartFunction(currentitem[itemPlugin], currentitem[unequip]);
	Call_PushCell(client);
	Call_Finish();
}

public Native_UnequipAllItemsByName(Handle:plugin, numParams)
{
	
}