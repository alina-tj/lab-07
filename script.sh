#!/usr/bin/env bash

for tc in {1..4}; do
    src="Testcase${tc}"
    diff_dir="Testcase${tc}Diff"
    rm -rf "$diff_dir"

    for f1 in "$src"/*.1.txt; do
        [ -f "$f1" ] || continue
        f2="${f1/.1.txt/.2.txt}"
        base=$(basename "$f1" .1.txt)

        if [ -f "$f2" ] && ! cmp -s "$f1" "$f2"; then
            mkdir -p "$diff_dir"
            diff -u "$f1" "$f2" > "${diff_dir}/${base}Diff.txt"
        fi
    done
done
