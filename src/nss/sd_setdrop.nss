#include "sd_lootsystem"

void main()
{
 object oPC = GetLastOpenedBy();

 DropSetItem(oPC, OBJECT_SELF);


object oItem = GetFirstItemInInventory(OBJECT_SELF);
while (GetIsObjectValid(oItem))
      {
       if (GetIdentified(oItem)==FALSE)SetIdentified(oItem, TRUE);
       oItem = GetNextItemInInventory(OBJECT_SELF);
      }

}
