#!/usr/bin/env bash

IGNORE_SETTINGS_KEYBINDINGS=1 #1 will ignore copying the keybindings.json and settings.json file / 0 will copy/symlink the keybindings.json and settings.json file
CREATE_SYMLINKS=0 #1 for SYMLINKS / 0 for COPYING

VSCCustomDir="$HOME/vscmgr/vscode_configs"

VSCodeConfigDir="$HOME/.config/Code" # VS Code Path

#-----------------------------------------------------------------
declare -A VSCPaths
VSCPaths["settings"]="$VSCodeConfigDir/User/settings.json"
VSCPaths["keybindings"]="$VSCodeConfigDir/User/keybindings.json"

BaseKeyBindings="$VSCCustomDir/keybindings.json"
BaseSettings="$VSCCustomDir/settings.json"
BaseExt="$VSCCustomDir/base.ext"

ExtProfileDir="$VSCCustomDir/profiles"

CACHE_FOLDER="$HOME/.cache/vscode_ext"
mkdir -p $CACHE_FOLDER

# Function to display usage information
usage() {
	echo "------------------------------------------------------" >&2
	echo >&2
	echo "CS Sahil (github.com/XEHIL)" >&2
	echo >&2
	echo "------------------------------------------------------" >&2
	echo >&2
	echo "Usage: $0 [-b] OR [-i] OR [-d] OR [-l] OR [-u] OR [-x]" >&2
	echo >&2
    echo "Options:" >&2
	echo "  -b: Go to Base Config" >&2
    echo "  -i: Install Extensions from Profiles Config" >&2
	echo "  -d: Delete Extensions from Profiles Config" >&2
	echo "  -l: List Installed Extensions" >&2
    echo "  -u: Update Installed Extensions" >&2
    echo "  -x: Uninstall All Extensions" >&2
	echo >&2
}

copy_file_conf() {
	local selectedFile="$1"
	local destFile="$2"
	local symlinks=$3
	if [ -f "$destFile" ]; then
		rm "$destFile"
	fi
	if [[ "$symlinks" -eq 1 ]]; then
		echo "Creating Symlink..."
		ln -sf $selectedFile $destFile
	else
		echo "Copying File..."
		cp -f $selectedFile $destFile
	fi
	echo "$selectedFile -> $destFile"
}

