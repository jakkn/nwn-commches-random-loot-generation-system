//::///////////////////////////////////////////////
//:: Scarface's Socketed Items include
//:: V1.6
//:: sf_socket_inc
//:://////////////////////////////////////////////
/*
         ::: Written By Scarface :::


    Few minor cosmetic changes by Commche
       - altered messages
       - colored text
       - changed imbue effect
       - added extra sounds for success/fail/full

*/
//////////////////////////////////////////////////

#include "x2_inc_itemprop"

//////////////////////////////////////////////////
//:: Constants
//:: These constants can be set to your liking
//::
//:: NOTE:
//::      Do NOT set the constants higher than the
//::      maximum specified otherwise the system
//::      will fail to function correctly.
//////////////////////////////////////////////////

// Use this switch to decide if you want to allow a gem to
// be socketed even if one of the same type is already occupying
// a socket.
// Note: this obviously won't work with haste, keen etc.
// TRUE = Allow stacking   :    FALSE = No stacking
const int STACKABLE_GEMS = TRUE;

// If this switch is set TRUE then stackable gems will use their
// own socket if a gem of the same type is already socketed.
// If this is switch set to FALSE then stackable gems will NOT take
// up another slot if a gem of the same type is already socketed.
// However the gem will still be stacked in either case based on
// the STACKABLE_GEMS switch.
// Ignore this switch if STACKABLE_GEMS is set FALSE.
const int STACKABLE_GEMS_EXTRA_SLOT = FALSE;

// Maximum Attack Bonus allowed on a weapon
// Do NOT set this higher than 20
const int MAX_ATTACK_BONUS = 8;

// Maximum Damage Bonus allowed on a weapon
// Do NOT set this higher than 20
const int MAX_DAMAGE_BONUS = 6;

// Maximum Enhancement Bonus allowed on a weapon
// Do NOT set this higher than 20
const int MAX_ENHANCEMENT_BONUS = 5;

// Maximum AC Bonus allowed on armour type items
// Do NOT set this higher than 20
const int MAX_AC_BONUS = 5;

// Maximum Damage Resistance allowed on armour type items
// The only values you can use for this to function
// correctly is: 5, 10, 15, 20, 25, 30, 35, 40, 45, 50
const int MAX_DAMAGE_RESIST = 20; // XX/-

// Maximum Regeneration Bonus allowed on armour type items
// Do NOT set this higher than 20
const int MAX_REGEN_BONUS = 5;

// Maximum Ability Bonus allowed on armour type items
// Do NOT set this higher than 12
const int MAX_ABILITY_BONUS = 4;

// Maximum Vampiric allowed on a weapon
// Do NOT set this higher than 20
const int MAX_VAMP_REGEN_BONUS = 6;

// Maximum Massive Critical allowed on a weapon
// Do NOT set this higher than 20
const int MAX_MASS_CRITS = 10;

////////////////////////////////////////////////////////////////////////////////
//:: Required Constants from the 2da
//:: Do NOT touch anything below!!!
////////////////////////////////////////////////////////////////////////////////

const int  IPRP_BONUSCOST = 1;     // Bonus
const int  IPRP_MELEECOST = 2;     // Melee
const int  IPRP_DAMAGECOST = 4;    // Damage
const int  IPRP_RESISTCOST = 7;    // DamageResist

/*
   For possible later use

const int  IPRP_SOAKCOST = 6;      // DamageSoak
const int  IPRP_SRCOST = 11;       // SpellResist
*/

// For debugging
const int DEBUG_MODE = FALSE;

////////////////////////////////////////////////////////////////////////////////
//:: Declare Functions
//:: Do NOT touch anything below!!!
////////////////////////////////////////////////////////////////////////////////

