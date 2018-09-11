void SD_NAMECHEST(object oChest, string sChestRange)
{
 SetName(oChest, sChestRange);
}

void SPAWN_CHESTS(int iLevel)
{

object oMod = GetModule();
object oPC = GetFirstPC();

int iWC = iLevel+0;
int iSC = iLevel+5;
int iAC = iLevel+10;
int iMC = iLevel+15;
int iGC = iLevel+20;
int iGM = iLevel+25;

string sLevel = IntToString(iLevel);


string sWLev = IntToString(iWC);
string sSLev = IntToString(iSC);
string sALev = IntToString(iAC);
string sMLev = IntToString(iMC);
string sGLev = IntToString(iGC);
string sGMLev = IntToString(iGM);


object oWP1 = GetWaypointByTag("sd_weap");
object oWP2 = GetWaypointByTag("sd_shield");
object oWP3 = GetWaypointByTag("sd_arm");
object oWP4 = GetWaypointByTag("sd_magi");
object oWP5 = GetWaypointByTag("sd_gloves");
object oWP6 = GetWaypointByTag("sd_gems");

effect eDiss = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
effect eApp = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);

object oCH1 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP1), FALSE, sWLev);
DelayCommand(0.1, SD_NAMECHEST(oCH1, "Weapon Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH1));
object oCH2 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP2), FALSE, sSLev);
DelayCommand(0.1, SD_NAMECHEST(oCH2, "Shield Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH2));
object oCH3 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP3), FALSE, sALev);
DelayCommand(0.1, SD_NAMECHEST(oCH3, "Armor Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH3));
object oCH4 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP4), FALSE, sMLev);
DelayCommand(0.1, SD_NAMECHEST(oCH4, "Mag Item Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH4));
object oCH5 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP5), FALSE, sGLev);
DelayCommand(0.1, SD_NAMECHEST(oCH5, "Monk Gloves Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH5));
object oCH6 = CreateObject(OBJECT_TYPE_PLACEABLE, "sd_lootchest", GetLocation(oWP6), FALSE, sGMLev);
DelayCommand(0.1, SD_NAMECHEST(oCH6, "Gem Chest: Range "+sLevel));
DelayCommand(0.3, ApplyEffectToObject(DURATION_TYPE_INSTANT, eApp, oCH6));
}

void main()
{
 object oMod = GetModule();
 object oPC = GetFirstPC();
 int iLevel = GetLocalInt(oMod, "range");

 ++iLevel;

 if (iLevel>=6)iLevel=1;

 SetLocalInt(oMod, "range", iLevel);


 effect eDiss = EffectVisualEffect(VFX_FNF_DISPEL_GREATER);
 effect eApp = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);

 int iSafe = GetLocalInt(OBJECT_SELF, "switched");
 if (iSafe==1){FloatingTextStringOnCreature("You must wait 5 seconds", oPC);return;}

 AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_ACTIVATE));
 AssignCommand(OBJECT_SELF, ActionPlayAnimation(ANIMATION_PLACEABLE_DEACTIVATE));

 SetLocalInt(OBJECT_SELF, "switched", 1);
 DelayCommand(6.0, SetLocalInt(OBJECT_SELF, "switched", 0));

 object oArea = GetArea(OBJECT_SELF);
 object oItem = GetFirstObjectInArea(oArea);
 while (GetIsObjectValid(oItem))
       {
        if (GetObjectType(oItem)==OBJECT_TYPE_PLACEABLE &&
        GetHasInventory(oItem) && GetName(oItem)!="Socketed Items")
           {
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eDiss, oItem);
            DestroyObject(oItem, 0.2f);
           }
        oItem = GetNextObjectInArea(oArea);
       }


DelayCommand(4.0, SPAWN_CHESTS(iLevel));
}
