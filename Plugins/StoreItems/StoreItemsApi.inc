/*
**
*/
#if defined _StoreItemsApi_included
 #endinput
#endif
#define _StoreItemsApi_included

enum ItemType
{
	ITEM_BULLETTRACER,
	ITEM_EQUIPMENT,
	ITEM_GRENADESOUNDS,
	ITEM_KILLSOUNDS,
	ITEM_PAINTBALLS,
	ITEM_PLAYERTRAILS
}

native RegisterStoreItemType(ItemType:item, Function:equip, Function:unequip);
native RegisterStoreItemTypeByName(String:item[], Function:equip, Function:unequip);
native UnequipAllItems(client);
native UnequipAllItemsByType(client, ItemType:item);
native UnequipAllItemsByName(client, String:item[]);

/*
#if !defined REQUIRE_PLUGIN
public __pl_StoreItemsApi_SetNTVOptional()
{
	MarkNativeAsOptional("RegisterStoreItemType");
	MarkNativeAsOptional("RegisterStoreItemTypeByName");
	MarkNativeAsOptional("UnequipAllItems");
	MarkNativeAsOptional("UnequipAllItemsByType");
	MarkNativeAsOptional("UnequipAllItemsByName");
}
#endif
*/

public SharedPlugin:__pl_StoreItemsApi =
{
	name = "StoreItemsApi",
	file = "StoreItemsApi.smx",
	#if defined REQUIRE_PLUGIN
	required = 1,
	#else
	required = 0,
	#endif
};
