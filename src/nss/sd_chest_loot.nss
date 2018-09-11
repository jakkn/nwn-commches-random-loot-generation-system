#include "sd_lootsystem"

void main()
{
 object oPC = GetLastOpenedBy();
 string sTag = GetTag(OBJECT_SELF);
 int iLoot = StringToInt(sTag);

 switch (iLoot)
        {
         case 1: DropWeapon(oPC, OBJECT_SELF, 1, 0, 1); break;
         case 2: DropWeapon(oPC, OBJECT_SELF, 2, 0, 1); break;
         case 3: DropWeapon(oPC, OBJECT_SELF, 3, 0, 1); break;
         case 4: DropWeapon(oPC, OBJECT_SELF, 4, 0, 1); break;
         case 5: DropWeapon(oPC, OBJECT_SELF, 5, 0, 1); break;

         case 6: DropShield(oPC, OBJECT_SELF, 1, 0, 1); break;
         case 7: DropShield(oPC, OBJECT_SELF, 2, 0, 1); break;
         case 8: DropShield(oPC, OBJECT_SELF, 3, 0, 1); break;
         case 9: DropShield(oPC, OBJECT_SELF, 4, 0, 1); break;
         case 10: DropShield(oPC, OBJECT_SELF, 5, 0, 1); break;

         case 11: DropArmor(oPC, OBJECT_SELF, 1, 0, 1); break;
         case 12: DropArmor(oPC, OBJECT_SELF, 2, 0, 1); break;
         case 13: DropArmor(oPC, OBJECT_SELF, 3, 0, 1); break;
         case 14: DropArmor(oPC, OBJECT_SELF, 4, 0, 1); break;
         case 15: DropArmor(oPC, OBJECT_SELF, 5, 0, 1); break;

         case 16: DropMagicItem(oPC, OBJECT_SELF, 1, 0, 1); break;
         case 17: DropMagicItem(oPC, OBJECT_SELF, 2, 0, 1); break;
         case 18: DropMagicItem(oPC, OBJECT_SELF, 3, 0, 1); break;
         case 19: DropMagicItem(oPC, OBJECT_SELF, 4, 0, 1); break;
         case 20: DropMagicItem(oPC, OBJECT_SELF, 5, 0, 1); break;

         case 21: DropMonkGloves(oPC, OBJECT_SELF, 1, 0, 1); break;
         case 22: DropMonkGloves(oPC, OBJECT_SELF, 2, 0, 1); break;
         case 23: DropMonkGloves(oPC, OBJECT_SELF, 3, 0, 1); break;
         case 24: DropMonkGloves(oPC, OBJECT_SELF, 4, 0, 1); break;
         case 25: DropMonkGloves(oPC, OBJECT_SELF, 5, 0, 1); break;

         case 26: DropGem(oPC, OBJECT_SELF, 1); break;
         case 27: DropGem(oPC, OBJECT_SELF, 2); break;
         case 28: DropGem(oPC, OBJECT_SELF, 3); break;
         case 29: DropGem(oPC, OBJECT_SELF, 4); break;
         case 30: DropGem(oPC, OBJECT_SELF, 5); break;

         case 31: {
         DropWeapon(oPC, OBJECT_SELF, 1, 100, 1);
         DropShield(oPC, OBJECT_SELF, 1, 100, 1);
         DropArmor(oPC, OBJECT_SELF, 1, 100, 1);
         DropMagicItem(oPC, OBJECT_SELF, 1, 100, 1);
         DropMonkGloves(oPC, OBJECT_SELF, 1, 100, 1);}break;
        }

object oItem = GetFirstItemInInventory(OBJECT_SELF);
while (GetIsObjectValid(oItem))
      {
       if (GetIdentified(oItem)==FALSE)SetIdentified(oItem, TRUE);
       oItem = GetNextItemInInventory(OBJECT_SELF);
      }

}
