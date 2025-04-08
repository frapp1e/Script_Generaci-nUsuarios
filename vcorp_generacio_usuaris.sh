#!/bin/bash

# Llistes de noms, cognoms, carrers i codis postals
NOMS=("Joan" "Maria" "Pau" "Sílvia" "Xavi" "Anna" "David" "Laura" "Carles" "Marta" "Jordi" "Cristina" "Raul" "Patricia" "Aleix" "Eva" "Pere" "Montse" "Ramon" "Lucia")
COGNOMS=("Pérez" "González" "López" "Martínez" "Rodríguez" "Hernández" "García" "Vázquez" "Sánchez" "Fernández" "Álvarez" "Jiménez" "Mendoza" "Díaz" "Torres" "Ruiz" "Moreno" "Ramírez" "Gil" "Castro")
CARRERS=("Carrer de la Pau 37" "Carrer Major 73" "Rambla Catalunya 64" "Carrer Nou 191" "Avinguda Catalunya 140" "Carrer del Sol 34" "Ronda Sant Pere 186" "Gran Via 84" "Carrer Major 178" "Ronda Sant Pere 93" "Plaça de la Vila 109" "Gran Via 6" "Avinguda Catalunya 17" "Plaça de la Vila 143" "Gran Via 32" "Carrer del Sol 193" "Ronda Sant Pere 117" "Rambla Catalunya 85" "Carrer Major 67" "Avinguda Catalunya 9")
CODI_POSTAL=("08001" "08002" "08003" "08004" "08005" "08006" "08007" "08008" "08009" "08010" "08011" "08012" "08013" "08014" "08015" "08016" "08017" "08018" "08019" "08020")

# Funcions auxiliars
generar_telefon() {
    echo "+34 6$(shuf -i 100000000-999999999 -n 1)"
}

generar_data_naixement() {
    echo $(shuf -i 1965-2002 -n 1)-$(shuf -i 01-12 -n 1)-$(shuf -i 01-31 -n 1)
}

# Distribució corregida (sense caràcters especials en noms de variables)
declare -a DISTRIBUCIO=(
    "Staff:Conserge:4"
    "Staff:Tècnic de manteniment:3"
    "Produccio:Programador:10"
    "Produccio:Analista:12"
    "Produccio:Cap d'equip:8"
    "Produccio:Cap de projecte:6"
    "Comercial:Comercial:10"
    "Comercial:Responsable de vendes:4"
    "Comercial:Gerent:1"
    "Marketing:Especialista SEO:3"
    "Marketing:Dissenyador grafic:3"
    "Marketing:Community Manager:3"
    "Marketing:Cap de marketing:1"
    "Direccio:CEO:1"
    "Direccio:CIO:1"
    "Direccio:CMO:1"
    "Direccio:COO:1"
    "Direccio:CFO:1"
    "Sistemes:Tècnic de sistemes:5"
    "Sistemes:Coordinador de sistemes:1"
    "Gestio:Comptable:1"
    "Gestio:Gestor financer:2"
    "Gestio:Gestor de RRHH:2"
    "Gestio:Cap de gestio:1"
    "Gestio:Assessor legal:1"
)

# Calcula el total d'empleats
TOTAL_EMPLEATS=0
for entrada in "${DISTRIBUCIO[@]}"; do
    IFS=':' read -r _ _ quantitat <<< "$entrada"
    TOTAL_EMPLEATS=$((TOTAL_EMPLEATS + quantitat))
done

# Genera IDs únics
mapfile -t IDS < <(shuf -i 1000-9999 -n $TOTAL_EMPLEATS)
idx=0

# Genera dades d'empleats
declare -a EMPLEATS=()
for entrada in "${DISTRIBUCIO[@]}"; do
    IFS=':' read -r dept carrec quantitat <<< "$entrada"
    for ((i=1; i<=quantitat; i++)); do
        id="EMP${IDS[$idx]}"
        nom=${NOMS[$RANDOM % ${#NOMS[@]}]}
        cognom=${COGNOMS[$RANDOM % ${#COGNOMS[@]}]}
        telefon=$(generar_telefon)
        data=$(generar_data_naixement)
        adreca=${CARRERS[$RANDOM % ${#CARRERS[@]}]}
        cp=${CODI_POSTAL[$RANDOM % ${#CODI_POSTAL[@]}]}
        
        EMPLEATS+=("$id,$nom,$cognom,$dept,$carrec,$telefon,$data,$adreca,$cp")
        ((idx++))
    done
done

# Escriu el CSV
CSV_FILE="vcorp_usuaris.csv"
echo "ID Empleat,Nom,Cognom,Departament,Carrec,Telefon,Data de naixement,Adreca,Codi Postal" > "$CSV_FILE"
printf "%s\n" "${EMPLEATS[@]}" | shuf >> "$CSV_FILE"

echo "Fitxer $CSV_FILE generat correctament amb $TOTAL_EMPLEATS empleats."