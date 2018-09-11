
effect eVis;
effect eFinal;

// Removes Supernatural Bonuses when set-gear is unequipped
void SD_REMOVE(object oSubraceCharacter);

//Applies Damage Vulernability to Target
//========================================
// oPC = Target to apply the effect to
// iType = DAMAGE_TYPE_*
// iAmount = nPercentImmunity
void BonusDamageVulnerability(object oPC, int iType, int iAmount);

//Applies Miss Chance Effect to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = 1-100 inclusive
void BonusCTM(object oPC, int iAmount);
void m_BonusCTM(object oPC);

//Applies Bonus Attacks/Round to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = maximum is 5, even with the effect stacked
void BonusAPR(object oPC, int iAmount);
void m_BonusAPR(object oPC);

//Applies Regeneration to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = amount of damage to be regenerated per time interval
void BonusRegen(object oPC, int iAmount);
void m_BonusRegen(object oPC);

//Applies Temporary Hit Points to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = # of Temporary HitPoints to award
void BonusHP(object oPC, int iHP);

//Applies Ability Bonus Target
//========================================
// oPC = Target to apply the effect to
// iAbility =  ABILITY_*
// eg:
//    ABILITY_CHARISMA, ABILITY_CONSTITUTION, ABILITY_DEXTERITY
//    ABILITY_INTELLIGENCE, ABILITY_STRENGTH, ABILITY_WISDOM
// iAmount = Amount to Increase
void BonusAbility(object oPC, int iAbility, int iAmount);
void m_BonusAbility(object oPC, int iAbility, int iAmount);

//Applies AC Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = Amount to Increase
// iType =  AC_*_BONUS
void BonusAC(object oPC, int iAmount, int iType);
void m_BonusAC(object oPC, int iAmount);

//Applies Bonus Movement Speed to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = range 0 through 99
// eg.
//    0 = no change in speed
//   50 = 50% faster
//   99 = almost twice as fast
void BonusSpeed(object oPC, int iAmount);
void m_BonusSpeed(object oPC, int iAmount);

//Applies Attack Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iAmount = size of attack bonus
void BonusAttack(object oPC, int iAmount);
void m_BonusAttack(object oPC, int iAmount);

//Applies Damage Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iType =  DAMAGE_TYPE_*
// iAmount = DAMAGE_BONUS_*
void BonusDamage(object oPC, int iType, int iAmount);
void m_BonusDamage(object oPC, int iType, int iAmount);

//Applies Immunity Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iType =  IMMUNITY_TYPE_*
void BonusImmunity(object oPC, int iType);
void m_BonusImmunity(object oPC, int iType);

//Applies Save Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iType =  SAVING_THROW_* (not SAVING_THROW_TYPE_*)
// iAmount = size of the Saving Throw increase
void BonusSave(object oPC, int iType, int iAmount);
void m_BonusSave(object oPC, int iType, int iAmount);

//Applies Save Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iSkill =  SKILL_*
// iAmount = size of the skill increase
//* Returns an effect of type EFFECT_TYPE_INVALIDEFFECT if nSkill is invalid.
void BonusSkill(object oPC, int iSkill, int iAmount);
void m_BonusSkill(object oPC, int iSkill, int iAmount);

//Applies Damage Immunity Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iType =  DAMAGE_TYPE_*
// iAmount = Percentage of immunity
void BonusDamageImmunity(object oPC, int iType, int iAmount);
void m_BonusDamageImmunity(object oPC, int iType, int iAmount);

//Applies Spell Immunity Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iSpell =  SPELL_*
// There is a known bug with this function. There *must* be a parameter specified
// when this is called (even if the desired parameter is SPELL_ALL_SPELLS)
void BonusSpellImmunity(object oPC, int iSpell);
void m_BonusSpellImmunity(object oPC, int iSpell);

//Applies Concealment Bonus to Target
//========================================
// oPC = Target to apply the effect to
// iAmount =  Percentage > 100
// iType = MISS_CHANCE_TYPE_*
void BonusConcealment(object oPC, int iAmount, int iType);
void m_BonusConcealment(object oPC, int iAmount);

//Applies Ultravision Bonus to Target
//========================================
// oPC = Target to apply the effect to
void BonusUltravision(object oPC);
void m_BonusUltravision(object oPC);

//Applies Truseeing Bonus to Target
//========================================
// oPC = Target to apply the effect to
void BonusTruseeing(object oPC);
void m_BonusTruseeing(object oPC);