int SF_GetDamageBonusType(int iAmount);
int SF_GetMatchingItemProperty(object oItem, int iType, int iSubType = -1);
int SF_DamageBonusValueConstToInt(int iCostTableValue);
int SF_GetMatchingCostTableConst(itemproperty ipProp, int iCostTable);
int SF_DamageResistValueConstToInt(int iCostTableValue);
int SF_GetIsMeleeWeapon(object oItem, object oPC);
int SF_GetIsArmourType(object oItem, object oPC);
int SF_GetIsSocketUpgradable(object oPC, int iBonus, int iSockets);
void SF_GetSocketsLeft(object oItem, object oPC);
void SF_DecrementSocket(object oPC, object oItem, object oTarget, int iSockets, int iBonus);
void SF_SocketAttackBonusGem(object oItem, object oTarget, object oPC);
void SF_SocketDamageBonusGem(object oItem, object oTarget, object oPC, int iDamType);
void SF_SocketEnhancementBonusGem(object oItem, object oTarget, object oPC);
void SF_SocketKeenGem(object oItem, object oTarget, object oPC);
void SF_SocketACBonusGem(object oItem, object oTarget, object oPC);
void SF_SocketDamageResistGem(object oItem, object oTarget, object oPC, int iDamType);
void SF_SocketHasteGem(object oItem, object oTarget, object oPC);
void SF_SocketFreedomGem(object oItem, object oTarget, object oPC);
void SF_SocketImprovedEvasionGem(object oItem, object oTarget, object oPC);
void SF_SocketRegenerationGem(object oItem, object oTarget, object oPC);
void SF_SocketAbilityBonusGem(object oItem, object oTarget, object oPC, int iAbility);
void SF_SocketTrueSeeingGem(object oItem, object oTarget, object oPC);
void SF_SocketHolyAvengerGem(object oItem, object oTarget, object oPC);
void SF_SocketVampiricRegenerationGem(object oItem, object oTarget, object oPC);

////////////////////////////////////////////////////////////////////////////////
//:: Main Functions
//:: Do NOT touch anything below!!!
////////////////////////////////////////////////////////////////////////////////
const string COLORTOKEN = "                  ##################$%&'()*+,-./0123456789:;;==?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[[]^_`abcdefghijklmnopqrstuvwxyz{|}~~ÄÅÇÉÑÖÜáàâäãåçéèêëíìîïñóòôöõúùûü°°¢£§•¶ß®©™´¨¨ÆØ∞±≤≥¥µ∂∑∏π∫ªºΩæø¿¡¬√ƒ≈∆«»… ÀÃÕŒœ–—“”‘’÷◊ÿŸ⁄€‹›ﬁﬂ‡·‚„‰ÂÊÁËÈÍÎÏÌÓÔÒÚÛÙıˆ˜¯˘˙˚¸˝˛˛";

string ColorString(string sText, int nRed=255, int nGreen=255, int nBlue=255)
{
    return "<c" + GetSubString(COLORTOKEN, nRed, 1) + GetSubString(COLORTOKEN, nGreen, 1) + GetSubString(COLORTOKEN, nBlue, 1) + ">" + sText + "</c>";
}

void Repel (object oPC)
{
 effect eVis = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
 ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
}

const string fSound = "sim_cntresist";

int SF_GetDamageBonus(int iAmount)
{
    switch (iAmount)
    {
        case 1: iAmount = DAMAGE_BONUS_1; break;
        case 2: iAmount = DAMAGE_BONUS_2; break;
        case 3: iAmount = DAMAGE_BONUS_3; break;
        case 4: iAmount = DAMAGE_BONUS_4; break;
        case 5: iAmount = DAMAGE_BONUS_5; break;
        case 6: iAmount = DAMAGE_BONUS_6; break;
        case 7: iAmount = DAMAGE_BONUS_7; break;
        case 8: iAmount = DAMAGE_BONUS_8; break;
        case 9: iAmount = DAMAGE_BONUS_9; break;
        case 10: iAmount = DAMAGE_BONUS_10; break;
        case 11: iAmount = DAMAGE_BONUS_11; break;
        case 12: iAmount = DAMAGE_BONUS_12; break;
        case 13: iAmount = DAMAGE_BONUS_13; break;
        case 14: iAmount = DAMAGE_BONUS_14; break;
        case 15: iAmount = DAMAGE_BONUS_15; break;
        case 16: iAmount = DAMAGE_BONUS_16; break;
        case 17: iAmount = DAMAGE_BONUS_17; break;
        case 18: iAmount = DAMAGE_BONUS_18; break;
        case 19: iAmount = DAMAGE_BONUS_19; break;
        case 20: iAmount = DAMAGE_BONUS_20; break;
        default: iAmount = -1; break;
    }
    return iAmount;
}

