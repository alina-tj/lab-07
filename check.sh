#!/usr/bin/env bash

overall=0

for tc in {1..4}; do
    src="Testcase${tc}"
    diff_dir="Testcase${tc}Diff"
    pass=true
    has_diffs=false

    for f1 in "$src"/*.1.txt; do
        [ -f "$f1" ] || continue
        f2="${f1/.1.txt/.2.txt}"
        out="${diff_dir}/$(basename "$f1" .1.txt)Diff.txt"
        if [ -f "$f2" ]; then
            if ! cmp -s "$f1" "$f2"; then
                has_diffs=true
                # Must exist and match actual diff (ignoring line 1-2 timestamps)
                if [ ! -f "$out" ] || [ "$(diff -u "$f1" "$f2" | tail -n +3)" != "$(tail -n +3 "$out" 2>/dev/null)" ]; then
                    pass=false
                fi
            elif [ -f "$out" ]; then
                pass=false # Should not exist for matching files
            fi
        fi
    done

    # Check directory existence rules
    if { [ "$has_diffs" = true ] && [ ! -d "$diff_dir" ]; } || { [ "$has_diffs" = false ] && [ -d "$diff_dir" ]; }; then
        pass=false
    fi

    if [ "$pass" = true ]; then
        echo "Testcase${tc}: PASS"
    else
        echo "Testcase${tc}: FAIL"
        overall=1
    fi
done
exit $overall
