//////////////////////////////////////////////////////////
//::use: #include"sd_lootsystem"
//::
//::
//::  Slayers of Darkmoon loot generation system
//::
//::
//::
//::  Commche 2006
//::

#include "x2_inc_itemprop"
#include "nw_i0_generic"

//////////////////////////////////////////////////////////
//: Constants
//:
//:note* See line 4408 for specific item droprate configuration

const int LUCK_CHANCE = 5000; // 1 in x chance getting a much better item (0 for off)
const int DROP_RATE = 4;      // % modifyer for loot drop (see line 4619 for specifics)
const int CHANCE_WORN = 15;   // % chance of worn item (0 for off)
const int CHANCE_BROKEN = 5;  // % chance of broken item (0 for off)

// Generates a random weapon
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the weapon
// iRange = the quality of the weapon: 1=lowest 5=highest
// SockChance = a % chance for the generated weapon to be socketed
// DamBroke = a switch to disable chance of damaged/broken weapon: 0=on 1=off
void DropWeapon(object oMob, object oSack, int iRange, int SockChance, int DamBroke);

// Generates random chest armor
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the armor
// iRange = the quality of the armor: 1=lowest 5=highest
// SockChance = a % chance for the generated armor to be socketed
// DamBroke = a switch to disable chance of damaged/broken armor: 0=on 1=off
void DropArmor(object oMob, object oSack, int iRange, int SockChance, int DamBroke);

// Generates a random shield
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the shield
// iRange = the quality of the shield: 1=lowest 5=highest
// SockChance = a % chance for the generated shield to be socketed
// DamBroke = a switch to disable chance of damaged/broken shield: 0=on 1=off
void DropShield(object oMob, object oSack, int iRange, int SockChance, int DamBroke);

// Generates random monk gloves
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the gloves
// iRange = the quality of the gloves: 1=lowest 5=highest
// SockChance = a % chance for the generated gloves to be socketed
// DamBroke = a switch to disable chance of damaged/broken gloves: 0=on 1=off
void DropMonkGloves(object oMob, object oSack, int iRange, int SockChance, int DamBroke);

// Generates a random magic item (i.e. boots, helm, amulet, ring, belt, bracer)
// ============================================================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the item
// iRange = the quality of the item: 1=lowest 5=highest
// SockChance = a % chance for the generated item to be socketed
// DamBroke = a switch to disable chance of damaged/broken item: 0=on 1=off
void DropMagicItem(object oMob, object oSack, int iRange, int SockChance, int DamBroke);

// Generates a random socket gem
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the gem
// iRange = the quality of the gem: 1=lowest 5=highest
void DropGem(object oMob, object oSack, int iRange);

// Generates random ranged ammo (only arrows & bolts)
// ==================================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the ammo
// iRange = the quality of the ammo: 1=lowest 5=highest
void DropAmmo(object oMob, object oSack, int iRange);

// Generates a random scroll
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the scroll
// iRange = the quality of the scroll: 1=lowest 5=highest
// note* this is based on the gold-value of the scroll
void DropScroll(object oMob, object oSack, int iRange);

// Generates a random potion
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the potion
void DropPot(object oMob, object oSack);

// Generates a random misc item (i.e. bag)
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the misc
void DropMisc(object oMob, object oSack);

// Generates a random rod or wand
// =======================================
// oMob = the creature that just died
// oSack = the object into which you will spawn the rod or wand
void DropRodWand(object oMob, object oSack);

// Generates random gold
// ==================================================
// oMob = the creature that just died
// note* the gold amount will be based on the creature's level using the below formula
// Gold = (d20()*Creature LVL)+(15*Creature LVL)+iBonus
// oSack = the object into which you will spawn the ammo
// iBonus = additional gold to be added to the tally
void DropGold(object oMob, object oSack, int iBonus);

// Drop randomly chosen and generated loot & some gold
// ===================================================
// *This is the main call function of the sd lootsystem
// oMob = the creature that just died (the loot dropped is based on their class & level)
// oSack = the object into which you will spawn the loot
void sd_droploot (object oMob, object oSack);

// Drop randomly chosen class set item piece
// ===================================================
// *you can control what class type of set item will drop
// oMob = the creature that just died (the loot dropped is based on their class & level)
// oSack = the object into which you will spawn the loot
// iClass = the pereferred class of the drop
// eg:
// (1 - Fighter (2 - wiz (3 - sorc (4 - rogue/dex fighter (5 -cleric (6 - bard
// (7 - pally (8 - druid (9 - ranger (10 - monk (11 - barb (12 - weapon sets
// Default is 0: this will instead choose randomly from every item regardless
// of class
void DropSetItem(object oMod, object oSack, int iClass = 0);



const string COLORTOKEN ="                  ##################$%&'()*+,-./0123456789:;;==?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[[]^_`abcdefghijklmnopqrstuvwxyz{|}~~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü°°¢£§•¶ß®©™´¨¨ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛˛";

string ColorString(string sText, int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLORTOKEN, nRed, 1) + GetSubString(COLORTOKEN, nGreen, 1) + GetSubString(COLORTOKEN, nBlue, 1) + ">" + sText + "</c>";
}

void SetThreatLevel(object oMob)
{
 int iHD = GetHitDice(OBJECT_SELF);
 int iRange;
 string sName;
 string cName = GetName(oMob);

 if (iHD>0&&iHD<6)iRange=1;    // lvl 1-5
 if (iHD>5&&iHD<11)iRange=2;   // lvl 6-10
 if (iHD>10&&iHD<21)iRange=3;  // lvl 11-20
 if (iHD>20&&iHD<31)iRange=4;  // lvl 21-30
 if (iHD>30&&iHD<41)iRange=5;  // lvl 31-40

 switch(iRange)
       {
        case 1: sName = ColorString(cName,255, 255, 255); break;
        case 2: sName = ColorString(cName,189, 183, 107); break;
        case 3: sName = ColorString(cName,218, 165, 32); break;
        case 4: sName = ColorString(cName,210, 105, 30); break;
        case 5: sName = ColorString(cName,255, 0, 0); break;
       }
 if (GetLocalInt(OBJECT_SELF, "BOSS")==1)sName = ColorString(cName,255, 255, 0);
 SetName(oMob, sName);
}

void NameSack(object oSack)
{
 string sName = GetName(OBJECT_SELF);
 sName+= " Corpse";
 SetName(oSack, sName);
}

void InvClear (object oMob)
{
 object oItem = GetFirstItemInInventory(oMob);
 while (GetIsObjectValid(oItem))
       {
        if (GetPlotFlag(oItem)==FALSE)DestroyObject(oItem);
        oItem = GetNextItemInInventory(oMob);
       }
}
void LootClear (object oMob)
{
 object oItem = GetFirstItemInInventory(oMob);
 while (GetIsObjectValid(oItem))
       {
        DestroyObject(oItem);
        oItem = GetNextItemInInventory(oMob);
       }
DestroyObject(oMob);
}


