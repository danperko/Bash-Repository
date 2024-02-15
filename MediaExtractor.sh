#!/bin/bash

# Establecer el directorio fuente como el directorio actual
sourceDir=$(pwd)

# Establecer el directorio de destino relativo
targetDir="../fotoExtract"

# Inicializar contadores
totalFiles=0
copiedFiles=0
noDateFiles=0

# Crear el directorio de destino si no existe
if [ ! -d "$targetDir" ]; then
    mkdir "$targetDir"
fi

# Habilitar la búsqueda sin distinción entre mayúsculas y minúsculas
shopt -s nocaseglob
shopt -s globstar

# Declarar un array asociativo para realizar un seguimiento de los nombres de archivo copiados
declare -A copiedFileNames

# Recorrer los tipos de archivo especificados
for ext in jpeg jpg png gif bmp avi mp4 mov; do
    # Recorrer todos los archivos con la extensión actual en el directorio actual y sus subdirectorios
    for file in "$sourceDir"/**/*."$ext"; do
        if [ -f "$file" ]; then
            totalFiles=$((totalFiles + 1))
        fi
    done
done

echo "Número total de archivos de imagen y video encontrados: $totalFiles"

# Recorrer nuevamente los tipos de archivo especificados
for ext in jpeg jpg png gif bmp avi mp4 mov; do
    # Recorrer todos los archivos con la extensión actual en el directorio actual y sus subdirectorios
    for file in "$sourceDir"/**/*."$ext"; do
        if [ -f "$file" ]; then
            # Obtener el nombre de archivo y su parte sin extensión
            filename=$(basename -- "$file")
            filename_noext="${filename%.*}"

            # Inicializar variables para el año, mes y bandera de año encontrado
            year=""
            month=""
            day=""
            found_year=false

            # Recorrer los primeros cuatro caracteres del nombre del archivo
            for (( i=0; i<${#filename_noext}; i++ )); do
                chunk="${filename_noext:$i:4}"
                # Verificar si el chunk es un número de cuatro dígitos y está en el rango deseado
                if [[ "$chunk" =~ ^[0-9]{4}$ && "$chunk" -ge 1950 && "$chunk" -le $(date +'%Y') ]]; then
                    year="$chunk"
                    found_year=true
                    break
                fi
            done

            # Si se encontró un año válido
            if [ "$found_year" = true ]; then
                # Recorrer los siguientes dos caracteres para el mes
                for (( j=i+4; j<${#filename_noext}; j++ )); do
                    chunk="${filename_noext:$j:2}"
                    # Verificar si el chunk es un número de dos dígitos
                    if [[ "$chunk" =~ ^[0-9]{2}$ ]]; then
                        month="$chunk"
                        break
                    fi
                done
            fi

            # Si se encontraron un año y un mes válidos
            if [ ! -z "$year" ] && [ ! -z "$month" ]; then
                # Crear una ruta de subdirectorio objetivo basada en el año y el mes
                targetSubDir="$targetDir/$year/$month"
                if [ ! -d "$targetSubDir" ]; then
                    mkdir -p "$targetSubDir"
                fi

                # Verificar si el nombre de archivo ya se ha copiado para evitar duplicados
                if [ -z "${copiedFileNames[$filename]}" ]; then
                    # Copiar el archivo al subdirectorio de destino
                    cp "$file" "$targetSubDir"
                    copiedFileNames[$filename]=1
                    copiedFiles=$((copiedFiles + 1))
                    echo "Archivo $filename copiado y pegado en $targetSubDir ($copiedFiles de $totalFiles)"
                fi
            else
                # Si no se encontró un año o un mes válidos, copiar el archivo a la carpeta sinFecha
                targetSubDir="$targetDir/sinFecha"
                if [ -z "${copiedFileNames[$filename]}" ]; then
                    cp "$file" "$targetSubDir"
                    copiedFileNames[$filename]=1
                    noDateFiles=$((noDateFiles + 1))
                    echo "Archivo $filename copiado en $targetSubDir (Archivos sin fecha: $noDateFiles)"
                fi
            fi
        fi
    done
done

echo "Proceso completado."
