debugMode = true
radiusMultiplier = 2
ExpandedSpells = {}

Ext.Require("Utils.lua")

function ExpandSpell(spellName, activateExpansion)
    local spell = Ext.Stats.Get(spellName)
    local originalValues = {}
    
    for _, property in pairs({spell.SpellFail, spell.SpellSuccess, spell.SpellProperties}) do
        for _, offset in pairs(property) do
            if property ~= nil then
                for _, functor in pairs(offset.Functors) do
                    if functor.TypeId == 'CreateSurface' then
                        if (activateExpansion) then
                            originalValues['Radius'] = functor.Radius
                            functor.Radius = radiusMultiplier * functor.Radius
                        else
                            functor.Radius = ExpandedSpells[spellName]['Radius']
                        end
                    end
                end
            end
        end
    end

    if (activateExpansion) then
        -- expand spell
        if (debugMode) then
            print("--- MetamagicExtendedPlus: ExpandSpell(): Expand")
        end
        
        if (spell.Range and spell.Range > 0) then
            originalValues['Range'] = spell.Range
            spell.Range = radiusMultiplier * spell.Range
        end

        if (spell.AreaRadius and spell.AreaRadius > 0) then
            originalValues['AreaRadius'] = spell.AreaRadius
            spell.AreaRadius = radiusMultiplier * spell.AreaRadius
        end

        if (spell.ExplodeRadius and spell.ExplodeRadius > 0) then
            originalValues['ExplodeRadius'] = spell.ExplodeRadius
            spell.ExplodeRadius = radiusMultiplier * spell.ExplodeRadius
        end

        ExpandedSpells[spellName] = originalValues
    else
        -- reset spell
        if (debugMode) then
            print("--- MetamagicExtendedPlus: ExpandSpell(): Reset")
        end
        
        if (ExpandedSpells[spellName]['Range'] ~= nil) then
            spell.Range = ExpandedSpells[spellName]['Range']
        end

        if (ExpandedSpells[spellName]['AreaRadius'] ~= nil) then
            spell.AreaRadius = ExpandedSpells[spellName]['AreaRadius']
        end

        if (ExpandedSpells[spellName]['ExplodeRadius'] ~= nil) then
            spell.ExplodeRadius = ExpandedSpells[spellName]['ExplodeRadius']
        end
    
        ExpandedSpells[spellName] = nil
    end
    
    if (debugMode) then
        print("--- MetamagicExtendedPlus: ExpandSpell")
        print("spellName:  ", spellName)
        print("multiplier: ", radiusMultiplier)
        print("orig values:")
        _D(originalValues)
        print("spell:")
        _D(spell)
    end
end
