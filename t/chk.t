#!/bin/bash
# vi: set ft=sh:
shopt -s extglob
. "${0%%+([!/])}/test-simple.sh" || exit 1


poly=${1:-'poly.poly'}

runhaskell="runhaskell"
perl6="$HOME/src/rakudo-star-2015.11/perl6"
whitespace="$HOME/prog/c/whitespace/whitespace"
bf="bfi"
sh="busybox sh"


note "checking $poly ..."
plan 18

is sh "I'm a sh script." $sh "$poly"
is zsh "I'm a zsh script." zsh "$poly"
is bash "I'm a bash script." bash "$poly"
is perl "I'm a Perl program." perl "$poly"
like python2 "I'm a Python program (* 2.*)." python2 "$poly"
like python3 "I'm a Python program (* 3.*)." python3 "$poly"
is tcl "I'm a tcl script." tclsh "$poly"
is brainfuck "I'm a brainfuck program." $bf "$poly"
is c   "I'm a C program (C89 with // comments, trigraphs disabled)." compile gcc -std=gnu89 -Wno-trigraphs -Wno-unused -xc "$poly"
is c89 "I'm a C program (C89, trigraphs enabled)."                   compile gcc -std=c89 -pedantic -W -Wall -Wno-trigraphs -Wno-unused -xc "$poly"
is c99 "I'm a C program (C99, trigraphs enabled)."                   compile gcc -std=c99 -pedantic -W -Wall -Wno-trigraphs -Wno-unused -xc "$poly"
is c++ "I'm a C++ program (trigraphs disabled)."                     compile g++ -Wno-trigraphs -xc++ "$poly"
is ruby "I'm a Ruby program." ruby "$poly"
is whitespace "I'm a whitespace program." "$whitespace" "$poly"
is make "I'm a Makefile." make -f "$poly"
is perl6 "I'm a Perl6 program." "$perl6" "$poly"
tmp="tmp-poly-$$.lhs"
ln -s "$poly" "$tmp"
for exts in ''{,-BangPatterns-TemplateHaskell-RebindableSyntax-MagicHash-OverloadedStrings-NoMonomorphismRestriction-ScopedTypeVariables-CPP-UnicodeSyntax}; do
    desc="${exts#-}"
    desc="${desc//-/, }"
    is "haskell${exts//[a-z]/}" "I'm a Literate Haskell program${desc:+ ($desc)}." "$runhaskell" ${exts//-/ -X} "$tmp"
done
rm "$tmp"
