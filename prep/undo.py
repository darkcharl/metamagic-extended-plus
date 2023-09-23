#!/usr/bin/env python

from metamod import *

src_path = "../PAK/Public/MetamagicExtendedPlus/Stats/Generated/Data/Spell_Metamagic.txt"
undo_path = "../PAK/Public/MetamagicExtendedPlus/Stats/Generated/Data/Spell_Metamagic_Undo.txt"

if __name__ == "__main__":
    opts = SpellFilterOptions()
    opts.path = src_path
    src_lib = SpellLibrary(opts)
    with open(undo_path, 'w+') as fd:
        for spell_name, v in src_lib.spell_map.items():
            if v.is_container():
                continue
            if not spell_name.find('_') == 0 and not spell_name.find("_Common") > -1:
                continue
            fd.write(v.to_text())
            fd.write('\n\n')
