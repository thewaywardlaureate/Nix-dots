#!/usr/bin/env bash
check_dependencies() {
    if ! command -v rofi &>/dev/null; then
        echo "The 'rofi' package is not installed. Please install it before running this script."
        exit 1
    fi
    if ! command -v librewolf &>/dev/null; then
        echo "The 'librewolf' package is not installed. Please install it before running this script."
        exit 1
    fi
}
check_dependencies

clear

check_dependencies

options="NixOS 23.05\nNixOS 23.11\nNixOS unstable"

selected_option=$(echo -e "$options" | rofi -dmenu -p "Select an option" -lines 3 -width 20)

input=$(rofi -dmenu -p "Enter the name of the package")

case "$selected_option" in
    "NixOS 23.05")
        rofi -e "The channel you have selected is deprecated. Proceed with caution. Press 'Enter' to proceed"
        librewolf 'https://search.nixos.org/packages?channel=23.05&from=0&size=50&sort=relevance&type=packages&query='"$input"
        ;;
    "NixOS 23.11")
        librewolf 'https://search.nixos.org/packages?channel=23.11&from=0&size=50&sort=relevance&type=packages&query='"$input"
        ;;
    "NixOS unstable")
        rofi -e "The channel you have selected is unstable. Proceed with caution. Press 'Enter' to proceed" 
        librewolf 'https://search.nixos.org/packages?channel=unstable&show=nchat&from=0&size=50&sort=relevance&type=packages&query='"$input"
        ;;
    *)
        echo "Invalid option selected."
        ;;
esac