//Applies Haste to Target
//========================================
// oPC = Target to apply the effect to
void BonusHaste(object oPC);
void m_BonusHaste(object oPC);

//Applies Haste to Target
//========================================
// oPC = Target to send message to
// sMessage = "Subrace Bonus: " + input
void SubMessage(object oPC, string sMessage);
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

void SubMessage(object oPC, string sMessage)
{
 SendMessageToPC(oPC, "Subrace Bonus: "+sMessage);
}

////////////////////////////////////////////////////////////////////////////////
//:Ability Wrappers
//:
//:
//:

void BonusDamageVulnerability(object oPC, int iType, int iAmount)
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectDamageImmunityDecrease(iType, iAmount)), oPC);
}

void BonusCTM(object oPC, int iAmount)
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectMissChance(iAmount)), oPC);
}
void m_BonusCTM(object oPC)
{
 SubMessage(oPC, "You can anticipate your enemy's next move with uncanny accuracy");
}
void BonusAPR(object oPC, int iAmount)
{
 if (iAmount>5)iAmount=5;
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectModifyAttacks(iAmount)), oPC);
}
void m_BonusAPR(object oPC)
{
 SubMessage(oPC, "You attack with more ferocity");
}
void BonusRegen(object oPC, int iAmount)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectRegenerate(iAmount, 6.0)), oPC);
}
void m_BonusRegen(object oPC)
{
 SubMessage(oPC, "Your wounds begin to heal themselves");
}
void BonusHP(object oPC, int iHP)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectTemporaryHitpoints(iHP)), oPC);
}
void BonusAbility(object oPC, int iAbility, int iAmount)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectAbilityIncrease(iAbility, iAmount)), oPC);
}
void m_BonusAbility(object oPC, int iAbility, int iAmount)
{
 switch (iAbility)
 {
 case ABILITY_CHARISMA: {SubMessage(oPC, "You feel more talented");}break;
 case ABILITY_CONSTITUTION: {SubMessage(oPC, "You feel more stalwart");}break;
 case ABILITY_DEXTERITY: {SubMessage(oPC, "You feel more agile");}break;
 case ABILITY_INTELLIGENCE: {SubMessage(oPC, "You feel smarter");}break;
 case ABILITY_STRENGTH: {SubMessage(oPC, "You feel stronger");}break;
 case ABILITY_WISDOM: {SubMessage(oPC, "You feel wiser");}break;
 }
}
void BonusAC(object oPC, int iAmount, int iType)
{
 if (iAmount<0)iAmount=1;
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectACIncrease(iAmount, iType)), oPC);
}
void m_BonusAC(object oPC, int iAmount)
{
 SubMessage(oPC, "AC increased");
}
void BonusSpeed(object oPC, int iAmount)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect
 (EffectMovementSpeedIncrease(iAmount)), oPC);

}
void m_BonusSpeed(object oPC, int iAmount)
{
 SubMessage(oPC, "You feel faster");
}
void BonusAttackDecrease(object oPC, int iAmount)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectAttackDecrease(iAmount)), oPC);

}
void BonusAttack(object oPC, int iAmount)
{
 if (iAmount<0)iAmount=1;
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectAttackIncrease(iAmount)), oPC);

}
void m_BonusAttack(object oPC, int iAmount)
{
 SubMessage(oPC, "Your melee skill improves");
}
void BonusDamage(object oPC, int iType, int iAmount)
{
  ApplyEffectToObject(DURATION_TYPE_PERMANENT,SupernaturalEffect
 (EffectDamageIncrease(iAmount, iType)), oPC);

}
void m_BonusDamage(object oPC, int iType, int iAmount)
{

 SubMessage(oPC, "Your blows are more damaging");
}
void BonusImmunity(object oPC, int iType)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectImmunity(iType)), oPC);

}
void m_BonusImmunity(object oPC, int iType)
{

 switch (iType)
 {
 case IMMUNITY_TYPE_BLINDNESS: {SubMessage(oPC, "Immunity to blindness");}break;
 case IMMUNITY_TYPE_DEATH: {SubMessage(oPC, "You no longer fear death ");}break;
 case IMMUNITY_TYPE_DISEASE: {SubMessage(oPC, "You shrug off disease");}break;
 case IMMUNITY_TYPE_FEAR: {SubMessage(oPC, "Your fear dissapears");}break;
 case IMMUNITY_TYPE_MOVEMENT_SPEED_DECREASE: {SubMessage(oPC, "Immunity to speed decrease");}break;
 case IMMUNITY_TYPE_PARALYSIS: {SubMessage(oPC, "Immunity to paralysis");}break;
 case IMMUNITY_TYPE_POISON: {SubMessage(oPC, "You drink poison for breakfast");}break;
 case IMMUNITY_TYPE_STUN: {SubMessage(oPC, "Immunity to stun");}break;
 case IMMUNITY_TYPE_NEGATIVE_LEVEL: {SubMessage(oPC, "Immunity to level drain");}break;
 case IMMUNITY_TYPE_ABILITY_DECREASE: {SubMessage(oPC, "Immunity to ability decrease");}break;
 case IMMUNITY_TYPE_CURSED: {SubMessage(oPC, "You laugh at curses");}break;
 }
}
void BonusSave(object oPC, int iType, int iAmount)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectSavingThrowIncrease(iType, iAmount, SAVING_THROW_TYPE_ALL)), oPC);

}
void m_BonusSave(object oPC, int iType, int iAmount)
{
 switch (iType)
 {
 case SAVING_THROW_FORT: {SubMessage(oPC, "You feel more fortuitous");}break;
 case SAVING_THROW_REFLEX: {SubMessage(oPC, "Your reflexes improve");}break;
 case SAVING_THROW_WILL: {SubMessage(oPC, "Your will strengthens");}break;
 case SAVING_THROW_TYPE_FEAR: {SubMessage(oPC, "You are more fearless");}break;
 case SAVING_THROW_TYPE_DEATH: {SubMessage(oPC, "You are less concerned about death");}break;
 }
}
void BonusSkill(object oPC, int iSkill, int iAmount)
{
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectSkillIncrease(iSkill, iAmount)), oPC);

}
void m_BonusSkill(object oPC, int iSkill, int iAmount)
{
switch (iSkill)
 {
 case SKILL_CONCENTRATION: {SubMessage(oPC, "Your concentration improves");}break;
 case SKILL_DISCIPLINE: {SubMessage(oPC, "You feel more disciplined");}break;
 case SKILL_HEAL: {SubMessage(oPC, "Your healing skills improve");}break;
 case SKILL_HIDE: {SubMessage(oPC, "You are able to hide better");}break;
 case SKILL_LISTEN: {SubMessage(oPC, "Your hearing improves");}break;
 case SKILL_MOVE_SILENTLY: {SubMessage(oPC, "Your footsteps become quieter");}break;
 case SKILL_SPELLCRAFT: {SubMessage(oPC, "Your knowledge of magic improves");}break;
 case SKILL_TUMBLE: {SubMessage(oPC, "You can tumble more proficiently");}break;
 case SKILL_TAUNT: {SubMessage(oPC, "Your antagonistic abilities improve");}break;
 case SKILL_USE_MAGIC_DEVICE: {SubMessage(oPC, "Your understanding of magic devices increases");}break;
 }
}
void BonusDamageImmunity(object oPC, int iType, int iAmount)
{
 if (iAmount<0)iAmount=1;
ApplyEffectToObject(DURATION_TYPE_PERMANENT,
SupernaturalEffect(EffectDamageImmunityIncrease(iType, iAmount)), oPC);

}
void m_BonusDamageImmunity(object oPC, int iType, int iAmount)
{
switch (iType)
 {
 case DAMAGE_TYPE_ACID: {SubMessage(oPC, IntToString(iAmount)+"% acid damage immunity increase");}break;
 case DAMAGE_TYPE_BLUDGEONING: {SubMessage(oPC, IntToString(iAmount)+"% bludgeoning damage immunity increase");}break;
 case DAMAGE_TYPE_COLD: {SubMessage(oPC, IntToString(iAmount)+"% cold immunity damage increase");}break;
 case DAMAGE_TYPE_MAGICAL: {SubMessage(oPC, IntToString(iAmount)+"% magical damage immunity increase");}break;
 case DAMAGE_TYPE_ELECTRICAL: {SubMessage(oPC, IntToString(iAmount)+"% electrical damage immunity increase");}break;
 case DAMAGE_TYPE_SLASHING: {SubMessage(oPC, IntToString(iAmount)+"% slashing damage immunity increase");}break;
 case DAMAGE_TYPE_PIERCING: {SubMessage(oPC, IntToString(iAmount)+"% piercing damage immunity increase");}break;
 case DAMAGE_TYPE_FIRE: {SubMessage(oPC, IntToString(iAmount)+"% fire damage immunity increase");}break;
 case DAMAGE_TYPE_NEGATIVE: {SubMessage(oPC, IntToString(iAmount)+"% negative damage immunity increase");}break;
 }
}

