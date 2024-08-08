#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

command_exists() {
    command -v "$1" &> /dev/null
}

if ! command_exists adb; then
    echo -e "${RED}❌ adb not found. Please install Android SDK Platform-Tools.${NC}"
    exit 1
fi

disable_avb_verification() {
    adb root
    echo -e "${YELLOW}🔓 Disabling AVB verification...${NC}"
    adb shell avbctl disable-verification
}

remount_system() {
    echo -e "${YELLOW}🔄 Remounting /system as read-write...${NC}"
    adb root
    adb remount
}

move_file_and_set_permissions() {
    local file_path=$1
    if [ -z "$file_path" ]; then
        echo -e "${RED}❌ No file path provided.${NC}"
        exit 1
    fi

    echo -e "${YELLOW}📂 Moving $file_path to /system/etc/security/cacerts...${NC}"
    adb push "$file_path" /system/etc/security/cacerts/
    local file_name=$(basename "$file_path")
    echo -e "${YELLOW}🔒 Setting permissions to 644 for $file_name...${NC}"
    adb shell chmod 644 /system/etc/security/cacerts/"$file_name"
}

reboot_emulator() {
    echo -e "${YELLOW}🔄 Rebooting the emulator... Waiting for 20 secs for emulator to boot up.${NC}"
    adb reboot
    sleep 20
}

get_cert_file() {
    local script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local cert_file=$(find "$script_dir" -maxdepth 1 -name "*.0" -type f -print -quit)
    
    if [ -n "$cert_file" ]; then
        echo "$cert_file"
    else
        echo -e "${RED}❌ No .0 file found in the current directory.${NC}"
        return 1
    fi
}

FILE_PATH=$(get_cert_file)
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Found certificate file: $FILE_PATH${NC}"
else
    echo -e "${RED}❌ Error: $FILE_PATH${NC}"
    exit 1
fi

remount_system
reboot_emulator
remount_system
move_file_and_set_permissions "$FILE_PATH"
reboot_emulator

echo -e "${GREEN}🎉 Script execution completed.${NC}"