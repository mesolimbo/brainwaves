#!/bin/bash

# Get the directory where the script is located
ProjectFileDir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run PICO-8 with the specified parameters
"C:\Program Files (x86)\PICO-8\pico8.exe" \
 -root_path "$ProjectFileDir"             \
 -home "$ProjectFileDir/.pico8"           \
 -run "$ProjectFileDir/cart.p8"           \
 -export "$ProjectFileDir/dist/index.html"