int SF_DamageBonusValueConstToInt(int iCostTableValue)
{
    switch(iCostTableValue)
    {
        case 1: iCostTableValue = 1; break;
        case 2: iCostTableValue = 2; break;
        case 3: iCostTableValue = 3; break;
        case 4: iCostTableValue = 4; break;
        case 5: iCostTableValue = 5; break;
        case 16: iCostTableValue = 6; break;
        case 17: iCostTableValue = 7; break;
        case 18: iCostTableValue = 8; break;
        case 19: iCostTableValue = 9; break;
        case 20: iCostTableValue = 10; break;
        case 21: iCostTableValue = 11; break;
        case 22: iCostTableValue = 12; break;
        case 23: iCostTableValue = 13; break;
        case 24: iCostTableValue = 14; break;
        case 25: iCostTableValue = 15; break;
        case 26: iCostTableValue = 16; break;
        case 27: iCostTableValue = 17; break;
        case 28: iCostTableValue = 18; break;
        case 29: iCostTableValue = 19; break;
        case 30: iCostTableValue = 20; break;
        default:  iCostTableValue = -1; break;
    }
    return iCostTableValue;
}

int SF_DamageResistValueConstToInt(int iCostTableValue)
{
    switch(iCostTableValue)
    {
        case 1: iCostTableValue = 5; break;
        case 2: iCostTableValue = 10; break;
        case 3: iCostTableValue = 15; break;
        case 4: iCostTableValue = 20; break;
        case 5: iCostTableValue = 25; break;
        case 6: iCostTableValue = 30; break;
        case 7: iCostTableValue = 35; break;
        case 8: iCostTableValue = 40; break;
        case 9: iCostTableValue = 45; break;
        case 10: iCostTableValue = 50; break;
        default: iCostTableValue = -1; break;
    }
    return iCostTableValue;
}
int SF_GetMatchingItemProperty(object oItem, int iType, int iSubType = -1)
{
    if (DEBUG_MODE)
    {
        SendMessageToPC(GetFirstPC(), "int iType: " + IntToString(iType) + " int iSubType: " + IntToString(iSubType));
    }
    itemproperty ipProp = GetFirstItemProperty(oItem);
    int iCostTable, iCostValue, iMatchType, iMatchSubType;
    while (GetIsItemPropertyValid(ipProp))
    {
        iMatchType = GetItemPropertyType(ipProp);
        iMatchSubType = GetItemPropertySubType(ipProp);
        if (DEBUG_MODE)
        {
            SendMessageToPC(GetFirstPC(), "iMatchType = " + IntToString(iMatchType) +
            " iMatchSubType = " + IntToString(iMatchSubType));
        }
        if ((iMatchType == iType && iMatchSubType == iSubType) ||
             iMatchType == iType && iMatchSubType == 65535)
        {
            iCostTable = GetItemPropertyCostTable(ipProp);
            iCostValue = SF_GetMatchingCostTableConst(ipProp, iCostTable);
            if (DEBUG_MODE)
            {
                SendMessageToPC(GetFirstPC(), "iCostTable = " + IntToString(iCostTable) +
                " iCostValue = " + IntToString(iCostValue));
            }
            return iCostValue;
        }
        ipProp = GetNextItemProperty(oItem);
    }
    return FALSE;
}

int SF_GetMatchingCostTableConst(itemproperty ipProp, int iCostTable)
{
    int iCostTableValue = GetItemPropertyCostTableValue(ipProp);
    switch(iCostTable)
    {
        case IPRP_DAMAGECOST: iCostTable = SF_DamageBonusValueConstToInt(iCostTableValue); break;
        case IPRP_BONUSCOST:
        case IPRP_MELEECOST: iCostTable = iCostTableValue; break;
        case IPRP_RESISTCOST: iCostTable = SF_DamageResistValueConstToInt(iCostTableValue); break;
        default: iCostTable = -1;
    }
    return iCostTable;
}

