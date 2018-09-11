#include "nw_i0_plot"
#include "sd_set_item_inc"


void main()
{
  object oRespawner = GetLastRespawnButtonPresser();
  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectResurrection(),oRespawner);
  ApplyEffectToObject(DURATION_TYPE_INSTANT,EffectHeal(GetMaxHitPoints(oRespawner)), oRespawner);
  RemoveEffects(oRespawner);
  ApplySetBonus(oRespawner);
}
