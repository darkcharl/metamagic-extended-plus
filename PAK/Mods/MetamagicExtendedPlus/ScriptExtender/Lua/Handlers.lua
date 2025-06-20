debugMode = false

Ext.Require("Utils.lua")

function StartedPreviewingSpellHandler(caster, spellName, isMostPowerful, hasMultipleLevels)
    local spell = Ext.Stats.Get(spellName)
    
    if (debugMode) then
        print("--- MetamagicExtendedPlus: StartedPreviewingSpell()")
        _D(spell)
    end

    if (Osi.IsPlayer(caster) and has_spell_flag(spell.SpellFlags)) then
        local isDetached = HasActiveStatus(caster, "METAMAGIC_DETACHED") == 1
        local isExpanded = HasActiveStatus(caster, "METAMAGIC_EXPANDED") == 1

        if (debugMode) then
            print('caster:    ', caster)
            print('spell name:', spellName)
            print('isDetached:', isDetached)
            print('isExpanded:', isExpanded)
        end

        if (isDetached and not has_spell(DetachedSpells, spellName)) then
            DetachSpell(spellName, true)
        elseif (isExpanded and not has_spell(ExpandedSpells, spellName)) then
            ExpandSpell(spellName, true)
        end
    end
end

function SpellCastHandler(caster, spellName, spellType, spellElement, storyActionID)
    local spell = Ext.Stats.Get(spellName)
    if (debugMode) then
        print("--- MetamagicExtendedPlus: SpellCastHandler()")
    end

    -- Automatically reset spell after cast or failed
    if (has_spell(DetachedSpells, spellName)) then
        DetachSpell(spellName, false)
    elseif (has_spell(ExpandedSpells, spellName)) then
        ExpandSpell(spellName, false)
    end
end

Ext.Osiris.RegisterListener("StartedPreviewingSpell", 4, "before", StartedPreviewingSpellHandler)
Ext.Osiris.RegisterListener("CastedSpell", 5, "after", SpellCastHandler)
Ext.Osiris.RegisterListener("CastSpellFailed", 5, "after", SpellCastHandler)