void DropScroll(object oMob, object oSack, int iRange)
{
 string sType;
 int nRandom = Random(16) + 1;
 int iRoll;

 if (iRange==1)         // scrolls up to max value of 300
    {
     iRoll = d100();
     switch (iRoll)
        {
        case 1: sType = "x1_it_sparscr002";break;
        case 2: sType = "nw_it_sparscr107";break;
        case 3: sType = "x1_it_sparscr102";break;
        case 4: sType = "x1_it_spdvscr101";break;
        case 5: sType = "x2_it_spdvscr202";break;
        case 6: sType = "x2_it_spdvscr103";break;
        case 7: sType = "x2_it_spdvscr102";break;
        case 8: sType = "nw_it_sparscr211";break;
        case 9: sType = "x1_it_spdvscr202";break;
        case 10: sType = "nw_it_sparscr212";break;
        case 11: sType = "nw_it_sparscr112";break;
        case 12: sType = "x1_it_spdvscr107";break;
        case 13: sType = "nw_it_sparscr213";break;
        case 14: sType = "x2_it_sparscr207";break;
        case 15: sType = "nw_it_sparscr107";break;
        case 16: sType = "nw_it_spdvscr202";break;
        case 17: sType = "nw_it_sparscr217";break;
        case 18: sType = "x2_it_sparscr206";break;
        case 19: sType = "nw_it_sparscr110";break;
        case 20: sType = "x2_it_sparscr201";break;
        case 21: sType = "x1_it_spdvscr301";break;
        case 22: sType = "x2_it_spdvscr104";break;
        case 23: sType = "x2_it_spdvscr001";break;
        case 24: sType = "x2_it_spdvscr203";break;
        case 25: sType = "x2_it_spdvscr308";break;
        case 26: sType = "nw_it_sparscr206";break;
        case 27: sType = "nw_it_sparscr003";break;
        case 28: sType = "x2_it_spdvscr101";break;
        case 29: sType = "x2_it_sparscr202";break;
        case 30: sType = "x1_it_spdvscr102";break;
        case 31: sType = "x2_it_spdvscr105";break;
        case 32: sType = "nw_it_sparscr219";break;
        case 33: sType = "x1_it_sparscr003";break;
        case 34: sType = "nw_it_sparscr215";break;
        case 35: sType = "nw_it_sparscr101";break;
        case 36: sType = "x2_it_spdvscr106";break;
        case 37: sType = "x1_it_spdvscr103";break;
        case 38: sType = "x1_it_sparscr101";break;
        case 39: sType = "x1_it_sparscr101";break;
        case 40: sType = "x2_it_sparscr305";break;
        case 41: sType = "x1_it_spdvscr205";break;
        case 42: sType = "x2_it_sparscr205";break;
        case 43: sType = "x1_it_sparscr001";break;
        case 44: sType = "nw_it_sparscr220";break;
        case 45: sType = "x2_it_sparscr203";break;
        case 46: sType = "nw_it_sparscr208";break;
        case 47: sType = "nw_it_sparscr209";break;
        case 48: sType = "nw_it_sparscr103";break;
        case 49: sType = "x2_it_spdvscr204";break;
        case 50: sType = "nw_it_sparscr308";break;
        case 51: sType = "x2_it_sparscr101";break;
        case 52: sType = "x2_it_sparscr104";break;
        case 53: sType = "nw_it_sparscr106";break;
        case 54: sType = "x1_it_spdvscr104";break;
        case 55: sType = "x1_it_spdvscr001";break;
        case 56: sType = "x1_it_spdvscr201";break;
        case 57: sType = "nw_it_sparscr207";break;
        case 58: sType = "x2_it_sparscr102";break;
        case 59: sType = "nw_it_sparscr216";break;
        case 60: sType = "nw_it_sparscr218";break;
        case 61: sType = "nw_it_spdvscr201";break;
        case 62: sType = "nw_it_sparscr004";break;
        case 63: sType = "nw_it_sparscr104";break;
        case 64: sType = "x1_it_spdvscr106";break;
        case 65: sType = "nw_it_sparscr109";break;
        case 66: sType = "x2_it_sparscr105";break;
        case 67: sType = "nw_it_sparscr202";break;
        case 68: sType = "nw_it_sparscr113";break;
        case 69: sType = "x1_it_spdvscr203";break;
        case 70: sType = "nw_it_sparscr221";break;
        case 71: sType = "nw_it_sparscr102";break;
        case 72: sType = "x2_it_sparscral";break;
        case 73: sType = "nw_it_sparscr111";break;
        case 74: sType = "nw_it_sparscr002";break;
        case 75: sType = "x2_it_spdvscr107";break;
        case 76: sType = "x2_it_spdvscr205";break;
        case 77: sType = "nw_it_sparscr201";break;
        case 78: sType = "nw_it_sparscr001";break;
        case 79: sType = "x2_it_spdvscr108";break;
        case 80: sType = "nw_it_sparscr210";break;
        case 81: sType = "x2_it_sparscr103";break;
        case 82: sType = "x1_it_sparscr103";break;
        case 83: sType = "x1_it_spdvscr105";break;
        case 84: sType = "nw_it_spdvscr203";break;
        case 85: sType = "nw_it_sparscr108";break;
        case 86: sType = "nw_it_spdvscr204";break;
        case 87: sType = "x2_it_sparscr204";break;
        case 88: sType = "nw_it_sparscr105";break;
        case 89: sType = "nw_it_sparscr203";break;
        case 90: sType = "x1_it_sparscr202";break;
        case 91: sType = "x1_it_sparscr104";break;
        case 92: sType = "nw_it_sparscr214";break;
        case 93: sType = "x2_it_spdvscr002";break;
        case 94: sType = "nw_it_sparscr204";break;
       }
    }
 if (iRange==2)
    {
     iRoll = d100();    /// scrolls valued 540-1621
     switch (iRoll)
        {
        case 1: sType = "nw_it_sparscr509";break;
        case 2: sType = "x2_it_spdvscr508";break;
        case 3: sType = "x2_it_sparscr501";break;
        case 4: sType = "x2_it_spdvscr501";break;
        case 5: sType = "nw_it_sparscr414";break;
        case 6: sType = "x1_it_sparscr502";break;
        case 7: sType = "x2_it_spdvscr307";break;
        case 8: sType = "nw_it_sparscr405";break;
        case 9: sType = "x2_it_spdvscr504";break;
        case 10: sType = "nw_it_sparscr307";break;
        case 11: sType = "nw_it_sparscr502";break;
        case 12: sType = "nw_it_sparscr507";break;
        case 13: sType = "nw_it_sparscr406";break;
        case 14: sType = "nw_it_sparscr411";break;
        case 15: sType = "x2_it_spdvscr402";break;
        case 16: sType = "x2_it_spdvscr305";break;
        case 17: sType = "x2_it_spdvscr403";break;
        case 18: sType = "nw_it_sparscr501";break;
        case 19: sType = "nw_it_sparscr301";break;
        case 20: sType = "x1_it_sparscr301";break;
        case 21: sType = "x2_it_spdvscr404";break;
        case 22: sType = "x2_it_spdvscr309";break;
        case 23: sType = "nw_it_sparscr416";break;
        case 24: sType = "nw_it_sparscr503";break;
        case 25: sType = "nw_it_sparscr608";break;
        case 26: sType = "nw_it_sparscr418";break;
        case 27: sType = "x2_it_spdvscr509";break;
        case 28: sType = "nw_it_sparscr413";break;
        case 29: sType = "nw_it_sparscr504";break;
        case 30: sType = "nw_it_sparscr309";break;
        case 31: sType = "x1_it_sparscr501";break;
        case 32: sType = "nw_it_sparscr304";break;
        case 33: sType = "x1_it_spdvscr403";break;
        case 34: sType = "x2_it_spdvscr405";break;
        case 35: sType = "x2_it_spdvscr306";break;
        case 36: sType = "x2_it_sparscr701";break;
        case 37: sType = "nw_it_sparscr602";break;
        case 38: sType = "x1_it_spdvscr303";break;
        case 39: sType = "x2_it_sparscr304";break;
        case 40: sType = "nw_it_sparscr508";break;
        case 41: sType = "x1_it_sparscr303";break;
        case 42: sType = "x2_it_spdvscr406";break;
        case 43: sType = "nw_it_sparscr312";break;
        case 44: sType = "x2_it_spdvscr505";break;
        case 45: sType = "x2_it_spdvscr302";break;
        case 46: sType = "nw_it_sparscr505";break;
        case 47: sType = "x2_it_spdvscr401";break;
        case 48: sType = "nw_it_sparscr408";break;
        case 49: sType = "x1_it_spdvscr501";break;
        case 50: sType = "x2_it_spdvscr301";break;
        case 51: sType = "x1_it_spdvscr401";break;
        case 52: sType = "x1_it_spdvscr302";break;
        case 53: sType = "x2_it_spdvscr310";break;
        case 54: sType = "nw_it_sparscr314";break;
        case 55: sType = "x1_it_sparscr401";break;
        case 56: sType = "x2_it_sparscr303";break;
        case 57: sType = "x2_it_sparscr602";break;
        case 58: sType = "nw_it_sparscr511";break;
        case 59: sType = "nw_it_sparscr512";break;
        case 60: sType = "nw_it_sparscr417";break;
        case 61: sType = "nw_it_sparscr513";break;
        case 62: sType = "nw_it_sparscr310";break;
        case 63: sType = "nw_it_sparscr302";break;
        case 64: sType = "x2_it_sparscrmc";break;
        case 65: sType = "x2_it_spdvscr304";break;
        case 66: sType = "x1_it_spdvscr402";break;
        case 67: sType = "x2_it_sparscr301";break;
        case 68: sType = "x2_it_sparscr502";break;
        case 69: sType = "nw_it_sparscr506";break;
        case 70: sType = "nw_it_sparscr401";break;
        case 71: sType = "x2_it_spdvscr502";break;
        case 72: sType = "nw_it_sparscr315";break;
        case 73: sType = "x2_it_spdvscr311";break;
        case 74: sType = "nw_it_spdvscr402";break;
        case 75: sType = "x1_it_spdvscr502";break;
        case 76: sType = "nw_it_sparscr409";break;
        case 77: sType = "x2_it_spdvscr407";break;
        case 78: sType = "nw_it_sparscr415";break;
        case 79: sType = "x2_it_spdvscr312";break;
        case 80: sType = "x1_it_spdvscr305";break;
        case 81: sType = "nw_it_spdvscr501";break;
        case 82: sType = "nw_it_spdvscr301";break;
        case 83: sType = "nw_it_sparscr402";break;
        case 84: sType = "nw_it_spdvscr401";break;
        case 85: sType = "x2_it_sparscr302";break;
        case 86: sType = "nw_it_sparscr410";break;
        case 87: sType = "x2_it_spdvscr506";break;
        case 88: sType = "nw_it_sparscr313";break;
        case 89: sType = "x2_it_spdvscr507";break;
        case 90: sType = "x1_it_spdvscr304";break;
        case 91: sType = "nw_it_sparscr305";break;
        case 92: sType = "nw_it_sparscr403";break;
        case 93: sType = "nw_it_sparscr306";break;
        case 94: sType = "nw_it_sparscr404";break;
        case 95: sType = "nw_it_sparscr510";break;
        case 96: sType = "x2_it_sparscr902";break;
        case 97: sType = "nw_it_sparscr606";break;
        case 98: sType = "x2_it_spdvscr503";break;
        case 99: sType = "nw_it_sparscr407";break;
        case 100: sType = "x1_it_sparscr302";break;
       }
    }
 if (iRange==3)
    {
     iRoll = d100();// scrolls valued 2400-3200
     switch (iRoll)
        {
        case 1: sType = "nw_it_sparscr603";break;
        case 2: sType = "x1_it_spdvscr701";break;
        case 3: sType = "x1_it_spdvscr601";break;
        case 4: sType = "x1_it_sparscr602";break;
        case 5: sType = "x1_it_sparscr701";break;
        case 6: sType = "x2_it_spdvscr603";break;
        case 7: sType = "nw_it_sparscr607";break;
        case 8: sType = "nw_it_sparscr610";break;
        case 9: sType = "nw_it_sparscr707";break;
        case 10: sType = "x1_it_spdvscr605";break;
        case 11: sType = "x1_it_spdvscr702";break;
        case 12: sType = "x2_it_spdvscr601";break;
        case 13: sType = "nw_it_sparscr704";break;
        case 14: sType = "x1_it_spdvscr703";break;
        case 15: sType = "x1_it_sparscr601";break;
        case 16: sType = "x1_it_spdvscr604";break;
        case 17: sType = "x2_it_sparscr503";break;
        case 18: sType = "nw_it_sparscr708";break;
        case 19: sType = "x1_it_spdvscr704";break;
        case 20: sType = "x1_it_sparscr605";break;
        case 21: sType = "nw_it_sparscr601";break;
        case 22: sType = "nw_it_spdvscr701";break;
        case 23: sType = "x1_it_spdvscr602";break;
        case 24: sType = "x2_it_spdvscr606";break;
        case 25: sType = "nw_it_sparscr612";break;
        case 26: sType = "nw_it_sparscr613";break;
        case 27: sType = "x2_it_spdvscr604";break;
        case 28: sType = "x2_it_spdvscr605";break;
        case 29: sType = "x1_it_sparscr603";break;
        case 30: sType = "nw_it_sparscr611";break;
        case 31: sType = "x1_it_spdvscr603";break;
        case 32: sType = "nw_it_sparscr604";break;
        case 33: sType = "nw_it_sparscr702";break;
        case 34: sType = "nw_it_sparscr706";break;
        case 35: sType = "nw_it_sparscr802";break;
        case 36: sType = "x2_it_spdvscr702";break;
        case 37: sType = "nw_it_spdvscr702";break;
        case 38: sType = "nw_it_sparscr609";break;
        case 39: sType = "x2_it_sparscr703";break;
        case 40: sType = "nw_it_sparscr701";break;
        case 41: sType = "x1_it_sparscr604";break;
        case 42: sType = "x2_it_spdvscr602";break;
        case 43: sType = "nw_it_sparscr605";break;
        case 44: sType = "nw_it_sparscr703";break;
        case 45: sType = "x2_it_spdvscr803";break;
        case 46: sType = "nw_it_sparscr614";break;
        case 47: sType = "nw_it_sparscr614";break;
        case 48: sType = "x2_it_sparscr601";break;
        case 49: sType = "x2_it_spdvscr701";break;
        case 50: sType = "nw_it_sparscr603";break;
        case 51: sType = "x1_it_spdvscr701";break;
        case 52: sType = "x1_it_spdvscr601";break;
        case 53: sType = "x1_it_sparscr602";break;
        case 54: sType = "x1_it_sparscr701";break;
        case 55: sType = "x2_it_spdvscr603";break;
        case 56: sType = "nw_it_sparscr607";break;
        case 57: sType = "nw_it_sparscr610";break;
        case 58: sType = "nw_it_sparscr707";break;
        case 59: sType = "x1_it_spdvscr605";break;
        case 60: sType = "x1_it_spdvscr702";break;
        case 61: sType = "x2_it_spdvscr601";break;
        case 62: sType = "nw_it_sparscr704";break;
        case 63: sType = "x1_it_spdvscr703";break;
        case 64: sType = "x1_it_sparscr601";break;
        case 65: sType = "x1_it_spdvscr604";break;
        case 66: sType = "x2_it_sparscr503";break;
        case 67: sType = "nw_it_sparscr708";break;
        case 68: sType = "x1_it_spdvscr704";break;
        case 69: sType = "x1_it_sparscr605";break;
        case 70: sType = "nw_it_sparscr601";break;
        case 71: sType = "nw_it_spdvscr701";break;
        case 72: sType = "x1_it_spdvscr602";break;
        case 73: sType = "x2_it_spdvscr606";break;
        case 74: sType = "nw_it_sparscr612";break;
        case 75: sType = "nw_it_sparscr613";break;
        case 76: sType = "x2_it_spdvscr604";break;
        case 77: sType = "x2_it_spdvscr605";break;
        case 78: sType = "x1_it_sparscr603";break;
        case 79: sType = "nw_it_sparscr611";break;
        case 80: sType = "x1_it_spdvscr603";break;
        case 81: sType = "nw_it_sparscr604";break;
        case 82: sType = "nw_it_sparscr702";break;
        case 83: sType = "nw_it_sparscr706";break;
        case 84: sType = "nw_it_sparscr802";break;
        case 85: sType = "x2_it_spdvscr702";break;
        case 86: sType = "nw_it_spdvscr702";break;
        case 87: sType = "nw_it_sparscr609";break;
        case 88: sType = "x2_it_sparscr703";break;
        case 89: sType = "nw_it_sparscr701";break;
        case 90: sType = "x1_it_sparscr604";break;
        case 91: sType = "x2_it_spdvscr602";break;
        case 92: sType = "nw_it_sparscr605";break;
        case 93: sType = "nw_it_sparscr703";break;
        case 94: sType = "x2_it_spdvscr803";break;
        case 95: sType = "nw_it_sparscr614";break;
        case 96: sType = "nw_it_sparscr614";break;
        case 97: sType = "x2_it_sparscr601";break;
        case 98: sType = "x2_it_spdvscr701";break;
        case 99: sType = "x2_it_sparscr703";break;
        case 100: sType = "nw_it_sparscr701";break;
       }
    }
if (iRange==4||iRange==5)
    {
     iRoll = Random(40)+1;     // scrolls valued above 3200
     switch (iRoll)
        {
        case 1: sType = "nw_it_sparscr806";
        case 2: sType = "x2_it_spdvscr804";
        case 3: sType = "x1_it_sparscr801";
        case 4: sType = "x1_it_sparscr901";
        case 5: sType = "x2_it_sparscr901";
        case 6: sType = "x2_it_sparscr801";
        case 7: sType = "x1_it_spdvscr803";
        case 8: sType = "x1_it_spdvscr804";
        case 9: sType = "nw_it_sparscr905";
        case 10: sType = "x2_it_spdvscr901";
        case 11: sType = "nw_it_sparscr908";
        case 12: sType = "nw_it_sparscr902";
        case 13: sType = "nw_it_sparscr803";
        case 14: sType = "nw_it_sparscr912";
        case 15: sType = "nw_it_sparscr809";
        case 16: sType = "x2_it_spdvscr902";
        case 17: sType = "nw_it_sparscr804";
        case 18: sType = "nw_it_sparscr807";
        case 19: sType = "nw_it_sparscr806";
        case 20: sType = "x2_it_spdvscr801";
        case 21: sType = "nw_it_sparscr906";
        case 22: sType = "nw_it_sparscr801";
        case 23: sType = "nw_it_sparscr901";
        case 24: sType = "x2_it_spdvscr802";
        case 25: sType = "nw_it_sparscr903";
        case 26: sType = "nw_it_sparscr808";
        case 27: sType = "nw_it_sparscr910";
        case 28: sType = "x2_it_spdvscr903";
        case 29: sType = "nw_it_sparscr904";
        case 30: sType = "nw_it_sparscr805";
        case 31: sType = "x1_it_spdvscr802";
        case 32: sType = "nw_it_sparscr911";
        case 33: sType = "x1_it_spdvscr901";
        case 34: sType = "nw_it_sparscr909";
        case 35: sType = "nw_it_sparscr907";
        case 36: sType = "x1_it_spdvscr801";
        case 37: sType = "nw_it_sparscr906";
        case 38: sType = "nw_it_sparscr808";
        case 39: sType = "x2_it_sparscr801";
        case 40: sType = "x2_it_spdvscr804";
       }
   }

object oScroll =  CreateItemOnObject(sType, oSack, 1);
SetIdentified(oScroll, FALSE);
}

void DropPot(object oMod, object oSack)
{
 string sPotion;

 int nRandom = Random(29) + 1;
 switch (nRandom)
        {
         case 1:sPotion = "x2_it_mpotion001";  break;
         case 2:sPotion = "x2_it_mpotion001";  break;
         case 3:sPotion = "x2_it_mpotion001";  break;
         case 4:sPotion = "x2_it_mpotion001";  break;
         case 5:sPotion = "x2_it_mpotion001";  break;
         case 6:sPotion = "x2_it_mpotion001";  break;
         case 7:sPotion = "x2_it_mpotion001";  break;
         case 8:sPotion = "x2_it_mpotion001";  break;
         case 9: sPotion = "nw_it_mpotion001" ; break;
         case 10: sPotion = "nw_it_mpotion002" ; break;
         case 11: sPotion = "nw_it_mpotion003" ; break;
         case 12: sPotion = "nw_it_mpotion004" ; break;
         case 13: sPotion = "nw_it_mpotion005" ; break;
         case 14: sPotion = "nw_it_mpotion006";  break;
         case 15: sPotion = "nw_it_mpotion007";  break;
         case 16: sPotion = "nw_it_mpotion008";  break;
         case 17: sPotion = "nw_it_mpotion009";  break;
         case 18: sPotion = "nw_it_mpotion010";  break;
         case 19: sPotion = "nw_it_mpotion011";  break;
         case 20: sPotion = "nw_it_mpotion012";  break;
         case 21: sPotion = "nw_it_mpotion013";  break;
         case 22: sPotion = "nw_it_mpotion014";  break;
         case 23: sPotion = "nw_it_mpotion015";  break;
         case 24: sPotion = "nw_it_mpotion016";  break;
         case 25: sPotion = "nw_it_mpotion017";  break;
         case 26: sPotion = "nw_it_mpotion018";  break;
         case 27: sPotion = "nw_it_mpotion019";  break;
         case 28: sPotion = "nw_it_mpotion020";  break;
         case 29: sPotion = "x2_it_mpotion001";  break;
        }
 CreateItemOnObject(sPotion, oSack, 1);
}

void DropRodWand(object oMod, object oSack)
{
 string sType;

 int nRandom = Random(16) + 1;
 switch (nRandom)
        {
                       // rods

        case 1: sType = "nw_wmgmrd002";break;  //res
        case 2: sType = "nw_wmgmrd005";break;  //rev
        case 3: sType = "nw_wmgrd002";break;   // ghost
        case 4: sType = "nw_wmgmrd006";break;  // frost

                      // wands

        case 5: sType = "nw_wmgwn011";break;
        case 6: sType = "nw_wmgwn002";break;
        case 7: sType = "nw_wmgwn007";break;
        case 8: sType = "nw_wmgwn004";break;
        case 9: sType = "nw_wmgwn006";break;
        case 10: sType = "nw_wmgwn005";break;
        case 11: sType = "nw_wmgwn012";break;
        case 12: sType = "nw_wmgwn010";break;
        case 13: sType = "nw_wmgwn008";break;
        case 14: sType = "nw_wmgwn009";break;
        case 15: sType = "nw_wmgwn003";break;
        case 16: sType = "nw_wmgwn013";break;
        }
 CreateItemOnObject(sType, oSack, 1);
}

void DropMisc(object oMod, object oSack)
{
 string sName;

 int nDice = Random(30)+1;
 switch (nDice)
        {
        case 1: sName = "nw_it_contain006"; break; //bag holding
        case 2: sName = "nw_it_contain005"; break;  //gmbag
        case 3: sName = "nw_it_contain003"; break;  //lmbag
        case 4: sName = "nw_it_contain004"; break;  //mbag
        case 5: sName = "nw_it_contain002"; break;  //mpouch
        case 6: sName = "nw_it_msmlmisc05"; break;  //healpearl
        case 7: sName = "nw_it_mmidmisc04"; break;  //scab bless
        case 8: sName = "x0_it_msmlmisc05"; break;  //earth elem
        case 9: sName = "x0_it_mmedmisc03"; break;  //harp
        case 10: sName = "x0_it_msmlmisc01"; break; //water elem
        case 11: sName = "x0_it_msmlmisc02"; break; //fire elem
        case 12: sName = "x0_it_mmedmisc01"; break; //shielding
        case 13: sName = "x0_it_mthnmisc21"; break; //air elem
        case 14: sName = "x0_it_mthnmisc19"; break; //bard lire
        case 15: sName = "x0_it_mthnmisc17"; break; // bard spls
        case 16: sName = "x0_it_mmedmisc02"; break; // bard spls
        case 17: sName = "x0_it_mthnmisc05"; break; // dust app
        case 18: sName = "x0_it_mthnmisc06"; break; // dust dissapp
        case 19: sName = "x0_it_mthnmisc13"; break; // sunbeam
        case 20: sName = "x0_it_mthnmisc15"; break; //
        case 21: sName = "x0_it_mthnmisc14"; break; // lath chal
        case 22: sName = "nw_it_mmidmisc01"; break; // harp charm
        case 23: sName = "nw_it_mmidmisc02"; break; // harp haunt
        case 24: sName = "nw_it_mmidmisc03"; break; // harp pand
        case 25: sName = "x0_it_msmlmisc06"; break; // horn good/evil
        case 26: sName = "x0_it_mthnmisc09"; break; //
        case 27: sName = "nw_it_contain001"; break; // box
        case 28: sName = "nw_it_contain006"; break; //bag holding
        case 29: sName = "nw_it_contain005"; break;  //gmbag
        case 30: sName = "nw_it_contain003"; break;  //lmbag
        }
 CreateItemOnObject(sName, oSack, 1);
}

