#!/bin/bash
#
# Copyright (C) 2024-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

set -e

if [[ $# -le 2 ]]; then
    echo "syntax: generate_qcril_db.sh sqlite3 target_db sql_file0 sql_file1..."
    exit 1
fi

SQLITE=$1
if [[ ! -x "$SQLITE" ]]; then
    echo "sqlite binary not found or not executable: $SQLITE"
    exit 1
fi

TARGET_DB=$2

shift 2

# Split the config sql and ecc sql files
for file in "$@"; do
    if [[ $file == *_config.sql ]]; then
        CONFIG_SQL_FILES+=("$file")
    else
        ECC_SQL_FILES+=("$file")
    fi
done

# Sort the files
readarray -t CONFIG_SQL_FILES < <(printf "%s\n" "${CONFIG_SQL_FILES[@]}" | sort -V)
readarray -t ECC_SQL_FILES < <(printf "%s\n" "${ECC_SQL_FILES[@]}" | sort -V)

# Config migrations should be applied after ecc migrations
ORDERED_MIGRATIONS=("${ECC_SQL_FILES[@]}" "${CONFIG_SQL_FILES[@]}")

rm -f "$TARGET_DB"
{
    echo "BEGIN TRANSACTION;"
    for file in "${ORDERED_MIGRATIONS[@]}"; do
        cat "$file"
    done
    echo "COMMIT TRANSACTION;"
} | "$SQLITE" "$TARGET_DB"