int SF_GetDamageResistance(int iAmount)
{
    switch (iAmount)
    {
        case 5: iAmount = IP_CONST_DAMAGERESIST_5; break;
        case 10: iAmount = IP_CONST_DAMAGERESIST_10; break;
        case 15: iAmount = IP_CONST_DAMAGERESIST_15; break;
        case 20: iAmount = IP_CONST_DAMAGERESIST_20; break;
        case 25: iAmount = IP_CONST_DAMAGERESIST_25; break;;
        case 30: iAmount = IP_CONST_DAMAGERESIST_30; break;
        case 35: iAmount = IP_CONST_DAMAGERESIST_35; break;
        case 40: iAmount = IP_CONST_DAMAGERESIST_40; break;
        case 45: iAmount = IP_CONST_DAMAGERESIST_45; break;
        case 50: iAmount = IP_CONST_DAMAGERESIST_50; break;
        default: iAmount = -1; break;
    }
    return iAmount;
}

void SF_DecrementSocket(object oPC, object oItem, object oTarget, int iSockets, int iBonus)
{
    int iLength, iVal;
    string sName, sNew, sRename;



    if ((STACKABLE_GEMS_EXTRA_SLOT  && iBonus > 0) || !iBonus)
    {
        if (iSockets > 0)
        {
            iSockets --;
            SetLocalInt(oItem, "SOCKETS", iSockets);
            sName = GetName(oItem);
            iLength = GetStringLength(sName);
            sNew = GetSubString(sName, 0, iLength-7);
            sRename = sNew + "(" + IntToString(iSockets) + ")</c>";
            SetName(oItem, sRename);

        }
    }
    effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
    string sIname = "The Gem fuses itself to your "+GetName(oItem);
    string sMess = ColorString(sIname, 0, 191, 255);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    FloatingTextStringOnCreature(sMess, oPC);
    AssignCommand(oPC, PlaySound("gui_picklockopen"));
    DelayCommand(1.0, SF_GetSocketsLeft(oItem, oPC));
    DestroyObject(oTarget);
}

int SF_GetIsMeleeWeapon(object oItem, object oPC)
{
    if (!IPGetIsMeleeWeapon(oItem))
    {
        FloatingTextStringOnCreature("This object can't be socketed in this type" +
                                                               " of item", oPC);
        Repel(oPC);
        return FALSE;
    }
    return TRUE;
}

int SF_GetIsArmourType(object oItem, object oPC)
{
    int iBaseType = GetBaseItemType(oItem);
    if (iBaseType == BASE_ITEM_AMULET      || iBaseType == BASE_ITEM_ARMOR ||
        iBaseType == BASE_ITEM_BELT        || iBaseType == BASE_ITEM_BOOTS ||
        iBaseType == BASE_ITEM_BRACER      || iBaseType == BASE_ITEM_CLOAK ||
        iBaseType == BASE_ITEM_HELMET      || iBaseType == BASE_ITEM_SMALLSHIELD ||
        iBaseType == BASE_ITEM_TOWERSHIELD || iBaseType == BASE_ITEM_LARGESHIELD ||
        iBaseType == BASE_ITEM_RING)
    {
        return TRUE;
    }
    FloatingTextStringOnCreature("This object can't be socketed into this type" +
                                     " of item", oPC);
    Repel(oPC);
    return FALSE;
}

int SF_GetIsSocketUpgradable(object oPC, int iBonus, int iSockets)
{
    if (STACKABLE_GEMS && iBonus > 0)
        return TRUE;
    if (!iSockets)
    {
        string sMess = ColorString("No more sockets left",255, 0, 0);
        AssignCommand(oPC, PlaySound(fSound));
        FloatingTextStringOnCreature(sMess, oPC);
        Repel(oPC);
        return FALSE;
    }
    if (!STACKABLE_GEMS && iBonus > 0)
    {
        FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
        Repel(oPC);
        return FALSE;
    }
    return TRUE;
}