void DropSetItem(object oMod, object oSack, int iClass)
{
 string sName;
 int iDice;

 if (iClass==0)iClass = d12();

 switch (iClass)
  {
   case 1:{        // STR Fighter Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_fighter_s1_1"; break;
        case 2: sName = "sd_fighter_s1_2"; break;
        case 3: sName = "sd_fighter_s1_3"; break;
        case 4: sName = "sd_fighter_s1_4"; break;
        case 5: sName = "sd_fighter_s1_5"; break;
        case 6: sName = "sd_fighter_s1_6"; break;
        }}break;
   case 2:{        // Wizard Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_wizard_s1_1"; break;
        case 2: sName = "sd_wizard_s1_2"; break;
        case 3: sName = "sd_wizard_s1_3"; break;
        case 4: sName = "sd_wizard_s1_4"; break;
        case 5: sName = "sd_wizard_s1_5"; break;
        case 6: sName = "sd_wizard_s1_6"; break;
        }}break;
   case 3:{        // Sorcerer Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_sorc_s1_1"; break;
        case 2: sName = "sd_sorc_s1_2"; break;
        case 3: sName = "sd_sorc_s1_3"; break;
        case 4: sName = "sd_sorc_s1_4"; break;
        case 5: sName = "sd_sorc_s1_5"; break;
        case 6: sName = "sd_sorc_s1_6"; break;
        }}break;
   case 4:{        // DEX Fighter/Rogue Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_fighter_s2_1"; break;
        case 2: sName = "sd_fighter_s2_2"; break;
        case 3: sName = "sd_fighter_s2_3"; break;
        case 4: sName = "sd_fighter_s2_4"; break;
        case 5: sName = "sd_fighter_s2_5"; break;
        case 6: sName = "sd_fighter_s2_6"; break;
        }} break;
   case 5:{        // Cleric Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_cleric_s1_1"; break;
        case 2: sName = "sd_cleric_s1_2"; break;
        case 3: sName = "sd_cleric_s1_3"; break;
        case 4: sName = "sd_cleric_s1_4"; break;
        case 5: sName = "sd_cleric_s1_5"; break;
        case 6: sName = "sd_cleric_s1_6"; break;
        }} break;
   case 6:{        // Bard Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_bard_s1_1"; break;
        case 2: sName = "sd_bard_s1_2"; break;
        case 3: sName = "sd_bard_s1_3"; break;
        case 4: sName = "sd_bard_s1_4"; break;
        case 5: sName = "sd_bard_s1_5"; break;
        case 6: sName = "sd_bard_s1_6"; break;
        }}break;
   case 7:{        // Paladin Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_paladin_s1_1"; break;
        case 2: sName = "sd_paladin_s1_2"; break;
        case 3: sName = "sd_paladin_s1_3"; break;
        case 4: sName = "sd_paladin_s1_4"; break;
        case 5: sName = "sd_paladin_s1_5"; break;
        case 6: sName = "sd_paladin_s1_6"; break;
        }}break;
   case 8:{        // Druid Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_druid_s1_1"; break;
        case 2: sName = "sd_druid_s1_2"; break;
        case 3: sName = "sd_druid_s1_3"; break;
        case 4: sName = "sd_druid_s1_4"; break;
        case 5: sName = "sd_druid_s1_5"; break;
        case 6: sName = "sd_druid_s1_6"; break;
        }}break;
   case 9:{        // Ranger Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_ranger_s1_1"; break;
        case 2: sName = "sd_ranger_s1_2"; break;
        case 3: sName = "sd_ranger_s1_3"; break;
        case 4: sName = "sd_ranger_s1_4"; break;
        case 5: sName = "sd_ranger_s1_5"; break;
        case 6: sName = "sd_ranger_s1_6"; break;
        }}break;
   case 10:{        // Monk Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_monk_s1_1"; break;
        case 2: sName = "sd_monk_s1_2"; break;
        case 3: sName = "sd_monk_s1_3"; break;
        case 4: sName = "sd_monk_s1_4"; break;
        case 5: sName = "sd_monk_s1_5"; break;
        case 6: sName = "sd_monk_s1_6"; break;
        }}break;
   case 11:{        // Barbarian Set
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_barb_s1_6"; break;
        case 2: sName = "sd_barb_s1_1"; break;
        case 3: sName = "sd_barb_s1_2"; break;
        case 4: sName = "sd_barb_s1_3"; break;
        case 5: sName = "sd_barb_s1_4"; break;
        case 6: sName = "sd_barb_s1_5"; break;
        }}break;
   case 12:{        // Duel Weapon/Weapon & Shield Sets
        iDice = d6();
        switch(iDice)
        {
        case 1: sName = "sd_weap_s1_1"; break;
        case 2: sName = "sd_weap_s1_2"; break;
        case 3: sName = "sd_weap_s2_1"; break;
        case 4: sName = "sd_weap_s2_2"; break;
        case 5: sName = "sd_weap_s3_1"; break;
        case 6: sName = "sd_weap_s3_2"; break;
        }}break;
  }
// comming soon: Ring Sets, Ammy/Ring Sets


//////////////////////////////////////
//:Debugging
 FloatingTextStringOnCreature("Class: "+IntToString(iClass), oMod);
 FloatingTextStringOnCreature("Roll: "+IntToString(iDice), oMod);
 FloatingTextStringOnCreature(sName, oMod);

 CreateItemOnObject(sName, oSack, 1);
}


void DropGold (object oMob, object oSack, int iBonus)
{
string sGold, sLvl;
int iHD = GetHitDice(oMob);
int iGold = 0;

iGold = (d20()*iHD)+(15*iHD)+iBonus;

CreateItemOnObject("nw_it_gold001", oSack, iGold);

/////////////////////////////////////////////////////////////////////////
//Gold Debugging
//object oPC = GetFirstPC();
//sGold = IntToString(iGold);
//sLvl = IntToString(iHD);
//FloatingTextStringOnCreature(sGold+" Gold Spawned by lvl "+sLvl+" mob", oPC);
//
//
//
}

void CastImbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iSpell;
 int iUses;
 int iRoll;
 switch (iRange)
      {
       case 1: {
                iRoll = d8();
                if (iRoll==1)iSpell = IP_CONST_CASTSPELL_BURNING_HANDS_2;
                if (iRoll==2)iSpell = IP_CONST_CASTSPELL_BARKSKIN_3;
                if (iRoll==3)iSpell = IP_CONST_CASTSPELL_MAGE_ARMOR_2;
                if (iRoll==4)iSpell = IP_CONST_CASTSPELL_MAGIC_MISSILE_5;
                if (iRoll==5)iSpell = IP_CONST_CASTSPELL_COLOR_SPRAY_2;
                if (iRoll==6)iSpell = IP_CONST_CASTSPELL_DOOM_5;
                if (iRoll==7)iSpell = IP_CONST_CASTSPELL_ENTANGLE_5;
                if (iRoll==8)iSpell = IP_CONST_CASTSPELL_GHOSTLY_VISAGE_3;
               }break;
       case 2: {
                iRoll = d8();
                if (iRoll==1)iSpell = IP_CONST_CASTSPELL_DISPLACEMENT_9;
                if (iRoll==2)iSpell = IP_CONST_CASTSPELL_FIREBALL_10;
                if (iRoll==3)iSpell = IP_CONST_CASTSPELL_MAGIC_CIRCLE_AGAINST_ALIGNMENT_5;
                if (iRoll==4)iSpell = IP_CONST_CASTSPELL_SLAY_LIVING_9;
                if (iRoll==5)iSpell = IP_CONST_CASTSPELL_STONESKIN_7;
                if (iRoll==6)iSpell = IP_CONST_CASTSPELL_ICE_STORM_9;
                if (iRoll==7)iSpell = IP_CONST_CASTSPELL_CALL_LIGHTNING_10;
                if (iRoll==8)iSpell = IP_CONST_CASTSPELL_ISAACS_LESSER_MISSILE_STORM_13;
               }break;
       case 3: {
                iRoll = d8();
                if (iRoll==1)iSpell = IP_CONST_CASTSPELL_SUNBEAM_13;
                if (iRoll==2)iSpell = IP_CONST_CASTSPELL_CONE_OF_COLD_15;
                if (iRoll==3)iSpell = IP_CONST_CASTSPELL_MASS_HEAL_15;
                if (iRoll==4)iSpell = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15;
                if (iRoll==5)iSpell = IP_CONST_CASTSPELL_GREATER_DISPELLING_15;
                if (iRoll==6)iSpell = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15;
                if (iRoll==7)iSpell = IP_CONST_CASTSPELL_CHAIN_LIGHTNING_20;
                if (iRoll==8)iSpell = IP_CONST_CASTSPELL_GREATER_STONESKIN_11;
               }break;
       case 4: {
                iRoll = d12();
                if (iRoll==1)iSpell = IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15;
                if (iRoll==2)iSpell = IP_CONST_CASTSPELL_HORRID_WILTING_20;
                if (iRoll==3)iSpell = IP_CONST_CASTSPELL_IMPLOSION_17;
                if (iRoll==4)iSpell = IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15;
                if (iRoll==5)iSpell = IP_CONST_CASTSPELL_PREMONITION_15;
                if (iRoll==6)iSpell = IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17;
                if (iRoll==7)iSpell = IP_CONST_CASTSPELL_METEOR_SWARM_17;
                if (iRoll==8)iSpell = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15;
                if (iRoll==9)iSpell = IP_CONST_CASTSPELL_SUNBEAM_13;
                if (iRoll==10)iSpell = IP_CONST_CASTSPELL_CONE_OF_COLD_15;
                if (iRoll==11)iSpell = IP_CONST_CASTSPELL_MASS_HEAL_15;
                if (iRoll==12)iSpell = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15;
               }break;
       case 5: {
                iRoll = d20();
                if (iRoll==1)iSpell = IP_CONST_CASTSPELL_WAIL_OF_THE_BANSHEE_17;
                if (iRoll==2)iSpell = IP_CONST_CASTSPELL_TIME_STOP_17;
                if (iRoll==3)iSpell = IP_CONST_CASTSPELL_IMPLOSION_17;
                if (iRoll==4)iSpell = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15;
                if (iRoll==5)iSpell = IP_CONST_CASTSPELL_HORRID_WILTING_20;
                if (iRoll==6)iSpell = IP_CONST_CASTSPELL_MORDENKAINENS_SWORD_18;
                if (iRoll==7)iSpell = IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17;
                if (iRoll==8)iSpell = IP_CONST_CASTSPELL_MASS_HEAL_15;
                if (iRoll==9)iSpell = IP_CONST_CASTSPELL_BIGBYS_FORCEFUL_HAND_15;
                if (iRoll==10)iSpell = IP_CONST_CASTSPELL_HORRID_WILTING_20;
                if (iRoll==11)iSpell = IP_CONST_CASTSPELL_IMPLOSION_17;
                if (iRoll==12)iSpell = IP_CONST_CASTSPELL_INCENDIARY_CLOUD_15;
                if (iRoll==13)iSpell = IP_CONST_CASTSPELL_PREMONITION_15;
                if (iRoll==14)iSpell = IP_CONST_CASTSPELL_MORDENKAINENS_DISJUNCTION_17;
                if (iRoll==15)iSpell = IP_CONST_CASTSPELL_METEOR_SWARM_17;
                if (iRoll==16)iSpell = IP_CONST_CASTSPELL_ISAACS_GREATER_MISSILE_STORM_15;
                if (iRoll==17)iSpell = IP_CONST_CASTSPELL_SUNBEAM_13;
                if (iRoll==18)iSpell = IP_CONST_CASTSPELL_CONE_OF_COLD_15;
                if (iRoll==19)iSpell = IP_CONST_CASTSPELL_MASS_HEAL_15;
                if (iRoll==20)iSpell = IP_CONST_CASTSPELL_ETHEREAL_VISAGE_15;
               }break;

      }


 switch (iRange)
        {
         case 1: {iRoll = d3();
                  if (iRoll==1)iUses = IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE;
                  if (iRoll==2)iUses = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
                  if (iRoll==3)iUses = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
                  break; }
         case 2: {iRoll = d3();
                  if (iRoll==1)iUses = IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE;
                  if (iRoll==2)iUses = IP_CONST_CASTSPELL_NUMUSES_5_CHARGES_PER_USE;
                  if (iRoll==3)iUses = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
                  break; }
         case 3: {iRoll = d3();
                  if (iRoll==1)iUses = IP_CONST_CASTSPELL_NUMUSES_4_CHARGES_PER_USE;
                  if (iRoll==2)iUses = IP_CONST_CASTSPELL_NUMUSES_3_CHARGES_PER_USE;
                  if (iRoll==3)iUses = IP_CONST_CASTSPELL_NUMUSES_2_CHARGES_PER_USE;
                  iRoll=d100();
                  if (iRoll>95)iUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
                  break; }
         case 4: {iRoll = d3();
                  if (iRoll==1)iUses = IP_CONST_CASTSPELL_NUMUSES_1_CHARGE_PER_USE;
                  if (iRoll==2)iUses = IP_CONST_CASTSPELL_NUMUSES_1_USE_PER_DAY;
                  if (iRoll==3)iUses = IP_CONST_CASTSPELL_NUMUSES_2_USES_PER_DAY;
                  iRoll=d100();
                  if (iRoll>95)iUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
                  break;}
         case 5: {iRoll = d3();
                  if (iRoll==1)iUses = IP_CONST_CASTSPELL_NUMUSES_3_USES_PER_DAY;
                  if (iRoll==2)iUses = IP_CONST_CASTSPELL_NUMUSES_4_USES_PER_DAY;
                  if (iRoll==3)iUses = IP_CONST_CASTSPELL_NUMUSES_5_USES_PER_DAY;
                  iRoll=d100();
                  if (iRoll>90)iUses = IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE;
                  break;}

        }
  ipAdd = ItemPropertyCastSpell(iSpell, iUses);
  IPSafeAddItemProperty(oItem, ipAdd);
  iRoll = (d12() * iRange)+1; if (iRoll>50)iRoll=50;
  SetItemCharges(oItem, iRoll);
}


void SpellSlot(object oItem, int iRange, int iNum)
{
 itemproperty ipAdd;
 itemproperty ipClass;
 int iLvl, i;
 int iClass;
 int iSpec;
 int iRoll;
 iRoll = d8();
 switch (iRoll)
      {
       case 1: {
                iClass = IP_CONST_CLASS_BARD; iSpec = 1;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_BARD);
                } break;
       case 2: {
                iClass = IP_CONST_CLASS_DRUID;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_DRUID);
                } break;
       case 3: {
                iClass = IP_CONST_CLASS_SORCERER;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_SORCERER);
                } break;
       case 4: {
                iClass = IP_CONST_CLASS_WIZARD;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD);
                } break;
       case 5: {
                iClass = IP_CONST_CLASS_PALADIN; iSpec = 2;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_PALADIN);
                } break;
       case 6: {
                iClass = IP_CONST_CLASS_RANGER; iSpec = 2;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_RANGER);
                } break;
       case 7: {
                iClass = IP_CONST_CLASS_CLERIC;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_CLERIC);
                } break;
       case 8: {
                iClass = IP_CONST_CLASS_WIZARD;
                ipClass = ItemPropertyLimitUseByClass(IP_CONST_CLASS_WIZARD);
                } break;
      }

 for (i = 0; i < iNum; i++)
     {
      if (iSpec==1)
         {
          switch (iRange)  // Bard max lvl 6
                 {
                  case 1: iLvl = 1; break;                          // 1
                  case 2: {iLvl = d3();if(iLvl==3)iLvl=2;}break;    // 1-2
                  case 3: {iLvl = d3()+2;if(iLvl==5)iLvl=3;}break;  // 3-4
                  case 4: {iLvl = d3()+3;if(iLvl==6)iLvl=4;}break;  // 4-5
                  case 5: {iLvl = d3()+4;if(iLvl==7)iLvl=5;}break;  // 5-6
                 }
         }
      else if (iSpec==2)
         {
          switch (iRange)  // Pally & Ranger max lvl 4
                 {
                  case 1: iLvl = 1; break;                            // 1
                  case 2: {iLvl = d3();if(iLvl==3)iLvl=2;}break;      // 1-2
                  case 3: iLvl = d3(); break;                         // 1-3
                  case 4: iLvl = d3()+1; break;                       // 2-4
                  case 5: {iLvl = d3()+2;if(iLvl==5)iLvl=3;}break;    // 3-4
                 }
        }
     else
        {
         switch (iRange)  // The rest max lvl 9
                {
                 case 1: iLvl = 1; break;                         // 1
                 case 2: iLvl = d4(); break;                      // 1-4
                 case 3: iLvl = d4()+1; break;                    // 2-5
                 case 4: iLvl = d6()+2; break;                    // 3-8
                 case 5: iLvl = d6()+4; break;                    // 5-9
                }
        }
    ipAdd = ItemPropertyBonusLevelSpell(iClass, iLvl);
    AddItemProperty(DURATION_TYPE_PERMANENT, ipAdd, oItem);
   }
 IPSafeAddItemProperty(oItem, ipClass);
}

