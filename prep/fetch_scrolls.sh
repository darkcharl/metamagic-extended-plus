#!/usr/bin/env bash

SOURCES=(
 "../../../Source/Shared_PAK/Public/Shared/RootTemplates"
  
 "../../../Source/Gustav_PAK/Public/Gustav/RootTemplates"
 "../../../Source/Gustav_PAK/Public/GustavDev/RootTemplates"
 "../../SecretScrolls/PAK/Public/SecretScrolls/RootTemplates"
 "../../OmniscientWizards/PAK/Public/OmniscientWizards/RootTemplates"
)

rm modded_scrolls/*/*

for SRCDIR in "${SOURCES[@]}"; do
  ORIGIN=$(echo "${SRCDIR}" | awk -F '/' '{ print $(NF-1)}')
  DSTDIR="modded_scrolls/${ORIGIN}"
  [ ! -d "${DSTDIR}" ] && mkdir "${DSTDIR}"
  echo "${SRCDIR} -> ${DSTDIR}"
  
  SCROLL_FILES=$(grep -rl 'id="Stats" type="FixedString" value="OBJ_Scroll_' "${SRCDIR}"/*.lsx)
  for SCROLL in $SCROLL_FILES; do
    NAME=${SCROLL##*/}
    IS_INSTRUMENTED=$(grep -cf enabled_spells.txt "$SCROLL")
    [ "${IS_INSTRUMENTED}" -eq 0 ] && continue
    
    cp "${SCROLL}" "${DSTDIR}/${NAME}"
    # sed 's#\(id="(Spell|Skill)Id" type="FixedString" value="[^"]+\)"#\1_Original"#i' "${SCROLL}" > "${DSTDIR}/${NAME}"
  done
done
