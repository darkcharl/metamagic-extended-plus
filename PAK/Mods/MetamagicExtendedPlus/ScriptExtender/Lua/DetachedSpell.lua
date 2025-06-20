debugMode = false
DetachedSpells = {}

Ext.Require("Utils.lua")

function DetachSpell(spellName, activateDetachment)
    local spell = Ext.Stats.Get(spellName)
    
    for _, property in pairs({spell.SpellFail, spell.SpellSuccess, spell.SpellProperties}) do
        for _, offset in pairs(property) do
            if property ~= nil then
                for _, functor in pairs(offset.Functors) do
                    if functor.IsControlledByConcentration then
                        if (activateDetachment) then
                            functor.IsControlledByConcentration = false
                        else
                            functor.IsControlledByConcentration = true
                        end
                    end
                end
            end
        end
    end

    if (activateDetachment) then
        -- detach spell
        if (debugMode) then
            print("--- MetamagicExtendedPlus: DetachSpell(): Detach")
        end
        
        origSpellFlags = spell.SpellFlags
        spell.SpellFlags = omit_flag(spell.SpellFlags, "IsConcentration")
        DetachedSpells[spellName] = origSpellFlags
    else
        -- reset spell
        if (debugMode) then
            print("--- MetamagicExtendedPlus: DetachSpell(): Reset")
        end
        
        if (DetachedSpells[spellName] ~= nil) then
            spell.SpellFlags = DetachedSpells[spellName]
        end
        DetachedSpells[spellName] = nil
    end
    
    if (debugMode) then
        print("--- MetamagicExtendedPlus: DetachSpell")
        print("spellName:  ", spellName)
        print("spell:")
        _D(spell)
    end
end
