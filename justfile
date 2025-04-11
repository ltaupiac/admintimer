SPOON_NAME := "AdminTimer.spoon"

default:
    just --summary

clean:
    @echo "🧹 Suppression de l'archive précédente"
    @rm -f Spoons/{{SPOON_NAME}}.zip

zip: clean
    @echo "📦 Création de l'archive Spoons/{{SPOON_NAME}}.zip depuis Sources/{{SPOON_NAME}}..."
    @mkdir -p Spoons
    @cd Sources/ && zip -r ../Spoons/{{SPOON_NAME}}.zip {{SPOON_NAME}} > /dev/null
    @echo "✅ Archive créée : Spoons/{{SPOON_NAME}}.zip"

check:
    @unzip -l Spoons/{{SPOON_NAME}}.zip
