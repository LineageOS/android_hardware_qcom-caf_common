import os
import sys
import xml.etree.ElementTree as ET

# Проверяем, передан ли путь
if len(sys.argv) < 2:
    print("Использование: python script.py ПУТЬ_К_ПАПКЕ")
    sys.exit(1)

folder_path = sys.argv[1]

if not os.path.isdir(folder_path):
    print("Указанная папка не существует")
    sys.exit(1)

names = []

for root_dir, _, files in os.walk(folder_path):
    for filename in files:
        if filename.lower().endswith(".xml"):
            file_path = os.path.join(root_dir, filename)
            try:
                tree = ET.parse(file_path)
                root = tree.getroot()

                for elem in root.iter():
                    if "name" in elem.attrib:
                        names.append(elem.attrib["name"])

            except Exception as e:
                print(f"Ошибка в {file_path}: {e}")

for name in sorted(set(names)):
    print(name)
