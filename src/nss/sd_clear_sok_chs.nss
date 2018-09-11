void main()
{
 object oItem = GetFirstItemInInventory(OBJECT_SELF);
while (GetIsObjectValid(oItem))
      {
       DestroyObject(oItem);
       oItem = GetNextItemInInventory(OBJECT_SELF);
      }

}
