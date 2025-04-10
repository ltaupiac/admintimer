SPOON_NAME := "AdminTimer.spoon"
ZIP_NAME := "Spoons/AdminTimer.spoon.zip"
TMP_DIR := "build_tmp"
SOURCES := "Sources"

default:
    just --summary

clean:
    @echo "Cleaning old archive"
    @rm -f {{ZIP_NAME}}
    @rm -rf {{TMP_DIR}}

zip: clean
    @echo "→ Création de l'archive {{ZIP_NAME}}..."
    @mkdir -p {{TMP_DIR}}/{{SPOON_NAME}}
    @cp {{SOURCES}}/init.lua {{SOURCES}}/SpoonManifest.lua {{TMP_DIR}}/{{SPOON_NAME}}/
    @cd {{TMP_DIR}} && zip -r ../{{ZIP_NAME}} {{SPOON_NAME}} > /dev/null
    @rm -rf {{TMP_DIR}}
    @echo "✅ Archive prête : {{ZIP_NAME}}"

check:
    @unzip -l {{ZIP_NAME}}
