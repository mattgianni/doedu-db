#!/usr/bin/env bash

RAW_DIR=./raw
if [ ! -d ${RAW_DIR} ]; then
    echo "Raw data directory \"${RAW_DIR}\" does not exist. Creating..."
    mkdir ${RAW_DIR}
fi

if [ ! -f ${RAW_DIR}/sb_ca2024_all_csv_v1.txt ]; then
    echo "${RAW_DIR}/sb_ca2024_all_csv_v1.txt is missing. Downloading..."
    curl -Lo ${RAW_DIR}/sb_ca2024_all_csv_v1.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/sb_ca2024_all_csv_v1.zip
    unzip ${RAW_DIR}/sb_ca2024_all_csv_v1.zip -d ${RAW_DIR} && rm ${RAW_DIR}/sb_ca2024_all_csv_v1.zip
fi

if [ ! -f ${RAW_DIR}/Tests.txt ]; then
    echo "${RAW_DIR}/Tests.txt is missing. Downloading..."
    curl -Lo ${RAW_DIR}/Tests.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/Tests.zip
    unzip ${RAW_DIR}/Tests.zip -d ${RAW_DIR} && rm ${RAW_DIR}/Tests.zip
fi

if [ ! -f ${RAW_DIR}/StudentGroups.txt ]; then
    echo "${RAW_DIR}/StudentGroups.txt is missing. Downloading..."
    curl -Lo ${RAW_DIR}/StudentGroups.zip https://caaspp-elpac.ets.org/caaspp/researchfiles/StudentGroups.zip
    unzip ${RAW_DIR}/StudentGroups.zip -d ${RAW_DIR} && rm ${RAW_DIR}/StudentGroups.zip
fi

if [ ! -f ${RAW_DIR}/fycgr24.txt ]; then
    echo "${RAW_DIR}/fycgr24.txt is missing. Downloading..."
    curl -Lo ${RAW_DIR}/fycgr24.txt https://www3.cde.ca.gov/demo-downloads/fycgr/fycgr24.txt
fi

# convert the file to a properly formatted utf-8 standard and convert '*' to ''
echo "Preparing data files..."
iconv -f utf-8 -t utf-8 -c ${RAW_DIR}/sb_ca2024_all_csv_v1.txt | sed 's/\*//g' > ${RAW_DIR}/scores.dat
iconv -f utf-8 -t utf-8 -c ${RAW_DIR}/sb_ca2024entities_csv.txt | sed 's/\*//g' > ${RAW_DIR}/entities.dat
iconv -f utf-8 -t utf-8 -c ${RAW_DIR}/StudentGroups.txt | sed 's/\*//g' > ${RAW_DIR}/demographics.dat
iconv -f utf-8 -t utf-8 -c ${RAW_DIR}/Tests.txt | sed 's/\*//g' > ${RAW_DIR}/tests.dat
iconv -f utf-8 -t utf-8 -c ${RAW_DIR}/fycgr24.txt | sed 's/\*//g' | sed 's/\t/^/g' > ${RAW_DIR}/fycgr24.dat

echo "Done."