#!/usr/bin/env bash

RAW_DIR=raw
if [ ! -d $RAW_DIR ]; then
    mkdir $RAW_DIR
fi

if [ ! -f $RAW_DIR/sb_ca2024_all_csv_v1.zip ]; then
    curl -Lo $RAW_DIR/sb_ca2024_all_csv_v1.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/sb_ca2024_all_csv_v1.zip
fi

if [ ! -f $RAW_DIR/Tests.zip ]; then
    curl -Lo $RAW_DIR/Tests.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/Tests.zip
fi

if [ ! -f $RAW_DIR/StudentGroups.zip ]; then
    curl -Lo $RAW_DIR/StudentGroups.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/StudentGroups.zip
fi

# uncompressed the zip files
unzip $RAW_DIR/sb_ca2024_all_csv_v1.zip -d $RAW_DIR && rm $RAW_DIR/sb_ca2024_all_csv_v1.zip
unzip $RAW_DIR/Tests.zip -d $RAW_DIR && rm $RAW_DIR/Tests.zip
unzip $RAW_DIR/StudentGroups.zip -d $RAW_DIR && rm $RAW_DIR/StudentGroups.zip
