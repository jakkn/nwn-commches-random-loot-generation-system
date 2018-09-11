void main()
{
object oPC = GetLastClosedBy();
object oItem;
object oCorpse = GetLocalObject(OBJECT_SELF, "oHostBody");
object oBlood = GetLocalObject(OBJECT_SELF, "oBlood");
object oBones;
location lLoc = GetLocation(oCorpse);
int iCount;

AssignCommand(oPC, ClearAllActions());

oItem = GetFirstItemInInventory(OBJECT_SELF);
while (GetIsObjectValid(oItem))
      {
       ++iCount;
       oItem = GetNextItemInInventory(OBJECT_SELF);
      }
if (iCount==0){
               AssignCommand(oCorpse, SetIsDestroyable(TRUE, FALSE, FALSE));
               DestroyObject(oBlood);
               DestroyObject(oCorpse);
               if ((GetRacialType(oCorpse) != RACIAL_TYPE_CONSTRUCT) &&
                   (GetRacialType(oCorpse) != RACIAL_TYPE_ELEMENTAL)&&
                   (GetRacialType(oCorpse) != RACIAL_TYPE_DRAGON)&&
                   (GetRacialType(oCorpse) != RACIAL_TYPE_ANIMAL))

                  {
                   oBones = CreateObject(OBJECT_TYPE_PLACEABLE,
                   "plc_bones",
                   lLoc, FALSE);
                   ExecuteScript("sl_destroyself", oBones);
                  }
               DestroyObject(OBJECT_SELF, 0.2f);
              }


}
