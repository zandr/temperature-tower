#! /bin/sh

set -e

# paramsets contains the location of the OpenSCAD parameter sets.
# see https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Customizer#Saving_Parameters_value_in_JSON_file
paramsets=params.json

# run executes a program after printing the commandline to stdout.
run () {
    echo "=== $*"
    "$@"
}

# render turns OpenSCAD echo into 3mf temperature changes.
# 
# It does this by kludging together a PrusaSlicer-specific Metadata file.
render () {
    basename=$1; shift
    logfile=$basename.log
    run openscad -o $basename "$@" temp-tower.scad 2>&1 | tee $logfile

    rm -rf Metadata
    mkdir -p Metadata
    cat $logfile | while IFS=# read _ _ custom type path text _; do
        [ "$custom#$type" = "CUSTOM#3mf" ] || continue
        echo $text >> $path
    done

    run zip $basename $custom
    
    rm $custom $logfile
    rmdir Metadata
}

# paramsets lists all defined parameter sets, one per line.
paramsets () {
    cat $paramsets | jq -r '.parameterSets | keys[] | select(length > 0)'
}

case "$1" in
    -h|-help|--help)
        cat <<EOD
Usage: $0 [-paramsets] [PARAMSET ...]

Generates .3mf files with temperature changes
for each given parameter set.

Parameter sets are specified in $paramsets.

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
            render $paramset.3mf -P $paramset -p $paramsets
        done
        ;;
    *)
        for paramset in "$@"; do
            render $paramset.3mf -P $paramset -p $paramsets
        done
        ;;
esac