void BonusSpellImmunity(object oPC, int iSpell)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectSpellImmunity(iSpell)), oPC);

}
void m_BonusSpellImmunity(object oPC, int iSpell)
{
 switch (iSpell)
 {
 case SPELL_DOOM: {SubMessage(oPC, "Immune to spell: Doom");}break;
 case SPELL_DAZE: {SubMessage(oPC, "Immune to spell: Daze");}break;
 case SPELL_STORM_OF_VENGEANCE: {SubMessage(oPC, "Immune to spell: Storm of Vengeance");}break;
 case SPELL_HARM: {SubMessage(oPC, "Immune to spell: Harm");}break;
 }
}
void BonusConcealment(object oPC, int iAmount, int iType)
{
 int eVis;
 if (iAmount>50)eVis = VFX_DUR_ETHEREAL_VISAGE;
 else eVis = VFX_DUR_GHOSTLY_VISAGE_NO_SOUND;

 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectConcealment(iAmount, iType)), oPC);
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectVisualEffect(eVis)), oPC);
}
void m_BonusConcealment(object oPC, int iAmount)
{
 SubMessage(oPC, "You partially fade from sight");
}
void BonusUltravision(object oPC)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectUltravision()), oPC);

}
void m_BonusUltravision(object oPC)
{
 SubMessage(oPC, "Your vision becomes all penetrating");
}
void BonusTruseeing(object oPC)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectTrueSeeing()), oPC);

}
void m_BonusTruseeing(object oPC)
{
 SubMessage(oPC, "Your vision penetrates even the thickest of vales");
}
void BonusHaste(object oPC)
{
 ApplyEffectToObject(DURATION_TYPE_PERMANENT,
 SupernaturalEffect(EffectHaste()), oPC);
}
void m_BonusHaste(object oPC)
{
 SubMessage(oPC, "The world around you somehow seems slower");
}


