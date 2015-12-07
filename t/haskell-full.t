#!/bin/bash
# vi: set ft=sh:
shopt -s extglob
. "${0%%+([!/])}/test-simple.sh" || exit 1


poly=${1:-'poly.poly'}

runhaskell="runhaskell"

note "checking $poly ..."

tmp="tmp-poly-$$.lhs"
ln -s "$poly" "$tmp"
trap "rm $tmp" EXIT INT TERM
for exts in ''{,-BangPatterns}{,-TemplateHaskell}{,-RebindableSyntax}{,-MagicHash}{,-OverloadedStrings}{,-NoMonomorphismRestriction}{,-ScopedTypeVariables}{,-CPP}{,-UnicodeSyntax}{,-NegativeLiterals}{,-BinaryLiterals}{,-NumDecimals}; do
    desc="${exts#-}"
    desc="${desc//-/, }"
    is "haskell${exts//[a-z]/}" "I'm a Literate Haskell program${desc:+ ($desc)}." "$runhaskell" ${exts//-/ -X} "$tmp"
done

done_testing