void MightyEnhance(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iEnh = d4();

 switch (iRange)
      {
       case 1: iEnh+=0; break;                       // 1-4
       case 2: iEnh+=1; break;                       // 2-5
       case 3: iEnh+=2; break;                       // 3-6
       case 4: iEnh+=3; break;                       // 4-7
       case 5: iEnh+=4; break;                       // 5-8
      }
 ipAdd = ItemPropertyMaxRangeStrengthMod(iEnh);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void BowEnhance(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iEnh = d3();

 switch (iRange)
      {
       case 1: if (iEnh==3)iEnh=1; break;            // 1-2
       case 2: {iEnh+=1;if (iEnh==4)iEnh=2;} break;  // 2-3
       case 3: {iEnh+=2;if (iEnh==5)iEnh=3;} break;  // 3-4
       case 4: {iEnh+=3;if (iEnh==6)iEnh=4;} break;  // 4-5
       case 5: {iEnh+=4;if (iEnh==7)iEnh=5;} break;  // 5-6
      }
 ipAdd = ItemPropertyAttackBonus(iEnh);
 IPSafeAddItemProperty(oItem, ipAdd);
}



void AmmoUnlim(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iType;
 int iDam;
 int iRoll = d12();
 switch (iRange)
        {
         case 1:
                {
                 iRoll = d3();
                 if (iRoll==1)iType = IP_CONST_UNLIMITEDAMMO_BASIC;
                 if (iRoll==2)iType = IP_CONST_UNLIMITEDAMMO_BASIC;
                 if (iRoll==3)iType = IP_CONST_UNLIMITEDAMMO_PLUS1;
                }break;
         case 2: {
                 iRoll = d4();
                 if (iRoll==1)iType = IP_CONST_UNLIMITEDAMMO_PLUS2;
                 if (iRoll==2)iType = IP_CONST_UNLIMITEDAMMO_PLUS2;
                 if (iRoll==3)iType = IP_CONST_UNLIMITEDAMMO_1D6COLD;
                 if (iRoll==4)iType = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
                }break;
         case 3: {
                 iRoll = d6();
                 if (iRoll==1)iType = IP_CONST_UNLIMITEDAMMO_PLUS2;
                 if (iRoll==2)iType = IP_CONST_UNLIMITEDAMMO_PLUS2;
                 if (iRoll==3)iType = IP_CONST_UNLIMITEDAMMO_PLUS3;
                 if (iRoll==4)iType = IP_CONST_UNLIMITEDAMMO_1D6FIRE;
                 if (iRoll==5)iType = IP_CONST_UNLIMITEDAMMO_1D6COLD;
                 if (iRoll==6)iType = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
                }break;
         case 4: {
                 iRoll = d6();
                 if (iRoll==1)iType = IP_CONST_UNLIMITEDAMMO_PLUS3;
                 if (iRoll==2)iType = IP_CONST_UNLIMITEDAMMO_PLUS4;
                 if (iRoll==3)iType = IP_CONST_UNLIMITEDAMMO_PLUS4;
                 if (iRoll==4)iType = IP_CONST_UNLIMITEDAMMO_1D6FIRE;
                 if (iRoll==5)iType = IP_CONST_UNLIMITEDAMMO_1D6COLD;
                 if (iRoll==6)iType = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
                }break;
         case 5: {
                 iRoll = d6();
                 if (iRoll==1)iType = IP_CONST_UNLIMITEDAMMO_PLUS4;
                 if (iRoll==2)iType = IP_CONST_UNLIMITEDAMMO_PLUS5;
                 if (iRoll==3)iType = IP_CONST_UNLIMITEDAMMO_PLUS5;
                 if (iRoll==4)iType = IP_CONST_UNLIMITEDAMMO_1D6FIRE;
                 if (iRoll==5)iType = IP_CONST_UNLIMITEDAMMO_1D6COLD;
                 if (iRoll==6)iType = IP_CONST_UNLIMITEDAMMO_1D6LIGHT;
                }break;
        }
ipAdd = ItemPropertyUnlimitedAmmo(iType);
 IPSafeAddItemProperty(oItem, ipAdd);
}



void AmmoEnhance(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iType;
 int iDam;
 int iRoll = d12();
 switch (iRoll)
        {
         case 1: iType = IP_CONST_DAMAGETYPE_ACID; break;
         case 2: iType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
         case 3: iType = IP_CONST_DAMAGETYPE_COLD; break;
         case 4: iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
         case 5: iType = IP_CONST_DAMAGETYPE_FIRE; break;
         case 6: iType = IP_CONST_DAMAGETYPE_MAGICAL; break;
         case 7: iType = IP_CONST_DAMAGETYPE_NEGATIVE; break;
         case 8: iType = IP_CONST_DAMAGETYPE_DIVINE; break;
         case 9: iType = IP_CONST_DAMAGETYPE_PIERCING; break;
         case 10: iType = IP_CONST_DAMAGETYPE_POSITIVE; break;
         case 11: iType = IP_CONST_DAMAGETYPE_SLASHING; break;
         case 12: iType = IP_CONST_DAMAGETYPE_SONIC; break;
        }
 switch (iRange)
        {
         case 1: iDam = IP_CONST_DAMAGEBONUS_1; break;
         case 2: {
                iRoll = d4();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_1;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_3;
               }break;
         case 3: {
                iRoll = d6();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_5;
               }break;
         case 4: {
                iRoll = d8();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_1d10;
               }break;
         case 5: {
                iRoll = d10();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_2d4;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==9)iDam = IP_CONST_DAMAGEBONUS_1d10;
                if (iRoll==10)iDam = IP_CONST_DAMAGEBONUS_7;
               }break;
      }
 ipAdd = ItemPropertyDamageBonus(iType, iDam);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void WeapEnhance(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iEnh = d3();

 switch (iRange)
      {
       case 1: if (iEnh==3)iEnh=1; break;            // 1-2
       case 2: {iEnh+=1;if (iEnh==4)iEnh=2;} break;  // 2-3
       case 3: {iEnh+=2;if (iEnh==5)iEnh=3;} break;  // 3-4
       case 4: {iEnh+=3;if (iEnh==6)iEnh=4;} break;  // 4-5
       case 5: {iEnh+=4;if (iEnh==7)iEnh=5;} break;  // 5-6
      }
 ipAdd = ItemPropertyEnhancementBonus(iEnh);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void RangedImbue(object oItem)
{
 itemproperty ipAdd;
 int iType;
 int iRoll = d3();

 switch (iRoll)
      {
       case 1: if (iRoll==1)iType=IP_CONST_DAMAGETYPE_BLUDGEONING; break;
       case 2: if (iRoll==2)iType=IP_CONST_DAMAGETYPE_SLASHING; break;
       case 3: if (iRoll==3)iType=IP_CONST_DAMAGETYPE_PIERCING; break;
      }
 ipAdd = ItemPropertyExtraRangeDamageType(iType);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void MeleeImbue(object oItem)
{
 itemproperty ipAdd;
 int iType;
 int iRoll = d3();

 switch (iRoll)
      {
       case 1: if (iRoll==1)iType=IP_CONST_DAMAGETYPE_BLUDGEONING; break;
       case 2: if (iRoll==2)iType=IP_CONST_DAMAGETYPE_SLASHING; break;
       case 3: if (iRoll==3)iType=IP_CONST_DAMAGETYPE_PIERCING; break;
      }
 ipAdd = ItemPropertyExtraMeleeDamageType(iType);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void MCimbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iDam;
 int iCol;
 int iType;
 int iRoll;

 switch (iRange)
      {
       case 1: {
                iRoll = d3();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_1;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
               }break;
       case 2: {
                iRoll = d4();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_1;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
               }break;
       case 3: {
                iRoll = d6();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
               }break;
       case 4: {
                iRoll = d10();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_2d4;
                if (iRoll==9)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==10)iDam = IP_CONST_DAMAGEBONUS_1d10;
               }break;
       case 5: {
                iRoll = d12();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_2d4;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==9)iDam = IP_CONST_DAMAGEBONUS_1d10;
                if (iRoll==10)iDam = IP_CONST_DAMAGEBONUS_7;
                if (iRoll==11)iDam = IP_CONST_DAMAGEBONUS_1d12;
                if (iRoll==12)iDam = IP_CONST_DAMAGEBONUS_2d6;
               }break;
      }
 ipAdd = ItemPropertyMassiveCritical(iDam);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void DAMimbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 itemproperty ipVis;
 int iDam;
 int iCol;
 int iType;
 int iRoll = d12();
 switch (iRoll)
      {
       case 1: {iType = IP_CONST_DAMAGETYPE_ACID; iCol=4;} break;
       case 2: {iType = IP_CONST_DAMAGETYPE_BLUDGEONING; iCol=1;} break;
       case 3: {iType = IP_CONST_DAMAGETYPE_COLD; iCol=2;}break;
       case 4: {iType = IP_CONST_DAMAGETYPE_ELECTRICAL; iCol=5;}break;
       case 5: {iType = IP_CONST_DAMAGETYPE_FIRE; iCol=3;}break;
       case 6: {iType = IP_CONST_DAMAGETYPE_MAGICAL; iCol=7;}break;
       case 7: {iType = IP_CONST_DAMAGETYPE_NEGATIVE; iCol=1;}break;
       case 8: {iType = IP_CONST_DAMAGETYPE_DIVINE; iCol=6;}break;
       case 9: {iType = IP_CONST_DAMAGETYPE_PIERCING; iCol=1;} break;
       case 10: {iType = IP_CONST_DAMAGETYPE_POSITIVE; iCol=6;}break;
       case 11: {iType = IP_CONST_DAMAGETYPE_SLASHING; iCol=1;} break;
       case 12: {iType = IP_CONST_DAMAGETYPE_SONIC; iCol=7;}break;
      }

 switch (iRange)
      {
       case 1: {
                iRoll = d3();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_1;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
               }break;
       case 2: {
                iRoll = d4();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_1;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
               }break;
       case 3: {
                iRoll = d6();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_2;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
               }break;
       case 4: {
                iRoll = d10();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_2d4;
                if (iRoll==9)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==10)iDam = IP_CONST_DAMAGEBONUS_1d10;
               }break;
       case 5: {
                iRoll = d12();
                if (iRoll==1)iDam = IP_CONST_DAMAGEBONUS_3;
                if (iRoll==2)iDam = IP_CONST_DAMAGEBONUS_1d4;
                if (iRoll==3)iDam = IP_CONST_DAMAGEBONUS_4;
                if (iRoll==4)iDam = IP_CONST_DAMAGEBONUS_1d6;
                if (iRoll==5)iDam = IP_CONST_DAMAGEBONUS_5;
                if (iRoll==6)iDam = IP_CONST_DAMAGEBONUS_1d8;
                if (iRoll==7)iDam = IP_CONST_DAMAGEBONUS_2d4;
                if (iRoll==8)iDam = IP_CONST_DAMAGEBONUS_6;
                if (iRoll==9)iDam = IP_CONST_DAMAGEBONUS_1d10;
                if (iRoll==10)iDam = IP_CONST_DAMAGEBONUS_7;
                if (iRoll==11)iDam = IP_CONST_DAMAGEBONUS_1d12;
                if (iRoll==12)iDam = IP_CONST_DAMAGEBONUS_2d6;
               }break;
      }
 ipAdd = ItemPropertyDamageBonus(iType, iDam);
 IPSafeAddItemProperty(oItem, ipAdd);

 //ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
 //IPSafeAddItemProperty(oItem, ipAdd);

 switch(iCol)
       {
        case 1: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL); break;
        case 2: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_COLD); break;
        case 3: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE); break;
        case 4: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_ACID); break;
        case 5: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_ELECTRICAL); break;
        case 6: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY); break;
        case 7: ipVis = ItemPropertyVisualEffect(ITEM_VISUAL_SONIC); break;
       }
 AddItemProperty(DURATION_TYPE_PERMANENT, ipVis, oItem);
}

void ACmisc(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iAC = d3();

 switch (iRange)
      {
       case 1: if (iAC==3)iAC=1; break;           // 1-2
       case 2: {iAC+=1;if (iAC==4)iAC=2;} break;  // 2-3
       case 3: {iAC+=2;if (iAC==5)iAC=3;} break;  // 3-4
       case 4: {iAC+=3;if (iAC==6)iAC=4;} break;  // 4-5
       case 5: {iAC+=4;if (iAC==7)iAC=5;} break;  // 5-6
      }
 ipAdd = ItemPropertyACBonus(iAC);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void ACimbue(object oItem, int iRange, int iSpec)
{
 itemproperty ipAdd;
 int iAC = d3();
 int iPen;
 int iRoll;
 int iAbil;
 switch (iRange)
      {
       case 1: if(iAC==3)iAC=1; break;             // 1-2
       case 2: {iAC+=1;if (iAC==4)iAC=2;} break;   // 2-3
       case 3: {iAC+=2;if (iAC==5)iAC=3;} break;   // 3-4
       case 4: {iAC+=3;if (iAC==6)iAC=4;} break;   // 4-5
       case 5: {iAC+=4;if (iAC==7)iAC=5;} break;   // 5-6
      }
 ipAdd = ItemPropertyACBonus(iAC);

 if (iSpec==1){iPen = d4()+1; ipAdd = ItemPropertyDecreaseAC(IP_CONST_ACMODIFIERTYPE_ARMOR, iPen);}
 if (iSpec==2){iPen = d4()+1; ipAdd = ItemPropertyEnhancementPenalty(iPen);}
 if (iSpec==3)
    {
     iPen = d4()+1;
     iRoll = d6();
     switch(iRoll)
           {
            case 1: iAbil = ABILITY_DEXTERITY; break;
            case 2: iAbil = ABILITY_INTELLIGENCE; break;
            case 3: iAbil = ABILITY_WISDOM; break;
            case 4: iAbil = ABILITY_CHARISMA; break;
            case 5: iAbil = ABILITY_CONSTITUTION; break;
            case 6: iAbil = ABILITY_STRENGTH; break;
           }
     ipAdd = ItemPropertyDecreaseAbility(iAbil, iPen);
    }
 if (iSpec==4){iPen = d4()+1; ipAdd = ItemPropertyAttackPenalty(iPen);}

 IPSafeAddItemProperty(oItem, ipAdd);
}

void MIMMimbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iType;
 int iRoll;
 switch (iRange)
      {
       case 1: {}; break;
       case 2: {
                iRoll = d3();
                if (iRoll==1)iType = IP_CONST_IMMUNITYMISC_POISON;
                if (iRoll==2)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==3)iType = IP_CONST_IMMUNITYMISC_DISEASE;
               }; break;
       case 3: {
                iRoll = d6();
                if (iRoll==1)iType = IP_CONST_IMMUNITYMISC_POISON;
                if (iRoll==2)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==3)iType = IP_CONST_IMMUNITYMISC_FEAR;
                if (iRoll==4)iType = IP_CONST_IMMUNITYMISC_PARALYSIS;
                if (iRoll==5)iType = IP_CONST_IMMUNITYMISC_DEATH_MAGIC;
                if (iRoll==6)iType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
               }; break;
       case 4: {
                iRoll = d10();
                if (iRoll==1)iType = IP_CONST_IMMUNITYMISC_POISON;
                if (iRoll==2)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==3)iType = IP_CONST_IMMUNITYMISC_FEAR;
                if (iRoll==4)iType = IP_CONST_IMMUNITYMISC_PARALYSIS;
                if (iRoll==5)iType = IP_CONST_IMMUNITYMISC_DEATH_MAGIC;
                if (iRoll==6)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==7)iType = IP_CONST_IMMUNITYMISC_KNOCKDOWN;
                if (iRoll==8)iType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
                if (iRoll==9)iType = IP_CONST_IMMUNITYMISC_BACKSTAB;
                if (iRoll==10)iType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
               }; break;
       case 5: {
                iRoll = d12();
                if (iRoll==1)iType = IP_CONST_IMMUNITYMISC_POISON;
                if (iRoll==2)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==3)iType = IP_CONST_IMMUNITYMISC_FEAR;
                if (iRoll==4)iType = IP_CONST_IMMUNITYMISC_PARALYSIS;
                if (iRoll==5)iType = IP_CONST_IMMUNITYMISC_DEATH_MAGIC;
                if (iRoll==6)iType = IP_CONST_IMMUNITYMISC_DISEASE;
                if (iRoll==7)iType = IP_CONST_IMMUNITYMISC_KNOCKDOWN;
                if (iRoll==8)iType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
                if (iRoll==9)iType = IP_CONST_IMMUNITYMISC_BACKSTAB;
                if (iRoll==10)iType = IP_CONST_IMMUNITYMISC_LEVEL_ABIL_DRAIN;
                if (iRoll==11)iType = IP_CONST_IMMUNITYMISC_MINDSPELLS;
                if (iRoll==12)iType = IP_CONST_IMMUNITYMISC_CRITICAL_HITS;
               }; break;
      }
 ipAdd = ItemPropertyImmunityMisc(iType);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void RESimbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iRes;
 int iType;
 int iRoll = Random(13)+1;
 switch (iRoll)
      {
       case 1: iType = IP_CONST_DAMAGETYPE_ACID; break;
       case 2: iType = IP_CONST_DAMAGETYPE_BLUDGEONING; break;
       case 3: iType = IP_CONST_DAMAGETYPE_COLD; break;
       case 4: iType = IP_CONST_DAMAGETYPE_DIVINE; break;
       case 5: iType = IP_CONST_DAMAGETYPE_ELECTRICAL; break;
       case 6: iType = IP_CONST_DAMAGETYPE_FIRE; break;
       case 7: iType = IP_CONST_DAMAGETYPE_MAGICAL; break;
       case 8: iType = IP_CONST_DAMAGETYPE_NEGATIVE; break;
       case 9: iType = IP_CONST_DAMAGETYPE_PHYSICAL; break;
       case 10: iType = IP_CONST_DAMAGETYPE_PIERCING; break;
       case 11: iType = IP_CONST_DAMAGETYPE_POSITIVE; break;
       case 12: iType = IP_CONST_DAMAGETYPE_SLASHING; break;
       case 13: iType = IP_CONST_DAMAGETYPE_SONIC; break;
      }

 switch (iRange)
      {
       case 1:  iRes = IP_CONST_DAMAGERESIST_5; break;
       case 2: {iRoll=d4();
                if (iRoll==1)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==2)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==3)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==4)iRes = IP_CONST_DAMAGERESIST_10;
                }break;
       case 3: {iRoll=d3();
                if (iRoll==1)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==2)iRes = IP_CONST_DAMAGERESIST_10;
                if (iRoll==3)iRes = IP_CONST_DAMAGERESIST_5;
                }break;
       case 4: {iRoll=d4();
                if (iRoll==1)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==2)iRes = IP_CONST_DAMAGERESIST_10;
                if (iRoll==3)iRes = IP_CONST_DAMAGERESIST_15;
                if (iRoll==4)iRes = IP_CONST_DAMAGERESIST_10;
                }break;
       case 5: {iRoll=d3();
                if (iRoll==1)iRes = IP_CONST_DAMAGERESIST_5;
                if (iRoll==2)iRes = IP_CONST_DAMAGERESIST_10;
                if (iRoll==3)iRes = IP_CONST_DAMAGERESIST_15;
               }break;
      }
 ipAdd = ItemPropertyDamageResistance(iType, iRes);
 IPSafeAddItemProperty(oItem, ipAdd);
}


void AbilityImbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iAbil;
 int iType;
 int iRoll = d6();
 switch (iRoll)
      {
       case 1: iType = ABILITY_DEXTERITY; break;
       case 2: iType = ABILITY_INTELLIGENCE; break;
       case 3: iType = ABILITY_WISDOM; break;
       case 4: iType = ABILITY_CHARISMA; break;
       case 5: iType = ABILITY_CONSTITUTION; break;
       case 6: iType = ABILITY_STRENGTH; break;
      }

  switch (iRange)
      {
       case 1: {iAbil = d3();  if (iAbil==3)iAbil=1; break;}  // 1-2
       case 2: {iAbil = d3()+1;if (iAbil==4)iAbil=2; break;}  // 2-3
       case 3: {iAbil = d3()+2;if (iAbil==5)iAbil=3; break;}  // 3-4
       case 4: {iAbil = d3()+3;if (iAbil==6)iAbil=4; break;}  // 4-5
       case 5: {iAbil = d3()+4;if (iAbil==7)iAbil=5; break;}  // 5-6
      }
 ipAdd = ItemPropertyAbilityBonus(iType, iAbil);
 IPSafeAddItemProperty(oItem, ipAdd);
}

void MiscImbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iRoll;
 switch (iRange)
      {
       case 1: {}; break;
       case 2: {
                iRoll = d3();
                if (iRoll==1)ipAdd = ItemPropertyDarkvision();
                if (iRoll==2)ipAdd = ItemPropertyImprovedEvasion();
                if (iRoll==3)ipAdd = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 2);
               }; break;
       case 3: {
                iRoll = d6();
                if (iRoll==1)ipAdd = ItemPropertyDarkvision();
                if (iRoll==2)ipAdd = ItemPropertyImprovedEvasion();
                if (iRoll==3)ipAdd = ItemPropertyVampiricRegeneration(1);
                if (iRoll==4)ipAdd = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 3);
                if (iRoll==5)ipAdd = ItemPropertyRegeneration(1);
                if (iRoll==6)ipAdd = ItemPropertyDarkvision();
               }; break;
       case 4: {
                iRoll = d6();
                if (iRoll==1)ipAdd = ItemPropertyDarkvision();
                if (iRoll==2)ipAdd = ItemPropertyImprovedEvasion();
                if (iRoll==3)ipAdd = ItemPropertyVampiricRegeneration(2);
                if (iRoll==4)ipAdd = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 4);
                if (iRoll==5)ipAdd = ItemPropertyRegeneration(2);
                if (iRoll==6)ipAdd = ItemPropertyTrueSeeing();
                }; break;
       case 5: {
                iRoll = d6();
                if (iRoll==1)ipAdd = ItemPropertyDarkvision();
                if (iRoll==2)ipAdd = ItemPropertyImprovedEvasion();
                if (iRoll==3)ipAdd = ItemPropertyVampiricRegeneration(4);
                if (iRoll==4)ipAdd = ItemPropertyBonusSavingThrow(IP_CONST_SAVEBASETYPE_FORTITUDE, 5);
                if (iRoll==5)ipAdd = ItemPropertyRegeneration(4);
                if (iRoll==6)ipAdd = ItemPropertyTrueSeeing();
                }; break;
      }
 IPSafeAddItemProperty(oItem, ipAdd);
}

void SaveImbue(object oItem, int iRange)
{
 itemproperty ipAdd;
 int iAbil;
 int iType;
 int iRoll = d6();
 switch (iRoll)
      {
       case 1: iType = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
       case 2: iType = IP_CONST_SAVEBASETYPE_REFLEX; break;
       case 3: iType = IP_CONST_SAVEBASETYPE_WILL; break;
       case 4: iType = IP_CONST_SAVEBASETYPE_FORTITUDE; break;
       case 5: iType = IP_CONST_SAVEBASETYPE_REFLEX; break;
       case 6: iType = IP_CONST_SAVEBASETYPE_WILL; break;
      }



 switch (iRange)
      {
       case 1: {iAbil = d3();  if (iAbil==3)iAbil=1; break;}  // 1-2
       case 2: {iAbil = d3()+1;if (iAbil==4)iAbil=2; break;}  // 2-3
       case 3: {iAbil = d3()+2;if (iAbil==5)iAbil=3; break;}  // 3-4
       case 4: {iAbil = d3()+3;if (iAbil==6)iAbil=4; break;}  // 4-5
       case 5: {iAbil = d3()+4;if (iAbil==7)iAbil=5; break;}  // 5-6
      }
 ipAdd = ItemPropertyBonusSavingThrow(iType, iAbil);
 IPSafeAddItemProperty(oItem, ipAdd);
}
void ImpEvasionImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyImprovedEvasion();
IPSafeAddItemProperty(oItem, ipAdd);
}

void TruseeingImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyTrueSeeing();
IPSafeAddItemProperty(oItem, ipAdd);
}
void DarkvisionImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyDarkvision();
IPSafeAddItemProperty(oItem, ipAdd);
}

void FreedomImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyFreeAction();
IPSafeAddItemProperty(oItem, ipAdd);
}

void RegenImbue(object oItem, int iRange)
{
int iRegen;
itemproperty ipAdd;
switch (iRange)
      {
       case 1: {iRegen = d3();if (iRegen==3)iRegen=1; break;}   //1-2
       case 2: iRegen = d3(); break;                            //1-3
       case 3: iRegen = d3()+1; break;                          //1-4
       case 4: {iRegen = d3()+2;if (iRegen==5)iRegen=3;break;}  //2-4
       case 5: iRegen = d4()+1;break;                           //2-5
      }
ipAdd = ItemPropertyRegeneration(iRegen);
IPSafeAddItemProperty(oItem, ipAdd);
}

void VRimbue(object oItem, int iRange)
{
int iRegen;
itemproperty ipAdd;
switch (iRange)
      {
       case 1: {iRegen = d3();if (iRegen==3)iRegen=1; break;}   //1-2
       case 2: iRegen = d3(); break;                            //1-3
       case 3: iRegen = d3()+1; break;                          //1-4
       case 4: {iRegen = d3()+2;if (iRegen==5)iRegen=3;break;}  //2-4
       case 5: iRegen = d4()+1;break;                           //2-5
      }
ipAdd = ItemPropertyVampiricRegeneration(iRegen);
IPSafeAddItemProperty(oItem, ipAdd);
}

void EvilImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_EVIL);
IPSafeAddItemProperty(oItem, ipAdd);
}

void HolyImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_HOLY);
IPSafeAddItemProperty(oItem, ipAdd);
}

void FireImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_FIRE);
IPSafeAddItemProperty(oItem, ipAdd);
}

void ElecImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_ELECTRICAL);
IPSafeAddItemProperty(oItem, ipAdd);
}

void AcidImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyVisualEffect(ITEM_VISUAL_ACID);
IPSafeAddItemProperty(oItem, ipAdd);
}

void HasteImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyHaste();
IPSafeAddItemProperty(oItem, ipAdd);
}

void KeenImbue(object oItem)
{
itemproperty ipAdd;
ipAdd = ItemPropertyKeen();
IPSafeAddItemProperty(oItem, ipAdd);
}

void DropArmor (object oMob, object oSack, int iRange, int SockChance, int iChest)
{
 object oItem;
 itemproperty ipAdd;
 string sType, sIName, sName, sSocks;
 int iQual = 0;
 int iRoll = d10();
 switch(iRoll)
       {
        case 1: sType = "sdarmor8"; sIName = "Plate";break;
        case 2: sType = "sdarmor7"; sIName = "Half Plate";break;
        case 3: sType = "sdarmor6"; sIName = "Chain Mail";break;
        case 4: sType = "sdarmor5"; sIName = "Banded Mail";break;
        case 5: sType = "sdarmor4"; sIName = "Breastplate";break;
        case 6: sType = "sdarmor3"; sIName = "Studded Leather";break;
        case 7: sType = "sdarmor2"; sIName = "Hardened Leather";break;
        case 8: sType = "sdarmor1"; sIName = "Leather";break;
        case 9: sType = "sdarmor0"; sIName = "Tunic";break;
        case 10: sType = "sdarmor02"; sIName = "Robe";break;
       }

 oItem = CreateItemOnObject(sType, oSack, 1, "sf_socket_item");

// chance for socketed item

iRoll = d100();
if (iRoll<SockChance)
   {
    iRoll=d6();
    SetLocalInt(oItem, "SOCKETS", iRoll);
    sSocks = IntToString(iRoll);
    ipAdd = ItemPropertyCastSpell
               (IP_CONST_CASTSPELL_UNIQUE_POWER,
                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    IPSafeAddItemProperty(oItem, ipAdd);


    sName = ColorString("Socketed "+sIName+" ("+sSocks+")", 72, 209, 204 );
    SetName(oItem, sName);
    return;
   }


iRoll = d100();
if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

SetIdentified(oItem, FALSE);
//////////////////////////////////////////// Lvls 1-5

 // Ac bonus


 DelayCommand(0.2, ACimbue(oItem, iRange, 0));
 ++iQual;

 ////////////////////////////////////////// Lvls 6-10

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2,MiscImbue(oItem, iRange));
         ++iQual;
        }
    }

////////////////////////////////////////// Lvls 11-20

 if (iRange==3)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }

     // Misc
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }

     // Misc Immunity
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, MIMMimbue(oItem, iRange));
         ++iQual;
        }
    // Haste

     iRoll = d100();
     if (iRoll>95){DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;}
    }


////////////////////////////////////////// Lvls 20-30

 if (iRange==4)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }

     // Misc Immunity
     iRoll = d100();
     if (iRoll>65)
        {
         DelayCommand(0.2, MIMMimbue(oItem, iRange));
         ++iQual;
        }
    // Haste

     iRoll = d100();
     if (iRoll>80){DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;}
    }

////////////////////////////////////////// Lvls 30-40

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus x 3
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>55)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }

     // Misc Immunity
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MIMMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste

     iRoll = d100();
     if (iRoll>70){DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;}
    }

  switch(iQual)
       {
        case 1: sName = ColorString("Superior "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Mythical "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Titan's "+sIName, 255, 0, 255 ); break;
       }
  SetName(oItem, sName);
 }
void DropShield (object oMob, object oSack, int iRange, int SockChance, int iChest)
{
 object oItem;
 itemproperty ipAdd;
 string sType, sName, sIName, sSocks;
 int iQual = 0;
 int iRoll = d12();
 switch(iRoll)
       {
        case 1: {sType = "sdTower1"; sIName = "Targe";} break;
        case 2: {sType = "sdLarge1"; sIName = "Wooden Shield";} break;
        case 3: {sType = "sdSmall1"; sIName = "Buckler";} break;
        case 4: {sType = "sdTower2"; sIName = "Deflektor";} break;
        case 5: {sType = "sdLarge2"; sIName = "Protector";} break;
        case 6: {sType = "sdSmall2"; sIName = "Heater";} break;
        case 7: {sType = "sdTower3"; sIName = "Defender";} break;
        case 8: {sType = "sdLarge3"; sIName = "Reinforced Shield";} break;
        case 9: {sType = "sdSmall3"; sIName = "Arm Blocker";} break;
        case 10: {sType = "sdTower4"; sIName = "Centurion";} break;
        case 11: {sType = "sdLarge4"; sIName = "Iron Shield";} break;
        case 12: {sType = "sdSmall4"; sIName = "Buckler";} break;
       }

  oItem = CreateItemOnObject(sType, oSack, 1, "sf_socket_item");

// chance for socketed item

iRoll = d100();
if (iRoll<SockChance)
   {
    iRoll=d6();
    SetLocalInt(oItem, "SOCKETS", iRoll);
    sSocks = IntToString(iRoll);
    ipAdd = ItemPropertyCastSpell
               (IP_CONST_CASTSPELL_UNIQUE_POWER,
                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    IPSafeAddItemProperty(oItem, ipAdd);


    sName = ColorString("Socketed "+sIName+" ("+sSocks+")", 72, 209, 204 );
    SetName(oItem, sName);
    return;
   }

iRoll = d100();
if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

 SetIdentified(oItem, FALSE);

//////////////////////////////////////////// Lvls 1-5

 // Ac bonus


 DelayCommand(0.2, ACmisc(oItem, iRange));
 ++iQual;

 ////////////////////////////////////////// Lvls 6-10

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
    }

////////////////////////////////////////// Lvls 11-20

 if (iRange==3)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }

     // Save
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 20-30

 if (iRange==4)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }

     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 30-40

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }

    }

  switch(iQual)
       {
        case 1: sName = ColorString("Superior "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Mythical "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Titan's "+sIName, 255, 0, 255 ); break;
       }
  SetName(oItem, sName);
}