////////////////////////////////////////////////////////////////////////////////
//:General Utilities
//:
//:
//:

void UnSet(object oSubraceCharacter, effect eSubraceEffect)
{
    if((GetEffectCreator(eSubraceEffect) == GetModule()) &&
       (GetEffectSubType(eSubraceEffect) == SUBTYPE_SUPERNATURAL))
    {
        RemoveEffect(oSubraceCharacter, eSubraceEffect);
    }
}
void SD_REMOVE(object oSubraceCharacter)
{
    effect eFX = GetFirstEffect(oSubraceCharacter);
    while(GetIsEffectValid(eFX))
    {
        UnSet(oSubraceCharacter, eFX);
        eFX = GetNextEffect(oSubraceCharacter);
    }
}
////////////////////////////////////////////////////////////////////////////////
//:Set Specifics
//:
//:
//:
//:

///////////////////////////////
//:Dorian's Battlegear
//:

void DoriansBattlegearEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
 eFinal = EffectVisualEffect(VFX_FNF_PWKILL);

 switch (iPieces)
        {
         case 1: {} break;

         case 2:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_STRENGTH, 4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Dorian's Set Bonus I Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 3:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_STRENGTH, 4));
                } break;
         case 4:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_STRENGTH, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Dorian's Set Bonus II Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 5:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_STRENGTH, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d4));
                } break;
           case 6:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_STRENGTH, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d4));
                 DelayCommand(0.1, BonusAPR(oPC, 2));
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eFinal, oPC);
                 if (iFlag==0)FloatingTextStringOnCreature("* Dorian's Set Completion Bonus Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
           }

}
//////////////////////////////////////////////////////
void DoriansBattlegearUnEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

 switch (iPieces)
        {
         case 1:
                {
                 SD_REMOVE(oPC);
                 FloatingTextStringOnCreature("* Set Dorian's Bonus I Lost *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
         case 2:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_STRENGTH, 4);
                 } break;
         case 3:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_STRENGTH, 4);
                  FloatingTextStringOnCreature("* Dorian's Set Bonus II Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
        case 4:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_STRENGTH, 4);
                  BonusDamage(oPC, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d4);
                 } break;
       case 5:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_STRENGTH, 4);
                  BonusDamage(oPC, DAMAGE_TYPE_FIRE, DAMAGE_BONUS_1d4);
                  FloatingTextStringOnCreature("* Dorian's Set Completion Bonus Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
       }

}

