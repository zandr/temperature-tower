#! /bin/sh

set -e

builddefs=params.json

run () {
    echo "=== $*"
    "$@"
}

render () {
    basename=$1; shift
    run openscad -o $basename "$@" temp-tower.scad 2>&1 | tee $basename.log

    mkdir -p Metadata
    custom=Metadata/Prusa_Slicer_custom_gcode_per_print_z.xml
    (
        echo '<?xml version="1.0" encoding="utf-8"?>'
        echo '<custom_gcodes_per_print_z>'
        sed -n 's/ECHO: "CUSTOM##\(.*\)"/\1/p' $basename.log
        echo '<mode value="SingleExtruder"/>'
        echo '</custom_gcodes_per_print_z>'
    ) > $custom
    run zip $basename $custom
    
    rm $custom $basename.log
    rmdir Metadata
}

paramsets () {
    cat $builddefs | jq -r '.parameterSets | keys[] | select(length > 0)'
}

case "$1" in
    -h|-help|--help)
        cat <<EOD
Usage $0 [-paramsets] [PARAMSET ...]

Generates .3mf files with temperature changes
for each given parameter set.

Parameter sets are specified in $builddefs.

-paramsets   List all defined parameter sets, and exit.
EOD
        exit 1
        ;; 
    -p*|--p*)
        paramsets
        exit
        ;;
    "")
        paramsets | while read paramset; do
            render $paramset.3mf -P $paramset -p $builddefs
        done
        ;;
    *)
        for paramset in "$@"; do
            render $paramset.3mf -P $paramset -p $builddefs
        done
        ;;
esac