void DropMagicItem (object oMob, object oSack, int iRange, int SockChance, int iChest)
{
 string sType, sName, sIName, sSocks;
 object oItem;
 itemproperty ipAdd;
 int iID = 0;
 int iQual = 0;
 int iRoll = d20();
 switch(iRoll)
       {
        case 1: {sType = "sdammy1"; sIName = "Amulet";iID = 1;} break;
        case 2: {sType = "sdring1"; sIName = "Ring";iID = 2;} break;
        case 3: {sType = "sdboots1"; sIName = "Boots";iID = 1;}break;
        case 4: {sType = "sdbracers1";sIName = "Wristband";} break;
        case 5: {sType = "sdhelm1";sIName = "Helm";} break;
        case 6: {sType = "sdcloak1";sIName = "Cloak";iID = 1;} break;
        case 7: {sType = "sdbelt1";sIName = "Belt";} break;
        case 8: {sType = "sdammy2";sIName = "Talisman";iID = 1;} break;
        case 9: {sType = "sdring2";sIName = "Band";iID = 2;} break;
        case 10: {sType = "sdboots2";sIName = "Sabatons";iID = 1;} break;
        case 11: {sType = "sdbracers2";sIName = "Bracers";} break;
        case 12: {sType = "sdhelm2";sIName = "Salet";} break;
        case 13: {sType = "sdcloak2";sIName = "Cape";iID = 1;} break;
        case 14: {sType = "sdbelt2";sIName = "Thick Belt";} break;
        case 15: {sType = "sdammy3";sIName = "Charm";iID = 1;} break;
        case 16: {sType = "sdring3";sIName = "Circle";iID = 2;} break;
        case 17: {sType = "sdboots3";sIName = "Greaves";iID = 1;} break;
        case 18: {sType = "sdbracers3";sIName = "Armband";} break;
        case 19: {sType = "sdhelm3";sIName = "Vanguard";} break;
        case 20: {sType = "sdring4";sIName = "Coil";iID = 2;} break;
       }


  // chance for socketed item

oItem = CreateItemOnObject(sType, oSack, 1, "sf_socket_item");

iRoll = d100();
if (iRoll<SockChance)
   {
    iRoll=d6();
    SetLocalInt(oItem, "SOCKETS", iRoll);
    sSocks = IntToString(iRoll);
    ipAdd = ItemPropertyCastSpell
               (IP_CONST_CASTSPELL_UNIQUE_POWER,
                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    IPSafeAddItemProperty(oItem, ipAdd);


    sName = ColorString("Socketed "+sIName+" ("+sSocks+")", 72, 209, 204 );
    SetName(oItem, sName);
    return;
   }


 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

SetIdentified(oItem, FALSE);

///////////////////////////////////////////// Hench Reward Code

object oPC = GetFirstPC();

if (GetMaster(oMob)!=OBJECT_INVALID)
   {
    SetIdentified(oItem, TRUE);
    SetItemCursedFlag(oItem, TRUE);
   }

//////////////////////////////////////////// Lvls 1-5

 // AC bonus for ammy, cloak & boots or ability bonus otherwise
 if (iID==1)
    {
     DelayCommand(0.2, ACmisc(oItem, iRange));
     ++iQual;
    }
 else
    {
     DelayCommand(0.2, AbilityImbue(oItem, iRange));
     ++iQual;
    }

 ////////////////////////////////////////// Lvls 6-10

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }

     // If its a ring theres a 30% chance for spellslots - otherwise a save thr
     if (iID==2)
        {
         // Spell Slot
         iRoll = d100();
         if (iRoll>69)
            {
             iRoll=d3();   // 1-3 slots
             DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
             iQual+=2;
            }
         }
     else
         {
          // Save
          iRoll = d100();
          if (iRoll>90)
             {
              DelayCommand(0.2, SaveImbue(oItem, iRange));
              ++iQual;
             }
          }

    }

////////////////////////////////////////// Lvls 11-20

 if (iRange==3)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // If its a ring theres a chance for spellslots - otherwise a save thr
     if (iID==2)
        {
         // Spell Slot
         iRoll = d100();
         if (iRoll>69)
            {
             iRoll=d3()+1;  // 2-4 slots
             DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
             iQual+=2;
            }
         }
     else
         {
          // Misc Immunity
          iRoll = d100();
          if (iRoll>70)
             {
              DelayCommand(0.2, MIMMimbue(oItem, iRange));
              ++iQual;
             }
         }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 20-30

 if (iRange==4)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     if (iID==2)
        {
         // Spell Slot
         iRoll = d100();
         if (iRoll>69)
            {
             iRoll=d4()+2;  // 3-6 slots
             DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
             iQual+=2;
            }
         }
     else
        {
         // Misc Immunity
         iRoll = d100();
         if (iRoll>70)
            {
             DelayCommand(0.2, MIMMimbue(oItem, iRange));
             ++iQual;
            }
        }
     // Misc
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }

     // Damage Res bonus
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }

     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 30-40

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Res bonus x 2
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>65)
        {
         DelayCommand(0.2, RESimbue(oItem, iRange));
         ++iQual;
        }
     // Misc
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, MiscImbue(oItem, iRange));
         ++iQual;
        }
     // Misc Immunity
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MIMMimbue(oItem, iRange));
         iQual+=2;
        }
     // Save
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     if (iID==2)
        {
         // Spell Slot
         iRoll = d100();
         if (iRoll>69)
            {
             iRoll = d6()+2; // 2-8 slots
             DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
             ++iQual;
            }
         }

    }

  switch(iQual)
       {
        case 1: sName = ColorString("Magical "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Mythical "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Titan's "+sIName, 255, 0, 255 ); break;
       }
  SetName(oItem, sName);
}


void DropMonkGloves (object oMob, object oSack, int iRange, int SockChance, int iChest)
{
 object oItem;
 itemproperty ipAdd;
 string sType, sName, sIName, sSocks;
 int iDice1, iDice2, iRoll;
 int iQual;
 int iWType = 0;

 iRoll = d6();
 switch (iRoll)
        {
         case 1: sType = "sd_mgloves"; break;
         case 2: sType = "sd_mgloves1"; break;
         case 3: sType = "sd_mgloves2"; break;
         case 4: sType = "sd_mgloves3"; break;
         case 5: sType = "sd_mgloves4"; break;
         case 6: sType = "sd_mgloves5"; break;
        }

 iRoll = d20();
 switch (iRoll)
        {
         case 1: sIName = "War Talons"; break;
         case 2: sIName = "Blood Claws"; break;
         case 3: sIName = "Pulverizers"; ;break;
         case 4: sIName = "Ninja Claws"; break;
         case 5: sIName = "War Gloves"; break;
         case 6: sIName = "Flesh Knuckles"; break;
         case 7: sIName = "Death Mitts"; break;
         case 8: sIName = "Palm Guards"; break;
         case 9: sIName = "Knuckledusters"; ;break;
         case 10: sIName = "Tiger Fists"; break;
         case 11: sIName = "Tauntlets"; break;
         case 12: sIName = "Chi Bracelets"; break;
         case 13: sIName = "Dragon Claws"; break;
         case 14: sIName = "Steel Palms"; break;
         case 15: sIName = "Exploding Fists"; break;
         case 16: sIName = "Nose Breakers"; break;
         case 17: sIName = "Stiff Fingers"; ;break;
         case 18: sIName = "Heart Piercers"; break;
         case 19: sIName = "Digit Devastators"; break;
         case 20: sIName = "Gore Gauntlets"; break;
        }

oItem = CreateItemOnObject(sType, oSack, 1, "sf_socket_item");

// Monk
 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

 SetIdentified(oItem, FALSE);

//////////////////////////////////////////// Lvls 1-5      ::Monk2::

 // Attack bonus

     DelayCommand(0.2, BowEnhance(oItem, iRange));
     ++iQual;

 ////////////////////////////////////////// Lvls 6-10      ::Monk2::

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll==90)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
    }

////////////////////////////////////////// Lvls 11-20     ::Monk2::

 if (iRange==3)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=85)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Monk2::

 if (iRange==4)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 3
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=80)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
   }

////////////////////////////////////////// Lvls 30-40     ::Monk2::

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>20)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 3
     iRoll = d100();
     if (iRoll>20)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=70)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
    }
 switch(iQual)
       {
        case 1: sName = ColorString("Superior "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Shaolin "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Shaolin "+sIName, 255, 255, 0 ); break;
       }
  SetName(oItem, sName);
  SetIdentified(oItem, FALSE);
}


void DropWeapon (object oMob, object oSack, int iRange, int SockChance, int iChest)
{
 object oItem;
 itemproperty ipAdd;
 string sType, sName, sIName, sSocks;
 int iRoll;
 int iQual = 0;
 int iWType = 0;

 iRoll = d20(2);
 switch(iRoll)
       {
// Axes

        case 0: {sType = "sdgaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Greataxe";
                 if (iRoll==2)sIName = "Two Handed Axe";
                 if (iRoll==3)sIName = "Decapitator";}
        case 1: {sType = "sdgaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Greataxe";
                 if (iRoll==2)sIName = "Two Handed Axe";
                 if (iRoll==3)sIName = "Decapitator";}
        case 2: {sType = "sdgaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Greataxe";
                 if (iRoll==2)sIName = "Two Handed Axe";
                 if (iRoll==3)sIName = "Decapitator";}
                 break;         break;
        case 3: {sType = "sdwaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Dwarven War Axe";
                 if (iRoll==2)sIName = "War Axe";
                 if (iRoll==3)sIName = "Headsplitter";}
                 break;
        case 4: {sType = "sdbaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Battleaxe";
                 if (iRoll==2)sIName = "Beserker Axe";
                 if (iRoll==3)sIName = "Siege Axe";}
                 break;
        case 5: {sType = "sdhaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Handaxe";
                 if (iRoll==2)sIName = "Cleaver";
                 if (iRoll==3)sIName = "Tomohawk";}
                 break;

// Bladed

        case 6: {sType = "sd_bastard"; iRoll = d3();
                 if (iRoll==1)sIName = "Bastard Sword";
                 if (iRoll==2)sIName = "Mercinary Blade";
                 if (iRoll==3)sIName = "Black Blade";}
                 break;
        case 7: {sType = "sdlsword"; iRoll = d3();
                 if (iRoll==1)sIName = "Longsword";
                 if (iRoll==2)sIName = "Knight's Sword";
                 if (iRoll==3)sIName = "Honor Blade";}
                 break;
        case 8: {sType = "sdlsword"; iRoll = d3();
                 if (iRoll==1)sIName = "Longsword";
                 if (iRoll==2)sIName = "Knight's Sword";
                 if (iRoll==3)sIName = "Honor Blade";}
                 break;
        case 9: {sType = "sdssword"; iRoll = d3();
                 if (iRoll==1)sIName = "Short Sword";
                 if (iRoll==2)sIName = "Half Blade";
                 if (iRoll==3)sIName = "Halfling Sword";}
                 break;
        case 10: {sType = "sdgsword"; iRoll = d3();
                 if (iRoll==1)sIName = "Greatsword";
                 if (iRoll==2)sIName = "Massive Blade";
                 if (iRoll==3)sIName = "Champion's Steel";}
                 break;
        case 11: {sType = "sdkatana"; iRoll = d3();
                 if (iRoll==1)sIName = "Katana";
                 if (iRoll==2)sIName = "Samurai Sword";
                 if (iRoll==3)sIName = "Assassin Blade";}
                 break;
        case 12: {sType = "sdscim"; iRoll = d3();
                 if (iRoll==1)sIName = "Scimitar";
                 if (iRoll==2)sIName = "Arabian Sword";
                 if (iRoll==3)sIName = "Sand Blade";}
                 break;
        case 13: {sType = "sdrapier"; iRoll = d3();
                 if (iRoll==1)sIName = "Rapier";
                 if (iRoll==2)sIName = "Swashbuckler";
                 if (iRoll==3)sIName = "Death Pin";}
                 break;
        case 14: {sType = "sddagger"; iRoll = d3();
                 if (iRoll==1)sIName = "Dagger";
                 if (iRoll==2)sIName = "Sticker";
                 if (iRoll==3)sIName = "Switchblade";}
                 break;

// Exotic

        case 15: {sType = "sdstaff3"; iRoll = d3();
                 iWType = 2;
                 if (iRoll==1)sIName = "Warlock Bone";
                 if (iRoll==2)sIName = "Shaman Totem";
                 if (iRoll==3)sIName = "Cane of Scorcery";}
                 break;
        case 16: {sType = "sdkama"; iRoll = d3();
                 if (iRoll==1)sIName = "Kama";
                 if (iRoll==2)sIName = "Monk Claw";
                 if (iRoll==3)sIName = "Ripper";}
                 break;
        case 17: {sType = "sdkukri"; iRoll = d3();
                 if (iRoll==1)sIName = "Kukri";
                 if (iRoll==2)sIName = "Machetti";
                 if (iRoll==3)sIName = "Scorpion Tail";}
                 break;
        case 18: {sType = "sdlbow"; iRoll = d3();
                 iWType = 1;
                 if (iRoll==1)sIName = "Siege Bow";
                 if (iRoll==2)sIName = "Elven War Bow";
                 if (iRoll==3)sIName = "Battle Bow";}
                 break;


// Blunt

        case 19: {sType = "sdclub"; iRoll = d3();
                 if (iRoll==1)sIName = "Club";
                 if (iRoll==2)sIName = "Baton";
                 if (iRoll==3)sIName = "Truncheon";}
                 break;
        case 20: {sType = "sdhflail"; iRoll = d3();
                 if (iRoll==1)sIName = "Heavy Flail";
                 if (iRoll==2)sIName = "Deathswinger";
                 if (iRoll==3)sIName = "Skull Masher";}
                 break;
        case 21: {sType = "sdlflail"; iRoll = d3();
                 if (iRoll==1)sIName = "Flail";
                 if (iRoll==2)sIName = "Light Flail";
                 if (iRoll==3)sIName = "Head Cracker";}
                 break;
        case 22: {sType = "sdstaff1"; iRoll = d3();
                 iWType = 2;
                 if (iRoll==1)sIName = "Magestaff";
                 if (iRoll==2)sIName = "Arcane Staff";
                 if (iRoll==3)sIName = "Magus Pole";}
                 break;

        case 23: {sType = "sdwhamm"; iRoll = d3();
                 if (iRoll==1)sIName = "Warhammer";
                 if (iRoll==2)sIName = "Thunderhead";
                 if (iRoll==3)sIName = "Earthshaker";}
                 break;
        case 24: {sType = "sdmace"; iRoll = d3();
                 if (iRoll==1)sIName = "Mace";
                 if (iRoll==2)sIName = "Wrathpole";
                 if (iRoll==3)sIName = "Justice Bringer";}
                 break;
        case 25: {sType = "sdmstar"; iRoll = d3();
                 if (iRoll==1)sIName = "Morning Star";
                 if (iRoll==2)sIName = "Neck Crusher";
                 if (iRoll==3)sIName = "Bloodcopter";}
                 break;

//Double Sided

        case 26: {sType = "sddbsword"; iRoll = d3();
                 if (iRoll==1)sIName = "Doubleblade";
                 if (iRoll==2)sIName = "Doomblade";
                 if (iRoll==3)sIName = "Body Processor";}
                 break;
        case 27: {sType = "sddsmace"; iRoll = d3();
                 if (iRoll==1)sIName = "Double Mace";
                 if (iRoll==2)sIName = "Damage Pole";
                 if (iRoll==3)sIName = "Twin Basher";}
                 break;
        case 28: {sType = "sddsaxe"; iRoll = d3();
                 if (iRoll==1)sIName = "Double Axe";
                 if (iRoll==2)sIName = "Crowd Cutter";
                 if (iRoll==3)sIName = "Haymaker";}
                 break;
        case 29: {sType = "sdqstaff"; iRoll = d3();
                 if (iRoll==1)sIName = "Quaterstaff";
                 if (iRoll==2)sIName = "Pole";
                 if (iRoll==3)sIName = "Oak Rod";}
                 break;

// Polearms

        case 30: {sType = "sdhalberd"; iRoll = d3();
                 if (iRoll==1)sIName = "Halberd";
                 if (iRoll==2)sIName = "Death Reach";
                 if (iRoll==3)sIName = "Wind Cutter";}
                 break;
        case 31: {sType = "sdscythe"; iRoll = d3();
                 if (iRoll==1)sIName = "Reaper";
                 if (iRoll==2)sIName = "Soul Reaver";
                 if (iRoll==3)sIName = "Flesh Harvester";}
                 break;
        case 32: {sType = "sdspear"; iRoll = d3();
                 if (iRoll==1)sIName = "Spear";
                 if (iRoll==2)sIName = "Amazon Finger";
                 if (iRoll==3)sIName = "Body Skewer";}
                 break;

// Whip

      case 33: {sType = "sdwhip"; iRoll = d3();
                 if (iRoll==1)sIName = "Whip";
                 if (iRoll==2)sIName = "Bullwhip";
                 if (iRoll==3)sIName = "Deathrope";}
                 break;

// Ranged


        case 34: {sType = "sdsbow"; iRoll = d3();
                 iWType = 1;
                 if (iRoll==1)sIName = "Halfling War Bow";
                 if (iRoll==2)sIName = "Shortbow";
                 if (iRoll==3)sIName = "Bloodstring";}
                 break;
        case 35: {sType = "sdlcbow"; iRoll = d3();
                 iWType = 1;
                 if (iRoll==1)sIName = "Light Crossbow";
                 if (iRoll==2)sIName = "Bolt Pistol";
                 if (iRoll==3)sIName = "Auto Bow";}
                 break;
        case 36: {sType = "sdhcbow"; iRoll = d3();
                 iWType = 1;
                 if (iRoll==1)sIName = "Battle Crossbow";
                 if (iRoll==2)sIName = "Bolt Rifle";
                 if (iRoll==3)sIName = "Steelstring Sniper";}
                 break;
 // Mage


        case 37: {sType = "sdlhamm"; iRoll = d3();
                 if (iRoll==1)sIName = "Light Hammer";
                 if (iRoll==2)sIName = "Wood Hammer";
                 if (iRoll==3)sIName = "Hole Puncher";}
                 break;
        case 38: {sType = "sdstaff2"; iRoll = d3();
                 iWType = 2;
                 if (iRoll==1)sIName = "Mystic Cane";
                 if (iRoll==2)sIName = "Staff of Conjuring";
                 if (iRoll==3)sIName = "Ivory Staff";}
                 break;
        case 39: {sType = "sdsickle"; iRoll = d3();
                 if (iRoll==1)sIName = "Sickle";
                 if (iRoll==2)sIName = "Blood Crest";
                 if (iRoll==3)sIName = "Death Ring";}
                 break;
        case 40: {sType = "sdmgloves"; iRoll = d3();
                  iWType = 3;
                 if (iRoll==1)sIName = "Death Claws";
                 if (iRoll==2)sIName = "Exploding Fists";
                 if (iRoll==3)sIName = "Battle Gloves";}
                 break;

      }

 // chance for socketed item

oItem = CreateItemOnObject(sType, oSack, 1, "sf_socket_item");

SetName(oItem, sIName);

iRoll = d100();
if (iRoll<SockChance)
   {
    iRoll=d6();
    SetLocalInt(oItem, "SOCKETS", iRoll);
    sSocks = IntToString(iRoll);
    ipAdd = ItemPropertyCastSpell
               (IP_CONST_CASTSPELL_UNIQUE_POWER,
                IP_CONST_CASTSPELL_NUMUSES_UNLIMITED_USE);
    IPSafeAddItemProperty(oItem, ipAdd);


    sName = ColorString("Socketed "+sIName+" ("+sSocks+")", 72, 209, 204 );
    SetName(oItem, sName);
    return;
   }



if (iWType==1)
{
iQual=0;

// Ranged

// Chance for worn or broken item
 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

 SetIdentified(oItem, FALSE);

//////////////////////////////////////////// Lvls 1-5      ::Ranged::

 // Attack bonus

     DelayCommand(0.2, BowEnhance(oItem, iRange));
     ++iQual;

 ////////////////////////////////////////// Lvls 6-10      ::Ranged::

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
    // Mighty
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, MightyEnhance(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll==90)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
    }

////////////////////////////////////////// Lvls 11-20     ::Ranged::

 if (iRange==3)
    {
     // Mighty
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, MightyEnhance(oItem, iRange));
         ++iQual;
        }
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Extra range damage bonus
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, RangedImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=85)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Ranged::

 if (iRange==4)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }

     // Massive Crits
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Mighty
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, MightyEnhance(oItem, iRange));
         ++iQual;
        }
     // Extra ranged damage bonus
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, RangedImbue(oItem));
         iQual+=2;
        }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=80)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 30-40     ::Ranged::

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Mighty
     iRoll = d100();
     if (iRoll>20)
        {
         DelayCommand(0.2, MightyEnhance(oItem, iRange));
         ++iQual;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, RangedImbue(oItem));
         iQual+=2;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>35)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=75)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
    }
}
else if (iWType==2)
{
// Mage
iQual=0;

 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
//////////////////////////////////////////// Lvls 1-5      ::Mage::

 // Enhancement bonus

     DelayCommand(0.2, WeapEnhance(oItem, iRange));
     ++iQual;

 ////////////////////////////////////////// Lvls 6-10     ::Mage::

 if (iRange==2)
    {
     // Extra Spell Slot  1-2
     iRoll = d100();
     if (iRoll>40)
        {
         iRoll = d3();if (iRoll==3)iRoll==2;
         DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
         ++iQual;
        }

     // Spell Bonus
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }
    }

