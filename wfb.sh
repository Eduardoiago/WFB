#!/bin/bash

###################################
# Script Name        :WFB
# Author             :Eduardo Iago
# Version            :1.0.0
###################################

GOLD='\033[0;33m'
END='\033[0m'

menu() {
	echo " "
	echo -e "${GOLD}   ██╗    ██╗███████╗██████╗    ███████╗██╗  ██╗"
	echo -e "   ██║    ██║██╔════╝██╔══██╗   ██╔════╝██║  ██║"
	echo -e "   ██║ █╗ ██║█████╗  ██████╔╝   ███████╗███████║"
	echo -e "   ██║███╗██║██╔══╝  ██╔══██╗   ╚════██║██╔══██║"
	echo -e "   ╚███╔███╔╝██║     ██████╔╝██╗███████║██║  ██║"
	echo -e "    ╚══╝╚══╝ ╚═╝     ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝"
	echo " "
	echo -e "                       wfb.sh | version 1.0.0"
	echo -e "   =============================================${END}"
	echo -e "   1. File Encryption"
	echo -e "   2. Decrypt File"
	echo -e "   3. Directory Encryption"
	echo -e "   4. Decrypt Directory"
	echo -e "   x. Exit"
	echo " "
}

LOG='wfb.log' # Gerar arquivo .log

success_msg() {
	echo -e "${GOLD}$1${END}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - SUCCESS: $1" >> $LOG
}

error_msg() {
	echo -e "${GOLD}$1${END}"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - ERROR: $1" >> $LOG
}

existence() {
	if [ ! -e "$1" ]; then
		error_message "The PATH provided does not exist: $1"
		exit 1
	fi
}

info() {
	echo " "
	echo -e "${GOLD}================================"
	echo -e "               WFB.SH"
	echo -e "================================"
	echo -e "Github: https://github.com/Eduardoiago"
	echo -e "Developed by Eduardo Iago"
	echo -e "Version 1.0.0${END}"
	echo " "
	echo -e "Shell script to protect important files and even directories with confidential files. Files and directories are encrypted with OpenSSL using AES | SHA-256."
	echo " "
	read -p "Press ENTER to return to the Menu." menu
}

encrypt_file() {
	echo " "
	echo "                ENCRYPT FILE"
	echo "============================="
	read -p "Select the file PATH: " file
	existence "$file"
	read -sp "Enter the password: " password
	echo " "
	openssl enc -aes-256-cbc -salt -in "$file" -out "$file.wfb" -pass pass:"$password"
	if [ $? -eq 0 ]; then
        	success_msg "Encrypted successfully file: $file.wfb"
        else
        	error_msg "Error encrypting the file."
    	fi
	read -p "Press ENTER to return to the menu." menu
}

decrypt_file() {
    	echo " "
    	echo "                 DECRYPT FILE"
    	echo "=============================="
    	read -p "Select the file PATH: " file
    	existence "$file"
    	read -sp "Enter the password: " password
    	echo " "
    	openssl enc -d -aes-256-cbc -in "$file" -out "${file%.wfb}" -pass pass:"$password"
    	if [ $? -eq 0 ]; then
        	success_msg "Decrypted successfully file: ${file%.wfb}"
    	else
        	error_msg "Error decrypting the file. Check password."
    	fi
	read -p "Press ENTER to return to the menu." menu
}

encrypt_dir() {
    	echo " "
    	echo "                 ENCRYPT DIR"
    	echo "============================="
    	read -p "Select the directory PATH: " dir
    	existence "$dir"
    	read -sp "Enter the password: " password
    	echo " "
   	tar -czf - "$dir" | openssl enc -aes-256-cbc -salt -out "$dir.tar.gz.wfb" -pass pass:"$password"
    	if [ $? -eq 0 ]; then
        	success_msg "Directory successfully encrypted: $dirpath.tar.gz.wfb"
    	else
        	error_msg "Error encrypting directory."
    	fi
	read -p "Press ENTER to return to the menu." menu
}

decrypt_dir() {
    	echo " "
    	echo "                 DECRYPT DIR"
    	echo "============================="
    	read -p "Select the directory PATH: " dir
    	existence "$dir"
    	read -sp "Enter the password linked to the directory: " password
    	echo " "
    	openssl enc -d -aes-256-cbc -in "$dir" -out "${dir%.wfb}.tar.gz" -pass pass:"$password"
    	if [ $? -eq 0 ]; then
        	tar -xzf "${dir%.wfb}.tar.gz"
        	success_msg "Directory successfully decrypted!"
    	else
        	error_msg "Error decrypting the directory. Check password and file."
    	fi
    	rm -f "${dir%.wfb}.tar.gz"
	read -p "Press ENTER to return to the menu" menu
}

while true; do
	clear
    	menu
    	read -p "   Enter the option: " choice
    	case $choice in
        	1) encrypt_file ;;
        	2) decrypt_file ;;
        	3) encrypt_dir ;;
        	4) decrypt_dir ;;
		info) info ;;
        	x) exit 0 ;;
        	*) error_message "Invalid Option!" ;;
    	esac
done

