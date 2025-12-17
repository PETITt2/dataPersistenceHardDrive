#!/bin/bash

#ce script est fait pour peupler le disque dur d'un os afin de tester des outils de récupération de données. a la fin bien penser a prendr eune copie du fichier de log/md5 pour tester plus tard 
TOTAL_FILES=5000

# Racines des fichiers de test (recursif -> on peut modifier)
TARGET_ROOTS=(
    "$HOME/Documents"
    "$HOME/Bureau"
    "$HOME/Téléchargements"
    "$HOME/Images"
    "$HOME/Music/Projets_Audio"
    "/tmp/Recovery_Test_Zone"
    "/var/tmp/Cache_Simulation"
    "/opt/Archives_Test"
)

# Emplacement du rapport
LOG_FILE="$HOME/RAPPORT_MD5_$(date +%Y%m%d).csv"

# Dictionnaire de mots utilisé pour varier les mots
DICT="/usr/share/dict/words"

# fonction créer un PDF minimal
create_pdf() {
    local outfile="$1"
    local content="$2"
    cat <<_FIN_PDF_ > "$outfile"
%PDF-1.4
1 0 obj <</Type /Catalog /Pages 2 0 R>> endobj
2 0 obj <</Type /Pages /Kids [3 0 R] /Count 1>> endobj
3 0 obj <</Type /Page /MediaBox [0 0 595 842] /Parent 2 0 R /Resources <<>> /Contents 4 0 R>> endobj
4 0 obj <</Length 44>> stream
BT /F1 24 Tf 100 700 Td ($content) Tj ET
endstream
endobj
xref
0 5
0000000000 65535 f 
0000000010 00000 n 
0000000060 00000 n 
0000000157 00000 n 
0000000302 00000 n 
trailer <</Size 5 /Root 1 0 R>>
startxref
449
%%EOF
_FIN_PDF_
}

# JPEG
JPG_BASE="h/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAP//////////////////////////////////////////////////////////////////////////////////////wgALCAABAAEBAREA/8QAFBABAAAAAAAAAAAAAAAAAAAAAP/aAAgBAQABPxA="

# CSV de rapport
init_log() {
    echo "DATE_HEURE;NOM_FICHIER;CHEMIN_COMPLET;MD5_HASH" > "$LOG_FILE"
}

# Renvoie quelques mots aléatoires pour remplirles fichiers
get_random_words() {
    if [ -f "$DICT" ]; then
        local count=$((RANDOM % 80 + 20))
        shuf -n "$count" "$DICT" | tr '\n' ' '
    else
        echo "texte_simule"
    fi
}

echo "--- Début génération (script perso) ---"
echo "Fichier rapport: $LOG_FILE"

if [ ! -f "$DICT" ]; then
    echo "Note: dictionnaire introuvable, le script utilisera des textes simulés."
fi

init_log

count=0

# Création des dossiers cibles si nécessaire
for root in "${TARGET_ROOTS[@]}"; do
    mkdir -p "$root" 2>/dev/null
done

echo "Création de $TOTAL_FILES fichiers..."

for ((i=1; i<=TOTAL_FILES; i++)); do
    # Choix aléatoire du répertoire de destination
    rand_idx=$((RANDOM % ${#TARGET_ROOTS[@]}))
    base_dir=${TARGET_ROOTS[$rand_idx]}

    # Génération d'une arborescence aléatoire
    sub_depth=$((RANDOM % 3 + 1))
    sub_path=""
    for ((d=0; d<sub_depth; d++)); do
        if [ -f "$DICT" ]; then
            word=$(shuf -n 1 "$DICT" | tr -dc 'a-zA-Z0-9')
        else
            word="Dossier$RANDOM"
        fi
        sub_path="$sub_path/Rep_$word"
    done

    full_path="$base_dir$sub_path"
    mkdir -p "$full_path"

    # Type de fichier (texte, image, pdf)
    type_rand=$((RANDOM % 3))
    timestamp=$(date +%Y%m%d_%H%M%S)
    unique_id=$RANDOM

    case $type_rand in
        0)
            ext="txt"
            filename="Note_${timestamp}_${unique_id}.$ext"
            target_file="$full_path/$filename"
            for ((k=0; k<5; k++)); do
                get_random_words >> "$target_file"
                echo "" >> "$target_file"
            done
            ;;
        1)
            ext="jpg"
            filename="Image_${timestamp}_${unique_id}.$ext"
            target_file="$full_path/$filename"
            echo "$JPG_BASE" | base64 -d > "$target_file"
            echo "METADATA_CACHEE_$(get_random_words)" >> "$target_file"
            ;;
        2)
            ext="pdf"
            filename="Doc_${timestamp}_${unique_id}.$ext"
            target_file="$full_path/$filename"
            pdf_content="Preuve $unique_id. $(get_random_words)"
            create_pdf "$target_file" "$pdf_content"
            ;;
    esac

    # Calcul du MD5 et ajout au rapport
    hash=$(md5sum "$target_file" | awk '{print $1}')
    now=$(date "+%Y-%m-%d %H:%M:%S")
    echo "$now;$filename;$target_file;$hash" >> "$LOG_FILE"

    ((count++))
    echo -ne "Progression : $count / $TOTAL_FILES\r"
done

# S'assurer que tout est flushé sur disque
sync

echo -e "\n\n--- Terminé (script perso) ---"
echo "Rapport : $LOG_FILE"
echo "Conseil: sauvegardez ce rapport sur un support externe si nécessaire."
