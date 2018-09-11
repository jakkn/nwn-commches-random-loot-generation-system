void main()
{
 object oPC = GetLastUsedBy();
 effect eLos = EffectDeath(TRUE);
 ApplyEffectToObject(DURATION_TYPE_INSTANT, eLos, oPC);
}