///////////////////////////////
//:Mystra's Rainment
//:

void MystrasRainmentEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
 eFinal = EffectVisualEffect(VFX_FNF_PWKILL);

 switch (iPieces)
        {
         case 1: {} break;

         case 2:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_INTELLIGENCE, 4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Mystra's Set Bonus I Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 3:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_INTELLIGENCE, 4));
                } break;

         case 4:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_INTELLIGENCE, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                 if (iFlag==0)FloatingTextStringOnCreature("* Mystra's Set Bonus II Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 5:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_INTELLIGENCE, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                } break;
         case 6:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_INTELLIGENCE, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                 DelayCommand(0.1, BonusHaste(oPC));
                 DelayCommand(0.1, BonusImmunity(oPC, IMMUNITY_TYPE_CRITICAL_HIT));
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eFinal, oPC);
                 if (iFlag==0)FloatingTextStringOnCreature("* Mystra's Set Completion Bonus Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
           }

}
//////////////////////////////////////////////////////
void MystrasRainmentUnEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

 switch (iPieces)
        {
         case 1:
                {
                 SD_REMOVE(oPC);
                 FloatingTextStringOnCreature("* Mystra's Set Bonus I Lost *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
         case 2:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_INTELLIGENCE, 4);
                 }; break;
         case 3:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_INTELLIGENCE, 4);
                  FloatingTextStringOnCreature("* Mystra's Set Bonus II Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
         case 4:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_INTELLIGENCE, 4);
                  BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL);
                 }; break;
         case 5:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_INTELLIGENCE, 4);
                  BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL);
                  FloatingTextStringOnCreature("* Mystra's Set Completion Bonus Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
       }

}

///////////////////////////////
//:Thera's Vestments
//:

void TherasVestmentsEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
 eFinal = EffectVisualEffect(VFX_FNF_PWKILL);

 switch (iPieces)
        {
         case 1: {} break;

         case 2:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_CHARISMA, 4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Thera's Set Bonus I Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 3:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_CHARISMA, 4));
                } break;

         case 4:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_CHARISMA, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                 if (iFlag==0)FloatingTextStringOnCreature("* Thera's Set Bonus II Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 5:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_CHARISMA, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                } break;
         case 6:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_CHARISMA, 4));
                 DelayCommand(0.1, BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL));
                 DelayCommand(0.1, BonusHaste(oPC));
                 DelayCommand(0.1, BonusImmunity(oPC, IMMUNITY_TYPE_CRITICAL_HIT));
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eFinal, oPC);
                 if (iFlag==0)FloatingTextStringOnCreature("* Thera's Set Completion Bonus Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
           }

}
//////////////////////////////////////////////////////
void TherasVestmentsUnEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

 switch (iPieces)
        {
         case 1:
                {
                 SD_REMOVE(oPC);
                 FloatingTextStringOnCreature("* Thera's Set Bonus I Lost *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
         case 2:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_CHARISMA, 4);
                 }; break;
         case 3:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_CHARISMA, 4);
                  FloatingTextStringOnCreature("* Thera's Set Bonus II Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
         case 4:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_CHARISMA, 4);
                  BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL);
                 }; break;
         case 5:
                 {
                  SD_REMOVE(oPC);
                  BonusAbility(oPC, ABILITY_INTELLIGENCE, 4);
                  BonusConcealment(oPC, 30, MISS_CHANCE_TYPE_NORMAL);
                  FloatingTextStringOnCreature("* Thera's Set Completion Bonus Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 }; break;
       }

}

///////////////////////////////
//:Shinobi's Garb
//:

void ShinobisGarbEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
 eFinal = EffectVisualEffect(VFX_FNF_PWKILL);

 switch (iPieces)
        {
         case 1: {} break;

         case 2:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusSpeed(oPC, 50));
                 if (iFlag==0)FloatingTextStringOnCreature("* Shinobi's Set Bonus I Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 3:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusSpeed(oPC, 50));
                } break;
         case 4:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusSpeed(oPC, 50));
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_DEXTERITY, 4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Shinobi's Set Bonus II Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 5:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusSpeed(oPC, 50));
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_DEXTERITY, 4));
                } break;
           case 6:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusSpeed(oPC, 50));
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_DEXTERITY, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_PIERCING, DAMAGE_BONUS_1d4));
                 DelayCommand(0.1, BonusConcealment(oPC, 60, MISS_CHANCE_TYPE_NORMAL));
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eFinal, oPC);
                 if (iFlag==0)FloatingTextStringOnCreature("* Shinobi's Set Completion Bonus Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
           }

}
//////////////////////////////////////////////////////
void ShinobisGarbUnEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

 switch (iPieces)
        {
         case 1:
                {
                 SD_REMOVE(oPC);
                 FloatingTextStringOnCreature("* Shinobi's Set Bonus I Lost *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
         case 2:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusSpeed(oPC, 50));
                 } break;
         case 3:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusSpeed(oPC, 50));
                  FloatingTextStringOnCreature("* Shinobi's Set Bonus II Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
        case 4:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusSpeed(oPC, 50));
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_DEXTERITY, 4));
                 } break;
       case 5:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusSpeed(oPC, 50));
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_DEXTERITY, 4));
                  FloatingTextStringOnCreature("* Shinobi's Set Completion Bonus Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
       }
}
///////////////////////////////
//:Benedict's Herald
//:

void BenedictsHeraldEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
 eFinal = EffectVisualEffect(VFX_FNF_PWKILL);

 switch (iPieces)
        {
         case 1: {} break;

         case 2:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Benedict's Set Bonus I Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 3:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                } break;
         case 4:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_DIVINE, DAMAGE_BONUS_1d4));
                 if (iFlag==0)FloatingTextStringOnCreature("* Benedict's Set Bonus II Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
         case 5:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_DIVINE, DAMAGE_BONUS_1d4));
                } break;
           case 6:
                {
                 SD_REMOVE(oPC);
                 DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                 DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_DIVINE, DAMAGE_BONUS_1d4));
                 DelayCommand(0.1, BonusImmunity(oPC, IMMUNITY_TYPE_NEGATIVE_LEVEL));
                 DelayCommand(0.1, BonusHaste(oPC));
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eFinal, oPC);
                 if (iFlag==0)FloatingTextStringOnCreature("* Benedict's Set Completion Bonus Applied *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                } break;
           }

}
//////////////////////////////////////////////////////
void BenedictsHeraldUnEquip(object oPC, int iPieces, int iFlag)
{
 eVis = EffectVisualEffect(VFX_FNF_LOS_EVIL_10);

 switch (iPieces)
        {
         case 1:
                {
                 SD_REMOVE(oPC);
                 FloatingTextStringOnCreature("* Benedict's Set Bonus I Lost *", oPC);
                 if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
         case 2:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                 } break;
         case 3:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                  FloatingTextStringOnCreature("* Benedict's Set Bonus II Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
        case 4:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                  DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_DIVINE, DAMAGE_BONUS_1d4));
                 } break;
       case 5:
                 {
                  SD_REMOVE(oPC);
                  DelayCommand(0.1, BonusAbility(oPC, ABILITY_WISDOM, 4));
                  DelayCommand(0.1, BonusDamage(oPC, DAMAGE_TYPE_DIVINE, DAMAGE_BONUS_1d4));
                  FloatingTextStringOnCreature("* Benedict's Set Completion Bonus Lost *", oPC);
                  if (iFlag==0)ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
                 } break;
       }

}


////////////////////////////////////////////////////////////////////////////////
//:Reapply set bonuses after death
//:
//:
//:

void ApplySetBonus(object oPC)
{
 string sID, sSetName;
 int iPieces;
 object oItem;

 sID = "Dorian's Battlegear_equ";
 iPieces = GetLocalInt(oPC, sID);
 if (iPieces>0)DoriansBattlegearEquip(oPC, iPieces, 1);
 sID = "Mystra's Rainment_equ";
 iPieces = GetLocalInt(oPC, sID);
 if (iPieces>0)MystrasRainmentEquip(oPC, iPieces, 1);
 sID = "Thera's Vestments_equ";
 iPieces = GetLocalInt(oPC, sID);
 if (iPieces>0)TherasVestmentsEquip(oPC, iPieces, 1);
 sID = "Shinobi's Garb_equ";
 iPieces = GetLocalInt(oPC, sID);
 if (iPieces>0)ShinobisGarbEquip(oPC, iPieces, 1);
 sID = "Benedict's Herald_equ";
 iPieces = GetLocalInt(oPC, sID);
 if (iPieces>0)BenedictsHeraldEquip(oPC, iPieces, 1);
}



///////////////////////
//: For Test Compiling
//: void main(){}