////////////////////////////////////////// Lvls 11-20     ::Mage::

 if (iRange==3)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Extra Spell Slot  1-4
     iRoll = d100();
     if (iRoll>35)
        {
         iRoll = d4();
         DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
         ++iQual;
        }

     // Spell Bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }

     // Haste bonus
     iRoll = d100();
     if (iRoll>90)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Mage::

 if (iRange==4)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Extra Spell Slot  1-6
     iRoll = d100();
     if (iRoll==30)
        {
         iRoll = d6();
         DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
        }

     // Spell Bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }

     // Haste bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, MeleeImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 30-40     ::Mage::

 if (iRange==5)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>25)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Extra Spell Slot  1-8
     iRoll = d100();
     if (iRoll>25)
        {
         iRoll = d8();
         DelayCommand(0.2, SpellSlot(oItem, iRange, iRoll));
         ++iQual;
        }

     // Spell Bonus x 3
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, CastImbue(oItem, iRange));
         ++iQual;
        }

     // Haste bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         ++iQual;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MeleeImbue(oItem));
         iQual+=2;
        }
     // Save
     iRoll = d100();
     if (iRoll>55)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
    }


}
else if (iWType==3)
{
// Monk
 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

 SetIdentified(oItem, FALSE);

//////////////////////////////////////////// Lvls 1-5      ::Monk::

 // Attack bonus

     DelayCommand(0.2, BowEnhance(oItem, iRange));
     ++iQual;

 ////////////////////////////////////////// Lvls 6-10      ::Monk::

 if (iRange==2)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll==90)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
    }

////////////////////////////////////////// Lvls 11-20     ::Monk::

 if (iRange==3)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 2
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=85)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Monk::

 if (iRange==4)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 3
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=80)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
   }

////////////////////////////////////////// Lvls 30-40     ::Monk::

 if (iRange==5)
    {
     // Ability bonus x 2
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage Bonus x 3
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Haste
     iRoll = d100();
     if (iRoll>=75)
        {
         DelayCommand(0.2, HasteImbue(oItem));
         iQual+=2;
        }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
    }
}
else
{
// Melee

 iRoll = d100();
 if (iRoll<=CHANCE_WORN&&iRoll>CHANCE_BROKEN&&iChest!=1)  // chance of being worn
   {
    sName = ColorString("Worn "+sIName, 192, 192, 192);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }
 if (iRoll<=CHANCE_BROKEN&&iChest!=1)             // chance of being broken
   {
    DelayCommand(0.2, ACimbue(oItem, iRange, 1));
    sName = ColorString("Broken "+sIName, 255, 0, 0);
    SetName(oItem, sName);
    SetIdentified(oItem, TRUE);
    return;
   }

//////////////////////////////////////////// Lvls 1-5      ::Melee::

 // Enhancement bonus

     DelayCommand(0.2, WeapEnhance(oItem, iRange));
     ++iQual;

 ////////////////////////////////////////// Lvls 6-10     ::Melee::

 if (iRange==2)
    {
     // Damage bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Keen bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, KeenImbue(oItem));
         ++iQual;
        }
    }

////////////////////////////////////////// Lvls 11-20     ::Melee::

 if (iRange==3)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage bonus
     iRoll = d100();
     if (iRoll>35)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>45)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, MeleeImbue(oItem));
         ++iQual;
        }
     // Keen bonus
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, KeenImbue(oItem));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Melee::

 if (iRange==4)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>35)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage bonus x 2
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>65)
        {
         DelayCommand(0.2, MeleeImbue(oItem));
         ++iQual;
        }
     // Keen bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, KeenImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
     }

////////////////////////////////////////// Lvls 30-40     ::Melee::

 if (iRange==5)
    {
     // Ability bonus
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, AbilityImbue(oItem, iRange));
         ++iQual;
        }
     // Damage bonus x 3
     iRoll = d100();
     if (iRoll>25)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Massive Crits
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, MCimbue(oItem, iRange));
         ++iQual;
        }
     // Extra melee damage bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, MeleeImbue(oItem));
         ++iQual;
        }
     // Keen bonus
     iRoll = d100();
     if (iRoll>55)
        {
         DelayCommand(0.2, KeenImbue(oItem));
         ++iQual;
        }
     // Save
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, SaveImbue(oItem, iRange));
         ++iQual;
        }
    }
}

  if (iQual>8)iQual=8;
  if (iQual==0)iQual=1;

  ////////////////////////////////////////////////////////
  //: Debugging
  //
  /*
  FloatingTextStringOnCreature("ResRef: "+sType, GetFirstPC());
  FloatingTextStringOnCreature("Qual: "+IntToString(iQual), GetFirstPC());
  FloatingTextStringOnCreature("Range: "+IntToString(iRange), GetFirstPC());
  */

  switch(iQual)
       {
        case 1: sName = ColorString("Superior "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Mythical "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Titan's "+sIName, 255, 0, 255 ); break;
       }
  SetName(oItem, sName);
  SetIdentified(oItem, FALSE);
}

void DropAmmo (object oMob, object oSack, int iRange)
{
 object oItem;
 string sType, sName, sIName;
 int iRoll = d4();
 int iQual;
 int iStack = d10()*9;

 switch(iRoll)
       {
// Ammo

        case 1: {sType = "sdarrow"; iRoll = d3();
                 if (iRoll==1)sIName = "Arrow";
                 if (iRoll==2)sIName = "Steel Arrow";
                 if (iRoll==3)sIName = "Wind Cutter";}
                 break;
        case 2: {sType = "sdbolt"; iRoll = d3();
                 if (iRoll==1)sIName = "Bolt";
                 if (iRoll==2)sIName = "Deathpin";
                 if (iRoll==3)sIName = "Air Lance";}
                 break;
        case 3: {sType = "sdarrow"; iRoll = d3();
                 if (iRoll==1)sIName = "Air Assassin";
                 if (iRoll==2)sIName = "Pegasus Horn";
                 if (iRoll==3)sIName = "Blood Seeker";}
                 break;
        case 4: {sType = "sdbolt"; iRoll = d3();
                 if (iRoll==1)sIName = "Steel Bolt";
                 if (iRoll==2)sIName = "Stinger";
                 if (iRoll==3)sIName = "Blood Sparrow";}
                 break;
       }

oItem = CreateItemOnObject(sType, oSack, iStack);


// Ammo

iRoll = d100();
 if (iRoll<=10)  // 10% chance of worn item      ::Ammo::
    {
     sName = ColorString("Worn "+sIName, 192, 192, 192);
     SetName(oItem, sName);
     return;
    }

 SetIdentified(oItem, FALSE);

//////////////////////////////////////////// Lvls 1-5      ::Ammo::

//++iQual;  // Debugging

 ////////////////////////////////////////// Lvls 6-10     ::Ammo::

 if (iRange==2)
    {
     // Damage bonus
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Vamp Regen bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, VRimbue(oItem, iRange));
         ++iQual;
        }
     }


////////////////////////////////////////// Lvls 11-20     ::Ammo::

 if (iRange==3)
    {
     // Damage bonus x 2
     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Vamp Regen bonus
     iRoll = d100();
     if (iRoll>70)
        {
         DelayCommand(0.2, VRimbue(oItem, iRange));
         ++iQual;
        }
     // Unlim Ammo bonus
     iRoll = d100();
     if (iRoll>95)
        {
         DelayCommand(0.2, AmmoEnhance(oItem, iRange));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 20-30     ::Ammo::

 if (iRange==4)
    {
     // Damage bonus x 3
     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>45)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>65)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Vamp Regen bonus
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, VRimbue(oItem, iRange));
         ++iQual;
        }
     // Unlim Ammo bonus
     iRoll = d100();
     if (iRoll>85)
        {
         DelayCommand(0.2, AmmoEnhance(oItem, iRange));
         iQual+=2;
        }
     }

////////////////////////////////////////// Lvls 30-40     ::Ammo::

 if (iRange==5)
    {
     // Damage bonus x 4
     iRoll = d100();
     if (iRoll>20)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>30)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }

     iRoll = d100();
     if (iRoll>40)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     iRoll = d100();
     if (iRoll>60)
        {
         DelayCommand(0.2, DAMimbue(oItem, iRange));
         ++iQual;
        }
     // Vamp Regen bonus
     iRoll = d100();
     if (iRoll>50)
        {
         DelayCommand(0.2, VRimbue(oItem, iRange));
         ++iQual;
        }
    // Unlim Ammo bonus
     iRoll = d100();
     if (iRoll>80)
        {
         DelayCommand(0.2, AmmoEnhance(oItem, iRange));
         iQual+=2;
        }
    }

  switch(iQual)
       {
        case 0: sName = ColorString("Inferior "+sIName,255, 255, 255); break;
        case 1: sName = ColorString("Superior "+sIName,255, 255, 255); break;
        case 2: sName = ColorString("Enchanted "+sIName, 0, 255, 0); break;
        case 3: sName = ColorString("Powerful "+sIName, 65, 105, 225); break;
        case 4: sName = ColorString("Dweomic "+sIName, 102, 205, 170); break;
        case 5: sName = ColorString("Epic "+sIName, 128, 0, 218); break;
        case 6: sName = ColorString("Legendary "+sIName, 218, 165, 32 ); break;
        case 7: sName = ColorString("Mythical "+sIName, 255, 255, 0 ); break;
        case 8: sName = ColorString("Titan's "+sIName, 255, 0, 255 ); break;
       }
  SetName(oItem, sName);

}