void SF_GetSocketsLeft(object oItem, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS");
    if (!iSockets)
    {
        string sMess = ColorString("No more sockets left",255, 0, 0);
        FloatingTextStringOnCreature(sMess, oPC);
        Repel(oPC);
    }
    else if (iSockets == 1)
    {
        FloatingTextStringOnCreature("1 socket left", oPC);
    }
    else
    {
        FloatingTextStringOnCreature(IntToString(iSockets) + " sockets left", oPC);
    }
}

void SF_SocketAttackBonusGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iAttackBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_ATTACK_BONUS, -1);

    if (!SF_GetIsMeleeWeapon(oItem, oPC) &&
        GetBaseItemType(oItem) != BASE_ITEM_GLOVES) return;
    if (!SF_GetIsSocketUpgradable(oPC, iAttackBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iDamageToAdd = iAmount + iAttackBonus;

    if (iDamageToAdd <= MAX_ATTACK_BONUS)
    {
        itemproperty iProp = ItemPropertyAttackBonus(iDamageToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iAttackBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" + IntToString(MAX_ATTACK_BONUS) +
                                     " Attack Bonus allowed", oPC);
       Repel(oPC);
    }
}

void SF_SocketDamageBonusGem(object oItem, object oTarget, object oPC, int iDamType)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iDamBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_DAMAGE_BONUS, iDamType);

    if (!SF_GetIsMeleeWeapon(oItem, oPC) &&
        GetBaseItemType(oItem) != BASE_ITEM_GLOVES) return;
    if (!SF_GetIsSocketUpgradable(oPC, iDamBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iDamageToAdd = iAmount + iDamBonus;

    if (iDamageToAdd <= MAX_DAMAGE_BONUS)
    {
        iDamageToAdd = SF_GetDamageBonus(iDamageToAdd);
        itemproperty iProp = ItemPropertyDamageBonus(iDamType,iDamageToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iDamBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_DAMAGE_BONUS) +
                                     " Damage Bonus of this type allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketEnhancementBonusGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iDamBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_ENHANCEMENT_BONUS);

    if (!SF_GetIsMeleeWeapon(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iDamBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iDamageToAdd = iAmount + iDamBonus;

    if (iDamageToAdd <= MAX_ENHANCEMENT_BONUS)
    {
        itemproperty iProp = ItemPropertyEnhancementBonus(iDamageToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iDamBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_ENHANCEMENT_BONUS) +
                                     " Enhancement Bonus allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketKeenGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iKeen = GetItemHasItemProperty(oItem, ITEM_PROPERTY_KEEN);

    if (!SF_GetIsMeleeWeapon(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iKeen, iSockets)) return;

    if (!iKeen)
    {
        itemproperty iProp = ItemPropertyKeen();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iKeen);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketACBonusGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iACBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_AC_BONUS);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iACBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iACToAdd = iAmount + iACBonus;

    if (iACToAdd <= MAX_AC_BONUS)
    {
        itemproperty iProp = ItemPropertyACBonus(iACToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iACBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_AC_BONUS) +
                                     " AC Bonus allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketDamageResistGem(object oItem, object oTarget, object oPC, int iDamType)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iDamResist = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_DAMAGE_RESISTANCE, iDamType);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iDamResist, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iResistToAdd = iAmount + iDamResist;

    if (iResistToAdd <= MAX_DAMAGE_RESIST)
    {
        iResistToAdd = SF_GetDamageResistance(iResistToAdd);
        itemproperty iProp = ItemPropertyDamageResistance(iDamType, iResistToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iDamResist);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum " +
                                     IntToString(MAX_DAMAGE_RESIST) +
                                     "/- Damage Resistance of this type allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketHasteGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iHaste = GetItemHasItemProperty(oItem, ITEM_PROPERTY_HASTE);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iHaste, iSockets)) return;

    if (!iHaste)
    {
        itemproperty iProp = ItemPropertyHaste();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iHaste);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketFreedomGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iFreedom = GetItemHasItemProperty(oItem, ITEM_PROPERTY_FREEDOM_OF_MOVEMENT);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iFreedom, iSockets)) return;

    if (!iFreedom)
    {
        itemproperty iProp = ItemPropertyFreeAction();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iFreedom);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketImprovedEvasionGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iImpEvasion = GetItemHasItemProperty(oItem, ITEM_PROPERTY_IMPROVED_EVASION);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iImpEvasion, iSockets)) return;

    if (!iImpEvasion)
    {
        itemproperty iProp = ItemPropertyImprovedEvasion();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iImpEvasion);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketRegenerationGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iRegenBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_REGENERATION);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iRegenBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iRegenToAdd = iAmount + iRegenBonus;

    if (iRegenToAdd <= MAX_REGEN_BONUS)
    {
        itemproperty iProp = ItemPropertyRegeneration(iRegenToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iRegenBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_REGEN_BONUS) +
                                     " Regeneration allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketAbilityBonusGem(object oItem, object oTarget, object oPC, int iAbility)
{

    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iCurrentAbility = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_ABILITY_BONUS, iAbility);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iCurrentAbility, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iAmountToAdd = iAmount + iCurrentAbility;

    if (iAmountToAdd <= MAX_ABILITY_BONUS)
    {
        itemproperty iProp = ItemPropertyAbilityBonus(iAbility, iAmountToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iAbility);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_ABILITY_BONUS) +
                                     " Ability Bonus of this type allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketTrueSeeingGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iTrueSeeing = GetItemHasItemProperty(oItem, ITEM_PROPERTY_TRUE_SEEING);

    if (!SF_GetIsArmourType(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iTrueSeeing, iSockets)) return;

    if (!iTrueSeeing)
    {
        itemproperty iProp = ItemPropertyTrueSeeing();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iTrueSeeing);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                      "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketHolyAvengerGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iHolyAvenger = GetItemHasItemProperty(oItem, ITEM_PROPERTY_HOLY_AVENGER);

    if (!SF_GetIsMeleeWeapon(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iHolyAvenger, iSockets)) return;

    if (!iHolyAvenger)
    {
        itemproperty iProp = ItemPropertyHolyAvenger();
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iHolyAvenger);
    }
    else {FloatingTextStringOnCreature("A Gem of this type is already " +
                                        "occupying a socket", oPC);
          Repel(oPC);}
}

void SF_SocketVampiricRegenerationGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iRegenBonus = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_REGENERATION_VAMPIRIC);

    if (!SF_GetIsMeleeWeapon(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iRegenBonus, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iRegenToAdd = iAmount + iRegenBonus;

    if (iRegenToAdd <= MAX_VAMP_REGEN_BONUS)
    {
        itemproperty iProp = ItemPropertyVampiricRegeneration(iRegenToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iRegenBonus);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_VAMP_REGEN_BONUS) +
                                     " Vampiric Regeneration allowed", oPC);
     Repel(oPC);
    }
}

