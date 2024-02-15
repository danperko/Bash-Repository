#!/bin/bash

# Set the source directory as the current directory
sourceDir=$(pwd)

# Set the relative target directory
targetDir="../fotoExtract"

# Initialize counters
totalFiles=0
copiedFiles=0
noDateFiles=0

# Create the target directory if it doesn't exist
if [ ! -d "$targetDir" ]; then
    mkdir "$targetDir"
fi

# Enable case-insensitive globbing
shopt -s nocaseglob
shopt -s globstar

# Declare an associative array to track copied file names
declare -A copiedFileNames

# Iterate over specified file types
for ext in jpeg jpg png gif bmp avi mp4 mov; do
    # Iterate over all files with the current extension in the current directory and its subdirectories
    for file in "$sourceDir"/**/*."$ext"; do
        if [ -f "$file" ]; then
            totalFiles=$((totalFiles + 1))
        fi
    done
done

echo "Total number of image and video files found: $totalFiles"

# Iterate over specified file types again
for ext in jpeg jpg png gif bmp avi mp4 mov; do
    # Iterate over all files with the current extension in the current directory and its subdirectories
    for file in "$sourceDir"/**/*."$ext"; do
        if [ -f "$file" ]; then
            # Get the file name and its part without extension
            filename=$(basename -- "$file")
            filename_noext="${filename%.*}"

            # Initialize variables for year, month, and found_year flag
            year=""
            month=""
            day=""
            found_year=false

            # Iterate over the first four characters of the file name
            for (( i=0; i<${#filename_noext}; i++ )); do
                chunk="${filename_noext:$i:4}"
                # Check if the chunk is a four-digit number within the desired range
                if [[ "$chunk" =~ ^[0-9]{4}$ && "$chunk" -ge 1950 && "$chunk" -le $(date +'%Y') ]]; then
                    year="$chunk"
                    found_year=true
                    break
                fi
            done

            # If a valid year was found
            if [ "$found_year" = true ]; then
                # Iterate over the next two characters for the month
                for (( j=i+4; j<${#filename_noext}; j++ )); do
                    chunk="${filename_noext:$j:2}"
                    # Check if the chunk is a two-digit number
                    if [[ "$chunk" =~ ^[0-9]{2}$ ]]; then
                        month="$chunk"
                        break
                    fi
                done
            fi

            # If valid year and month were found
            if [ ! -z "$year" ] && [ ! -z "$month" ]; then
                # Create a target subdirectory path based on the year and month
                targetSubDir="$targetDir/$year/$month"
                if [ ! -d "$targetSubDir" ]; then
                    mkdir -p "$targetSubDir"
                fi

                # Check if the file name has already been copied to avoid duplicates
                if [ -z "${copiedFileNames[$filename]}" ]; then
                    # Copy the file to the target subdirectory
                    cp "$file" "$targetSubDir"
                    copiedFileNames[$filename]=1
                    copiedFiles=$((copiedFiles + 1))
                    echo "File $filename copied and pasted to $targetSubDir ($copiedFiles of $totalFiles)"
                fi
            else
                # If a valid year or month was not found, copy the file to the sinFecha folder
                targetSubDir="$targetDir/sinFecha"
                if [ -z "${copiedFileNames[$filename]}" ]; then
                    cp "$file" "$targetSubDir"
                    copiedFileNames[$filename]=1
                    noDateFiles=$((noDateFiles + 1))
                    echo "File $filename copied to $targetSubDir (Files without date: $noDateFiles)"
                fi
            fi
        fi
    done
done

echo "Process completed."