void DropGem (object oMob, object oSack, int iRange)
{
 object oItem;

 int iRoll;
 int iVal1;
 int iVal2;

 string sType1;
 string sType2;
 string sType3;
 string sName, pName;

 iRoll=d100();
 if (iRoll<32)
 oItem = CreateItemOnObject("sd_rune", oSack, 1);
 else if (iRoll>32&&iRoll<65)
 oItem = CreateItemOnObject("sd_rune2", oSack, 1);
 else if (iRoll>65)
 oItem = CreateItemOnObject("sd_rune3", oSack, 1);

 SetIdentified(oItem, FALSE);

 iRoll = d10();
 if (iRoll==1)              // mass crits
    {
     switch(iRange)
           {
            case 1:iVal1 = d3();   break;  //1-3
            case 2:iVal1 = d3()+1; break;  //2-4
            case 3:iVal1 = d4()+2; break;  //3-6
            case 4:iVal1 = d4()+4; break;  //5-8
            case 5:iVal1 = d6()+4; break;  //7-10
            }
     if (iVal1==0)iVal1=1;
     sName = "+"+IntToString(iVal1)+" Brutal Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "MASSIVE_CRITICAL");
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
 else if (iRoll==2)             // ability rune
    {
     switch(iRange)
           {
       case 1: iVal1 = 1;break;           //1
       case 2: iVal1 = Random(2)+1;break; //1-2
       case 3: iVal1 = d3();break;        //1-3
       case 4: iVal1 = d4();break;        //1-4
       case 5: iVal1 = d3()+1;break;      //2-4
           }
     iRoll=d6();
     switch(iRoll)
           {
            case 1: {sType2 = "STRENGTH_ABILITY_BONUS"; sType1=" Mighty"; break;}
            case 2: {sType2 = "DEXTERITY_ABILITY_BONUS"; sType1=" Deft";break;}
            case 3: {sType2 = "WISDOM_ABILITY_BONUS"; sType1=" Wise";break;}
            case 4: {sType2 = "CONSTITUTION_ABILITY_BONUS"; sType1=" Hardy";break;}
            case 5: {sType2 = "INTELLEGENCE_ABILITY_BONUS"; sType1=" Clever";break;}
            case 6: {sType2 = "CHARISMA_ABILITY_BONUS"; sType1=" Charming";break;}
           }
     if (iVal1==0)iVal1=2;
     sName = "+"+IntToString(iVal1)+sType1+" Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", sType2);
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else if (iRoll==3)             // ac rune
    {
     switch(iRange)
           {
       case 1: iVal1 = 1;break;           //1
       case 2: iVal1 = Random(2)+1;break; //1-2
       case 3: iVal1 = d3();break;        //1-3
       case 4: iVal1 = d3()+2;break;      //3-5
       case 5: iVal1 = d3()+3;break;      //4-6
           }
     if (iVal1==0)iVal1=1;
     sName = "+"+IntToString(iVal1)+" AC Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "AC_BONUS");
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else if (iRoll==4)             // ab rune
    {
     switch(iRange)
           {
       case 1: iVal1 = Random(2)+1;break; //1-2
       case 2: iVal1 = d3();break;        //1-3
       case 3: iVal1 = d3()+1;break;      //2-4
       case 4: iVal1 = d3()+2;break;      //3-5
       case 5: iVal1 = d4()+3;break;      //4-6
           }
     if (iVal1==0)iVal1=2;
     sName = "+"+IntToString(iVal1)+" Attack Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "ATTACK_BONUS");
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else  if (iRoll==5)             // Enhancement rune
    {
     switch(iRange)
           {
       case 1: iVal1 = Random(2)+1;break;  //1-2
       case 2: iVal1 = d3();break;         //1-3
       case 3: iVal1 = d3()+1;break;       //2-4
       case 4: iVal1 = d3()+2;break;       //3-5
       case 5: iVal1 = d3()+3;break;       //4-6
           }
     if (iVal1==0)iVal1=2;
     sName = "+"+IntToString(iVal1)+" Enhancement Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "ENHANCEMENT_BONUS");
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else  if (iRoll==6)             // damage rune
    {
     switch(iRange)
           {
       case 1:
              {
               iRoll=d3();
               if (iRoll==1)iVal1 = 1;
               if (iRoll==2)iVal1 = 2;
               if (iRoll==3)iVal1 = 3;
              }break;
        case 2:
              {
               iRoll=d4();
               if (iRoll==1)iVal1 = 1;
               if (iRoll==2)iVal1 = 2;
               if (iRoll==3)iVal1 = 3;
               if (iRoll==4)iVal1 = 4;
              }break;
        case 3:
              {
               iRoll=d6();
               if (iRoll==1)iVal1 = 2;
               if (iRoll==2)iVal1 = 2;
               if (iRoll==3)iVal1 = 3;
               if (iRoll==4)iVal1 = 4;
               if (iRoll==5)iVal1 = 5;
               if (iRoll==6)iVal1 = 6;
              }break;
        case 4:
              {
               iRoll=d8();
               if (iRoll==1)iVal1 = 3;
               if (iRoll==2)iVal1 = 3;
               if (iRoll==3)iVal1 = 4;
               if (iRoll==4)iVal1 = 4;
               if (iRoll==5)iVal1 = 5;
               if (iRoll==6)iVal1 = 5;
               if (iRoll==7)iVal1 = 6;
               if (iRoll==8)iVal1 = 6;
              }break;
        case 5:
              {
               iRoll=d10();
               if (iRoll==1)iVal1 = 2;
               if (iRoll==2)iVal1 = 2;
               if (iRoll==3)iVal1 = 3;
               if (iRoll==4)iVal1 = 4;
               if (iRoll==5)iVal1 = 4;
               if (iRoll==6)iVal1 = 5;
               if (iRoll==7)iVal1 = 5;
               if (iRoll==8)iVal1 = 6;
               if (iRoll==9)iVal1 = 7;
               if (iRoll==10)iVal1 = 8;
               }break;
            }
     iRoll = d12();
     switch (iRoll)
      {
        case 1: {sType2 = "ACID_DAMAGE_BONUS"; sType1 = "Corrosive Gem"; break;}
        case 2: {sType2 = "BLUDGEONING_DAMAGE_BONUS"; sType1 = "Thumping Gem";break;}
        case 3: {sType2 = "COLD_DAMAGE_BONUS"; sType1 = "Ice Gem";break;}
        case 4: {sType2 = "DIVINE_DAMAGE_BONUS";sType1 = "Holy Gem";break;}
        case 5: {sType2 = "ELECTIRCAL_DAMAGE_BONUS";sType1 = "Zapping Gem";break;}
        case 6: {sType2 = "FIRE_DAMAGE_BONUS"; sType1 = "Scorching Gem";break;}
        case 7: {sType2 = "MAGICAL_DAMAGE_BONUS"; sType1 = "Magical Gem";break;}
        case 8: {sType2 = "NEGATIVE_DAMAGE_BONUS"; sType1 = "Evil Gem";break;}
        case 9: {sType2 = "PIERCING_DAMAGE_BONUS"; sType1 = "Impaling Gem";break;}
        case 10: {sType2 = "POSITIVE_DAMAGE_BONUS"; sType1 = "Benevolent Gem";break;}
        case 11: {sType2 = "SLASHING_DAMAGE_BONUS"; sType1 = "Slicing Gem";break;}
        case 12: {sType2 = "SONIC_DAMAGE_BONUS"; sType1 = "Booming Gem";break;}
       }
     if (iVal1==0)iVal1=2;
     sName = "+"+IntToString(iVal1)+" "+sType1;
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", sType2);
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else if (iRoll==7)             // VampRegen
    {
     iRoll = d4();
     sType1 = "VAMPIRIC_REGENERATION";
     switch(iRange)
           {
       case 1: iVal1 = 1;break;          //1
       case 2: iVal1 = Random(2)+1;break; //1-2
       case 3: iVal1 = d3();break;        //1-3
       case 4: iVal1 = d3()+1;break;      //2-4
       case 5: iVal1 = d3()+2;break;      //3-5
           }
     sName = "+"+IntToString(iVal1)+" Vamp Regen Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "VAMPIRIC_REGENERATION");
     SetLocalInt(oItem, "AMOUNT", iVal1);

    }
else  if (iRoll==8)             // Misc
    {
     switch(iRange)
      {
       case 1:
           {
           iRoll = d6();
           if (iRoll==1){sType1 = "Benign"; sType2 = "Cracked";}
           if (iRoll==2){sType1 = "Benign"; sType2 = "Cracked";}
           if (iRoll==3){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==4){sType1 = "HASTE"; sType2 = "Speedy";}
           if (iRoll==5){sType1 = "FREEDOM"; sType2 = "Unstoppable";}
           if (iRoll==6){sType1 = "Benign"; sType2 = "Cracked";}
          }break;
       case 2:
          {
           iRoll = d6();
           if (iRoll==1){sType1 = "HOLY_AVENGER"; sType2 = "Vengeful";}
           if (iRoll==2){sType1 = "FREEDOM"; sType2 = "Unstoppable";}
           if (iRoll==3){sType1 = "HASTE"; sType2 = "Speedy";}
           if (iRoll==4){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==5){sType1 = "Benign"; sType2 = "Cracked";}
           if (iRoll==6){sType1 = "Benign"; sType2 = "Cracked";}
          }break;
      case 3:
          {
           iRoll = d6();
           if (iRoll==1){sType1 = "HOLY_AVENGER"; sType2 = "Vengeful";}
           if (iRoll==2){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==3){sType1 = "FREEDOM"; sType2 = "Unstoppable";}
           if (iRoll==4){sType1 = "IMPROVED_EVASION"; sType2 = "Slippery";}
           if (iRoll==5){sType1 = "HOLY_AVENGER"; sType2 = "Vengeful";}
           if (iRoll==6){sType1 = "HASTE"; sType2 = "Speedy";}
          }break;
      case 4:
          {
           iRoll = d6();
           if (iRoll==1){sType1 = "HOLY_AVENGER"; sType2 = "Vengeful";}
           if (iRoll==2){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==3){sType1 = "FREEDOM"; sType2 = "Unstoppable";}
           if (iRoll==4){sType1 = "IMPROVED_EVASION"; sType2 = "Slippery";}
           if (iRoll==5){sType1 = "HASTE"; sType2 = "Speedy";}
           if (iRoll==6){sType1 = "HASTE"; sType2 = "Speedy";}
          }break;
      case 5:
          {
           iRoll = d6();
           if (iRoll==1){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==2){sType1 = "KEEN"; sType2 = "Deadly";}
           if (iRoll==3){sType1 = "FREEDOM"; sType2 = "Unstoppable";}
           if (iRoll==4){sType1 = "IMPROVED_EVASION"; sType2 = "Slippery";}
           if (iRoll==5){sType1 = "HASTE"; sType2 = "Speedy";}
           if (iRoll==6){sType1 = "TRUE_SEEING"; sType2 = "Ocular";}
          }break;
      }

     pName = sType2+" Gem";

     if (sType2=="Cracked")
        {
         sName = ColorString(pName, 255, 0, 0);
         SetName(oItem, sName);
         SetIdentified(oItem, TRUE);
         return;
        }
     else  sName = ColorString(pName, 127, 255, 212 );

     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", sType1);

    }
else  if (iRoll==9)             // Regen
    {
     iRoll = d4();
     sType1 = "REGENERATION";
     switch(iRange)
           {
       case 1: iVal1 = 1;break;          //1
       case 2: iVal1 = Random(2)+1;break; //1-2
       case 3: iVal1 = d3();break;        //1-3
       case 4: iVal1 = d3()+1;break;      //2-4
       case 5: iVal1 = d3()+2;break;      //3-5
           }
     sName = "+"+IntToString(iVal1)+" Regeneration Gem";
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", "REGENERATION");
     SetLocalInt(oItem, "AMOUNT", iVal1);
    }
else if (iRoll==10)             // damage rune
    {
     switch(iRange)
           {
        case 1: iVal1 = 5;break;   //  -/5 res
        case 2: iVal1 = 5;break;   //  -/5 res
        case 3: iVal1 = 10;break;  //  -/10 res
        case 4: iVal1 = 15;break;  //  -/15 res
        case 5: iVal1 = 20;break;  //  -/20 res
            }
     iRoll = d12();
     switch (iRoll)
      {
        case 1: {sType2 = "ACID_DAMAGE_RESISTANCE"; sType1 = "Alkaline Gem"; break;}
        case 2: {sType2 = "BLUDGEONING_DAMAGE_RESISTANCE"; sType1 = "Solid Gem";break;}
        case 3: {sType2 = "COLD_DAMAGE_RESISTANCE"; sType1 = "Warm Gem";break;}
        case 4: {sType2 = "DIVINE_DAMAGE_RESISTANCE";sType1 = "Absolvsion Gem";break;}
        case 5: {sType2 = "ELECTRICAL_DAMAGE_RESISTANCE";sType1 = "Grounding Gem";break;}
        case 6: {sType2 = "FIRE_DAMAGE_RESISTANCE"; sType1 = "Cool Gem";break;}
        case 7: {sType2 = "MAGICAL_DAMAGE_RESISTANCE"; sType1 = "Mantle Gem";break;}
        case 8: {sType2 = "NEGATIVE_DAMAGE_RESISTANCE"; sType1 = "Bright Gem";break;}
        case 9: {sType2 = "PIERCING_DAMAGE_RESISTANCE"; sType1 = "Shell Gem";break;}
        case 10: {sType2 = "POSITIVE_DAMAGE_RESISTANCE"; sType1 = "Malevolent Gem";break;}
        case 11: {sType2 = "SLASHING_DAMAGE_RESISTANCE"; sType1 = "Mesh Gem";break;}
        case 12: {sType2 = "SONIC_DAMAGE_RESISTANCE"; sType1 = "Dampening Gem";break;}
       }
     if (iVal1==0)iVal1=2;
     sName = "-/"+IntToString(iVal1)+" "+sType1;
     sName = ColorString(sName, 127, 255, 212 );
     SetName(oItem, sName);
     SetLocalString(oItem, "GEM_TYPE", sType2);
     SetLocalInt(oItem, "AMOUNT", iVal1);
    }
}



void sd_droploot (object oMob, object oSack)
{
object oPC = GetLastKiller();

// no loot if killed in stonewatch
// chances are it was an uber guard
// and not the PC that did the killing.
// This is to prevent easy looting higher mobs

if (GetTag(GetArea(oMob))=="Stonewatch")return;

// animals dont usually carry wares - but you can skin em!
// This is to prevent tiny rats dropping full plate mail - can't have that!

if (GetRacialType(oMob)== RACIAL_TYPE_ANIMAL ||
    GetRacialType(oMob)== RACIAL_TYPE_BEAST)
    {CreateItemOnObject("sd_skin", oSack, 1); return;}


/////////////////////////////////////////
//::Droprate config::
//
int DamBroke = 0;
int lMod, mMod;

// adjust the droprate modifyer based on game difficulty
// if there is no game difficulty: Default to normal
int iDiff = GetLocalInt(GetModule(), "sd_game_diff");
if (iDiff==0)lMod = DROP_RATE; //default
if (iDiff==1)lMod = 8;
if (iDiff==2)lMod = 1;

// Make monk gloves a rare drop except when the player is a lvl 5+ monk
if (GetLevelByClass(CLASS_TYPE_MONK, oPC)>5||
    GetLevelByClass(CLASS_TYPE_MONK, GetMaster(oPC))>5)mMod = 8;
else mMod=lMod-1;

// Bosses have high chance to drop loot (never broken or worn)
if (GetLocalInt(oMob, "BOSS")==1){lMod = 45; DamBroke = 1;}

int WeapChance =    6+lMod;        // % chance to drop a weapon
int MonkChance =    mMod;          // % chance to drop monk gloves
int SockChance =    15;            // % chance to drop a socketed item
int ArmorChance =   5+lMod;        // % chance to drop armor or a shield
int MItemChance =   5+lMod;        // % chance to drop a magic item
int RodWandChance = 3+lMod;        // % chance to drop a wand/rod item
int AmmoChance =    5+lMod;        // % chance to drop a bolt or an arrow
int GoldChance =    26+lMod;       // % chance to drop some gold
int PotChance =     15+lMod;       // % chance to drop a potion
int ScrollChance =  10+lMod;       // % chance to drop a magic scroll
int GemChance =     lMod;          // % chance to drop a socket gem
int MiscChance =    1;             // % chance to drop a miscellaneous item
int SetItemChance = 2;             // % chance to drop a class item setpiece
//
//
/////////////////////////////////////////////////
//::initiate variables::                       //

int iDice;
int iHD = GetHitDice(oMob);
int iRange;
int iMage;

/////////////////////////////////////////////////

// only casters drop scrolls, wands and rods

if (GetLevelByClass(CLASS_TYPE_DRUID)>0||GetLevelByClass(CLASS_TYPE_BARD)>0
    ||GetLevelByClass(CLASS_TYPE_CLERIC)>0||GetLevelByClass(CLASS_TYPE_SORCERER)>0
    ||GetLevelByClass(CLASS_TYPE_WIZARD)>0) iMage=1;



/////////////////////////////////////////////////
//::Quality range based on level of monster::  //

if (iHD>0&&iHD<6)iRange=1;    // lvl 1-5
if (iHD>5&&iHD<11)iRange=2;   // lvl 6-10
if (iHD>10&&iHD<20)iRange=3;  // lvl 11-19
if (iHD>19&&iHD<30)iRange=4;  // lvl 20-29
if (iHD>29&&iHD<41)iRange=5;  // lvl 30-40

//chance of a more powerful item

if (LUCK_CHANCE>0)
   {
    iDice = Random(LUCK_CHANCE);
    if (iDice==LUCK_CHANCE){++iRange; if (iRange==6)iRange=5;}
   }

///////////////////
//:Debugging
//:
// FloatingTextStringOnCreature("* Luck has favoured you *", GetFirstPC());}

////////////////////////////////////////////////

// Gold Roll
iDice = d100();
if (iDice<GoldChance+1)DropGold(oMob, oSack, DamBroke);

// Rod/Wand Roll
iDice = d100();
if (iDice<RodWandChance+1&&iMage==1)DropRodWand(oMob, oSack);

// SetItem Roll ** Comming Soon **
//iDice = d100();
//if (iDice<SetItemChance+1)DropSetItem(oMob, oSack);

// Weapon Roll
iDice = d100();
if (iDice<WeapChance+1)DropWeapon(oMob, oSack, iRange, SockChance, DamBroke);

// Monk Gloves Roll
iDice = d100();
if (iDice<MonkChance+1)DropMonkGloves(oMob, oSack, iRange, SockChance, DamBroke);


// Armor or shield Roll
iDice = d100();
if (iDice<ArmorChance+1)
   {
    iDice = d100();
    if (iDice>59)DropShield(oMob, oSack, iRange, SockChance, DamBroke);
    else DropArmor(oMob, oSack, iRange, SockChance, DamBroke);
   }

// Magic Item Roll
iDice = d100();
if (iDice<MItemChance+1)DropMagicItem(oMob, oSack, iRange, SockChance, DamBroke);

// Misc Item Roll
iDice = d100();
if (iDice<MiscChance+1)DropMisc(oMob, oSack);

// Ranged Ammo Roll
iDice = d100();
if (iDice<AmmoChance+1)DropAmmo(oMob, oSack, iRange);

// Pot Roll
iDice = d100();
if (iDice<PotChance+1)DropPot(oMob, oSack);

// Scroll Roll
iDice = d100();
if (iDice<ScrollChance+1&&iMage==1)DropScroll(oMob, oSack, iRange);

// Gem Roll
iDice = d100();
if (iDice<GemChance+1)DropGem(oMob, oSack, iRange);
}


///////////////////////////
//: For test compiling only
//: void main(){}
