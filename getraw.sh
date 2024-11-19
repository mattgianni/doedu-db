#!/usr/bin/env bash

RAW_DIR=raw
if [ ! -d $RAW_DIR ]; then
    mkdir $RAW_DIR
fi

if [ ! -f $RAW_DIR/sb_ca2024_all_csv_v1.txt ]; then
    curl -Lo $RAW_DIR/sb_ca2024_all_csv_v1.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/sb_ca2024_all_csv_v1.zip
    unzip $RAW_DIR/sb_ca2024_all_csv_v1.zip -d $RAW_DIR && rm $RAW_DIR/sb_ca2024_all_csv_v1.zip
fi

if [ ! -f $RAW_DIR/Tests.txt ]; then
    curl -Lo $RAW_DIR/Tests.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/Tests.zip
    unzip $RAW_DIR/Tests.zip -d $RAW_DIR && rm $RAW_DIR/Tests.zip
fi

if [ ! -f $RAW_DIR/StudentGroups.txt ]; then
    curl -Lo $RAW_DIR/StudentGroups.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/StudentGroups.zip
    unzip $RAW_DIR/StudentGroups.zip -d $RAW_DIR && rm $RAW_DIR/StudentGroups.zip
fi

# convert the file to a properly formatted utf-8 standard and convert '*' to ''
iconv -f utf-8 -t utf-8 -c $RAW_DIR/sb_ca2024_all_csv_v1.txt | sed 's/\*//g' > $RAW_DIR/scores.txt
