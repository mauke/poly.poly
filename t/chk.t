#!/bin/sh

plan() {
	echo "1..$1"
	TestCounter=0
}

diag() {
	echo "# $@"
}

ok() {
	local d="$1"
	shift
	let TestCounter++
	local p=""
	"$@" || p="not "
	echo "${p}ok $TestCounter - $d"
	[ X = X"$p" ]
}

is() {
	local d="$1"
	shift
	local s="$1"
	shift
	local o="$("$@")"
	if ! ok "$d" [ X"$s" = X"$o" ]; then
		diag "expected: \"$s\""
		diag "got:      \"$o\""
	fi
}

like() {
	local d="$1"
	shift
	local s="$1"
	shift
	local o="$("$@")"
	if [[ X$o = X$s ]]; then
		ok "$d" true
	else
		ok "$d" false
		diag "expected: \"$s\""
		diag "got:      \"$o\""
	fi
}

compile() {
	local e="tmp-$$"
	"$@" -o "$e" || return $?
	trap "rm '$e'" RETURN
	./"$e"
}


poly=${1:-'poly.poly'}


perl6="$HOME/src/rakudo/rakudo-star-2013.05/perl6"
whitespace="$HOME/prog/c/whitespace/whitespace"
bf="bfi"
sh="busybox sh"



plan 20
diag "checking $poly ..."

is sh "I'm a sh script." $sh "$poly"
is zsh "I'm a zsh script." zsh "$poly"
is bash "I'm a bash script." bash "$poly"
is perl "I'm a Perl program." perl "$poly"
like python2 "I'm a Python program (* 2.*)." python "$poly"
like python3 "I'm a Python program (* 3.*)." python3 "$poly"
is tcl "I'm a tcl script." tclsh "$poly"
is brainfuck "I'm a brainfuck program." $bf "$poly"
tmp="tmp-poly-$$.lhs"
ln -s "$poly" "$tmp"
is haskell       "I'm a Literate Haskell program (BangPatterns disabled; TemplateHaskell disabled)." runhaskell "$tmp"
is haskell-bp    "I'm a Literate Haskell program (BangPatterns enabled; TemplateHaskell disabled)."  runhaskell -XBangPatterns "$tmp"
is haskell-th    "I'm a Literate Haskell program (BangPatterns disabled; TemplateHaskell enabled)."  runhaskell -XTemplateHaskell "$tmp"
is haskell-bp-th "I'm a Literate Haskell program (BangPatterns enabled; TemplateHaskell enabled)."   runhaskell -XBangPatterns -XTemplateHaskell "$tmp"
rm "$tmp"
is c   "I'm a C program (C89 with // comments, trigraphs disabled)." compile gcc -Wno-trigraphs -Wno-unused -xc "$poly"
is c89 "I'm a C program (C89, trigraphs enabled)."                   compile gcc -std=c89 -pedantic -W -Wall -Wno-trigraphs -Wno-unused -xc "$poly"
is c99 "I'm a C program (C99, trigraphs enabled)."                   compile gcc -std=c99 -pedantic -W -Wall -Wno-trigraphs -Wno-unused -xc "$poly"
is c++ "I'm a C++ program (trigraphs disabled)."                     compile g++ -Wno-trigraphs -xc++ "$poly"
is ruby "I'm a Ruby program." ruby "$poly"
is whitespace "I'm a whitespace program." "$whitespace" "$poly"
is make "I'm a Makefile." make -f "$poly"
is perl6 "I'm a Perl6 program." "$perl6" "$poly"
