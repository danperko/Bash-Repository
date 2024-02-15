#!/bin/bash

sourceDir="$PWD"

read -p "Enter the text to search for: " search_text
read -p "Enter the replacement text: " replace_text

echo -e "\nChosen options:"
echo "Search for: $search_text"
echo "Replace with: $replace_text"

read -p $'\nOptions:\n1. Confirm\n2. Enter data again\n3. Cancel\nChoose an option: ' choice

case $choice in
    1)
        for file in "$sourceDir"/*"$search_text"*; do
            if [ -f "$file" ]; then
                new_name="${file//$search_text/$replace_text}"
                if [ "$file" != "$new_name" ]; then
                    mv "$file" "$new_name"
                    echo "Renamed: $file -> $new_name"
                fi
            fi
        done
        echo "Process completed."
        ;;
    2)
        exec "$0" # Re-run this script to enter data again
        ;;
    3)
        echo "Process canceled."
        ;;
    *)
        echo "Invalid option."
        ;;
esac

