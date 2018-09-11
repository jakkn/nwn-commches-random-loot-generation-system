void main()
{
 object oPC = GetLastUsedBy();
 object oArea = GetArea(oPC);
 effect eBlood = EffectVisualEffect(VFX_COM_CHUNK_RED_LARGE);
 effect eDeath = EffectDeath(TRUE, FALSE);

 object oCreature = GetFirstObjectInArea(oArea);
 while (GetIsObjectValid(oCreature))
       {
        if (GetObjectType(oCreature)==OBJECT_TYPE_CREATURE&&
            GetIsEnemy(oPC, oCreature))
            {
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eBlood, oCreature);
             ApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oCreature);
            }
       oCreature = GetNextObjectInArea(oArea);
      }
}
