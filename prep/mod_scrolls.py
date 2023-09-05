#!/usr/bin/env python

import re
from pathlib import Path

enabled_spells = []
mod_sources = [
 #"../../../Source/Shared_PAK/Public/Shared/RootTemplates",
 #"../../../Source/Gustav_PAK/Public/Gustav/RootTemplates",
 #"../../../Source/Gustav_PAK/Public/GustavDev/RootTemplates",
 "../../secret-scrolls/PAK/Public/SecretScrolls/RootTemplates",
 "../../omniscient-wizards/PAK/Public/OmniscientWizards/RootTemplates",
]

def load_enabled_spells(enabled_file="enabled_spells.txt"):
    enabled_spells = {}
    with open(enabled_file, 'r') as f:
        for spell_name in f.read().splitlines():
            if spell_name.startswith('#'):
                """ Comment, ignore """
                continue
            enabled_spells[spell_name] = True
    return enabled_spells


def find_files(spells_re, src='.'):
    found_files = []
    for file in Path(src).iterdir():
        if not file.is_file():
            continue
        with file.open(encoding='latin1') as f:
            if re.search(spells_re, f.read()):
                found_files.append(file)
    return found_files


def load_spells_re():
    enabled_spells = load_enabled_spells()
    match_re = re.compile(f'id="(S[kp][ei]llI[dD])" type="FixedString" value="({"|".join(enabled_spells)})"')
    repl_re = r'id="\1" type="FixedString" value="\2_Original"'
    return match_re, repl_re
    

def get_dst_path(file):
    mod_dir = str(file).split('/')[-3]
    return Path(f'modded_scrolls/{mod_dir}/{file.name}')


def modify_object(src_file, dst_file, match_re, repl_re):
    with src_file.open(encoding='latin1') as src, dst_file.open('w') as dst:
        for line in src.readlines():
            dst.write(re.sub(match_re, repl_re, line))


if __name__ == "__main__":
    match_re, repl_re = load_spells_re()
    for mod in mod_sources:
        for src in find_files(src=mod, spells_re=match_re):
            print(f' [<] {src}')
            dst = get_dst_path(src)
            modify_object(src, get_dst_path(src), match_re, repl_re)
            print(f' [>] {dst}\n')
            