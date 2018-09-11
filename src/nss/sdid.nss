void main()
{
 object oPC = GetLastUsedBy();
 effect eLos = EffectVisualEffect(VFX_FNF_LOS_NORMAL_10);
 object oItem = GetFirstItemInInventory(oPC);
 while (GetIsObjectValid(oItem))
       {
        if (GetIdentified(oItem)==FALSE)SetIdentified(oItem, TRUE);
        oItem = GetNextItemInInventory(oPC);
       }
 ApplyEffectToObject(DURATION_TYPE_INSTANT, eLos, oPC);
}
