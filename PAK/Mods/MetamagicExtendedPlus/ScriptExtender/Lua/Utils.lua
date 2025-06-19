function has_spell_flag(t)
    for _, flag in ipairs(t) do
        if flag == 'IsSpell' then
            return true
        end
    end
    return false
end

function has_flag(t, flag)
    for _, sflag in ipairs(t) do
        if flag == sflag then
            return true
        end
    end
    return false
end 

function has_spell(t, spellName)
    for sName, dType in pairs(t) do
        if sName == spellName then
            return true
        end
    end
    return false
end

function omit_flag(t, flag)
    local new_t = {}
    for _, sflag in ipairs(t) do
        if flag ~= sflag then
            new_t[#new_t + 1] = sflag
        end
    end
    return new_t
end