#! /bin/sh

## Postprocess a 3mf file, adding in anything in the log

set -e

outfile=$(realpath)/$1
infile=$(realpath $2)
logfile=$(realpath $3)

tmpdir=$(mktemp -d --tmpdir 3mf.XXXXXXXXXX)
trap "rm -rf $tmpdir" EXIT

(cd $tmpdir && unzip $infile)

cat $logfile | while IFS=# read _ _ custom type path text _; do
    [ "$custom#$type" = "CUSTOM#3mf" ] || continue
    basepath=$(dirname $path)
    mkdir -p $tmpdir/$basepath
    echo $text >> $tmpdir/$path
done

(cd $tmpdir && zip -r $outfile .)