clear_cache() {
	if [ -n "$(ls $CACHE_FOLDER/*.cache 2>/dev/null)" ]; then
    	rm $CACHE_FOLDER/*.cache
	fi
}

# Check if no arguments are provided
if [[ $# -eq 0 ]]; then
	usage
	exit 0
fi

# Check if VS Code is installed
if command -v code &> /dev/null
then
    :
else
    echo "Visual Studio Code: Not Installed"
    exit 1
fi

# Initialize variables

install=false
delete=false
base=false
delete_all=false
update=false
list=false
flag_count=0

# Parse command-line arguments
while getopts ":biduxl" opt; do
    case ${opt} in
        b )
            base=true
            ((flag_count++))
            ;;
        i )
            install=true
            ((flag_count++))
            ;;
        d )
            delete=true
            ((flag_count++))
            ;;
		x )
            delete_all=true
            ((flag_count++))
            ;;
		u )
            update=true
            ((flag_count++))
            ;;
		l )
            list=true
            ((flag_count++))
            ;;
        \? )
            echo "Error: Invalid option -$OPTARG" >&2
            usage
			exit 1
            ;;
        : )
            echo "Error: Option -$OPTARG requires an argument" >&2
            usage
            ;;
    esac
done

# Check if more than one flag is provided
if [[ $flag_count -gt 1 ]]; then
    echo "Error: Multiple flags supplied. Please provide only one flag." >&2
    usage
fi

if [ -d "$ExtProfileDir" ]; then
	echo "-----------------------------------"
    echo " Profiles Directory: $ExtProfileDir"
	echo "-----------------------------------"
else
    echo "PROFILES DIR NOT FOUND: $ExtProfileDir"
	mkdir -p $ExtProfileDir && echo "PROFILES DIR CREATED: $ExtProfileDir"
fi

# Main logic based on the chosen flag

if [[ $delete_all = true ]]; then
    code --list-extensions | while read extension;
	do
	 code --uninstall-extension $extension --force
	done
	
elif [[ $install = true ]]; then
	options=($(ls "$ExtProfileDir"))
	extFile=$(printf '%s\n' "${options[@]}" | fzf --prompt="󰨞 Install Mode  " --height=30% --layout=reverse --border --exit-0)
	currInstalled=($(code --list-extensions))
	code --list-extensions > $CACHE_FOLDER/currInstalled.cache
	cat $ExtProfileDir/$extFile 2>/dev/null | grep -vE '^\s*($|#)' | sort -u > $CACHE_FOLDER/extFile.cache
	grep -ivxFf $CACHE_FOLDER/currInstalled.cache $CACHE_FOLDER/extFile.cache > $CACHE_FOLDER/toBeModified.cache
	while read -r line; do
    ext_id="$line"
    code --install-extension $ext_id
	done < "$CACHE_FOLDER/toBeModified.cache"
	
elif [[ $update = true ]]; then
	code --update-extensions	

elif [[ $list = true ]]; then
	currInstalled=($(code --list-extensions))
	code --list-extensions > $CACHE_FOLDER/currInstalled.cache
	if [ -s $CACHE_FOLDER/currInstalled.cache ]; then
    	cat $CACHE_FOLDER/currInstalled.cache
	else
    	echo "No Extensions Installed..."
	fi

elif [[ $delete = true ]]; then
    options=($(ls "$ExtProfileDir"))
	extFile=$(printf '%s\n' "${options[@]}" | fzf --prompt="󰨞 Delete Mode  " --height=30% --layout=reverse --border --exit-0)
	currInstalled=($(code --list-extensions))
	code --list-extensions > $CACHE_FOLDER/currInstalled.cache
	cat $ExtProfileDir/$extFile 2>/dev/null | grep -vE '^\s*($|#)' | sort -u > $CACHE_FOLDER/extFile.cache
	grep -ixFf $CACHE_FOLDER/extFile.cache $CACHE_FOLDER/currInstalled.cache > $CACHE_FOLDER/toBeModified.cache
	while read -r line; do
    ext_id="$line"
    code --uninstall-extension $ext_id --force
	done < "$CACHE_FOLDER/toBeModified.cache"
	
elif [[ $base = true ]]; then
	if [ -f "$BaseExt" ]; then
		currInstalled=($(code --list-extensions))
		code --list-extensions > $CACHE_FOLDER/currInstalled.cache
		cat $BaseExt | grep -vE '^\s*($|#)' | sort -u > $CACHE_FOLDER/extFile.cache
		
		grep -ivxFf $CACHE_FOLDER/currInstalled.cache $CACHE_FOLDER/extFile.cache > $CACHE_FOLDER/toBeModified.cache
		while read -r line; do
    		ext_id="$line"
    		code --install-extension $ext_id
		done < "$CACHE_FOLDER/toBeModified.cache"
		
		grep -ivxFf $CACHE_FOLDER/extFile.cache $CACHE_FOLDER/currInstalled.cache > $CACHE_FOLDER/toBeModified.cache
		while read -r line; do
		ext_id="$line"
		code --uninstall-extension $ext_id --force
		done < "$CACHE_FOLDER/toBeModified.cache"
		
		echo "Base Extensions: LOADED"
		
		if [ "$IGNORE_SETTINGS_KEYBINDINGS" -eq 0 ]; then
			echo "-----------------------------------"
				echo " SET Base keybindings.json : $BaseKeyBindings"
			echo "-----------------------------------"
			copy_file_conf $BaseKeyBindings ${VSCPaths["keybindings"]} $CREATE_SYMLINKS

			echo "-----------------------------------"
				echo " SET Base settings.json : $BaseSettings"
			echo "-----------------------------------"
			copy_file_conf $BaseSettings ${VSCPaths["settings"]} $CREATE_SYMLINKS
		fi
		
	else
    	echo "Base Extensions File NOT FOUND: $BaseExt"
	fi
fi

clear_cache
