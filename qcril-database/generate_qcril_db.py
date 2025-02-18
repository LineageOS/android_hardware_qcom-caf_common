#!/usr/bin/env python3
#
# Copyright (C) 2024-2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#


import os
import re
import subprocess
import sys


def version_prefix(file_path):
    basename = os.path.basename(file_path)
    match = re.match(r'(\d+(\.\d+)?)', basename)
    if match:
        # Split the subversion
        return [int(part) for part in match.group(0).split('.')]
    return []


def main():
    if len(sys.argv) <= 3:
        print(
            'syntax: generate_qcril_db.py sqlite3 target_db sql_file0 sql_file1...'
        )
        sys.exit(1)

    sqlite_path = sys.argv[1]
    if not os.path.isfile(sqlite_path) or not os.access(sqlite_path, os.X_OK):
        print(f'sqlite binary not found or not executable: {sqlite_path}')
        sys.exit(1)

    target_db = sys.argv[2]
    if os.path.exists(target_db):
        os.remove(target_db)

    sql_files = sys.argv[3:]

    # Split the config sql and ecc sql files
    config_sql_files = []
    ecc_sql_files = []
    for file in sql_files:
        if file.endswith('_config.sql'):
            config_sql_files.append(file)
        else:
            ecc_sql_files.append(file)

    # Sort the files
    config_sql_files.sort(key=version_prefix)
    ecc_sql_files.sort(key=version_prefix)

    # Config migrations should be applied after ecc migrations
    ordered_migrations = ecc_sql_files + config_sql_files

    # Begin transaction and execute SQL files
    with subprocess.Popen(
        [sqlite_path, target_db], stdin=subprocess.PIPE, text=True
    ) as proc:
        proc.stdin.write('BEGIN TRANSACTION;\n')
        for file in ordered_migrations:
            with open(file, 'r') as sql_file:
                proc.stdin.write(sql_file.read() + '\n')
        proc.stdin.write('COMMIT TRANSACTION;\n')
        proc.stdin.close()
        proc.wait()


if __name__ == '__main__':
    main()