void SF_SocketMassiveCritsGem(object oItem, object oTarget, object oPC)
{
    int iSockets = GetLocalInt(oItem, "SOCKETS"),
        iMassCrit = SF_GetMatchingItemProperty(oItem, ITEM_PROPERTY_MASSIVE_CRITICALS);

    if (!SF_GetIsMeleeWeapon(oItem, oPC)) return;
    if (!SF_GetIsSocketUpgradable(oPC, iMassCrit, iSockets)) return;

    int iAmount = GetLocalInt(oTarget, "AMOUNT"),
        iMassCritToAdd = iAmount + iMassCrit;

    if (iMassCritToAdd <= MAX_MASS_CRITS)
    {
        SetLocalInt(oItem, "CURRENT_MASS_CRIT_BONUS", iMassCritToAdd);
        iMassCritToAdd = SF_GetDamageBonus(iMassCritToAdd);
        itemproperty iProp = ItemPropertyMassiveCritical(iMassCritToAdd);
        IPSafeAddItemProperty(oItem, iProp);
        SF_DecrementSocket(oPC, oItem, oTarget, iSockets, iMassCrit);
    }
    else
    {
        FloatingTextStringOnCreature("Socketing this Gem will exceed the " +
                                     "maximum +" +
                                     IntToString(MAX_MASS_CRITS) +
                                     " Massive Critial allowed", oPC);
     Repel(oPC);
    }
}

//void main() {}
