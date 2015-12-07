plan() {
    echo "1..$1"
    TestCounter=0
}

done_testing() {
    echo "1..$TestCounter"
}

note() {
    echo "# $@"
}

diag() {
    echo "# $@" >&2
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
