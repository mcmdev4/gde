#!/usr/bin/env bash

CRED_SAVE_PATH="/usr/share/gde-cr/global.pswd"
CONF="/usr/share/conf/vis.conf"
DEF_CONF="DEFAULT_FORMAT='\Zn'
INFO=''"
sudo mkdir -p /usr/share/gde-cr
sudo mkdir -p /usr/share/conf
if [ ! -f "$CONF" ]; then
    echo "$DEF_CONF" | sudo tee "$CONF" > /dev/null
fi
source "$CONF"

df="${DEFAULT_FORMAT}"


pswdbox() {
    dialog --backtitle "${df}PAS Auth manager${df}" --insecure --passwordbox "${df}enter password${df}" 0 0 3>&1 1>&2 2>&3
}

filech() {
    dialog --backtitle "${df}File Chooser${df}" --inputbox "${df}Enter file path:${df}" 0 0 3>&1 1>&2 2>&3
}

editorch() {
    dialog --backtitle "${df}Choose an editor${df}" \
	   --menu "${df}Options:${df}" 0 0 0 \
	   1 "${df}nano${df}" \
	   2 "${df}vim${df}" \
	   3 "${df}neovim${df}" \
	   3>&1 1>&2 2>&3
}

dpkgs() {
    dialog --backtitle "${df}Useful Packages${df}" \
	   --menu "${df}Packages:${df}" 0 0 0 \
	   1 "${df}python3${df}" \
	   2 "${df}git${df}" \
	   3 "${df}github${df}" \
	   4 "${df}neovim${df}" \
	   5 "${df}reprepro${df}" \
	   6 "${df}curl${df}" \
	   3>&1 1>&2 2>&3
}

crepo() {
    dialog --backtitle "${df}Create repository (public)${df}" --inputbox "${df}Enter repository name:${df}" 0 0 3>&1 1>&2 2>&3
}

auth() {
    PASSWORD=$(cat /usr/share/gde-cr/global.pswd)
}

cont() {
    read -p "Press enter to continue..."
}




if [ ! -f "$CRED_SAVE_PATH" ]; then
    dialog --msgbox "${df}No password configured!${df}" 0 0
fi

while true; do
    if [[ "$#" -gt 0 ]]; then
        case "$1" in
            --info|-i)
	        sudo cat "/usr/share/gde-cr/.info"
		break
	        ;;
            *)
	        echo "unknown args: $1"
		break
	        ;;
       esac
    fi 
    mainmenu=$(dialog --backtitle "${df}GDE | Graphical Development Environment${df}" \
	              --menu "${df}Tools:${df}" 0 0 0 \
		      1 "${df}Edit script${df}" \
		      2 "${df}Install packages${df}" \
		      3 "${df}Upgrade & update${df}" \
		      4 "${df}Set password${df}" \
		      5 "${df}Create public github repository${df}" \
		      6 "${df}Initialise git in this directory${df}" \
		      7 "${df}Log in to Github${df}" \
		      8 "${df}Initialise UDR repository${df}" \
		      9 "${df}Set as startup terminal application${df}" \
		      10 "${df}Wipe program data (password)${df}" \
		      11 "${df}About${df}" \
		      3>&1 1>&2 2>&3)
    status=$?

    clear

    case "$mainmenu" in
	1)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        edc=$(editorch)
		case "$edc" in
		    1)
		        fil=$(filech)
			nano "$fil"
			clear
			;;
		    2)
		        fil=$(filech)
			vim "$fil"
			clear
			;;
		    3)
			fil=$(filech)
			nvim "$fil"
			clear
			;;
		    *)
			clear
			;;
		esac
	    fi
	    ;;
	2)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        pkg=$(dpkgs)
		case "$pkg" in
		    1)
			clear
		        sudo apt install python3 -y
			cont
			clear
			;;
		    2)
			clear
			sudo apt install git -y
			cont
			clear
			;;
		    3)
			clear
			sudo apt install gh -y
			cont
			clear
			;;
		    4)
			clear
			sudo apt install neovim -y
			cont
			clear
			;;
		    5)
			clear
			sudo apt install reprepro -y
			cont
			clear
			;;
		    6)
			clear
			sudo apt install curl -y
			cont
			clear
			;;
		    *)
			clear
			;;
		esac
	    fi
	    ;;
	3)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
		clear
	        sudo apt update && sudo apt upgrade -y
		cont
		clear
	    fi
	    ;;
	4)
	    if sudo -v; then
	        usimp=$(pswdbox)
	        echo "$usimp" | sudo tee "$CRED_SAVE_PATH" > /dev/null
	        clear
	    fi
	    ;;
	5)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        repon=$(crepo)
		gh repo create "$repon" --public
		clear
	    fi
	    ;;
	6)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        git init
		git branch -m Main
	    fi
	    ;;
	7)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
		gh auth login
		clear
	    fi
	    ;;
	8)
	    sudo mkdir -p /etc/apt/keyrings

	    sudo curl -fsSL \
	    https://mcmdev4.github.io/udr/repo-key.asc \
	    -o /etc/apt/keyrings/udr-archive-keyring.asc
            
	    echo "deb [signed-by=/etc/apt/keyrings/udr-archive-keyring.asc] https://mcmdev4.github.io/udr/ stable main"             | sudo tee /etc/apt/sources.list.d/udr.list

	    sudo chmod 644 /etc/apt/sources.list.d/udr.list
	    ;;
	9)
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
                echo "Setting up startup services..."
	        cat << 'EOF' | sudo tee -a ~/.bashrc > /dev/null
# Auto-start GDE
if [ $- == *i* ]; then
gde 
fi
EOF
	    sleep 5
	    cont
	    fi
            ;;
	10)
	    sudo -v
	    auth
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        dialog --backtitle "${df}Wipe program data${df}" --yesno "${df}Are you sure you want to continue?${df}" 0 0
	        result=$?
	        if [ "$result" -eq 0 ]; then
		    clear
		    sudo rm -rf /usr/share/gde-cr/*
		    cont
		    clear
	        else
		    clear
		    cont
		    clear
		fi
	    fi
	    ;;
	11)
	    info="Version: 1.4 Moscow
	          Codename theme: Capitals
		  UI Engine: dialog
		  UI Style: BIUI
		  ------- SYSTEM --------
		  Hostname: $(hostname)
		  User: $USER
		  Distro: $(. /etc/os-release && echo ""$PRETTY_NAME"")
		  ------- CUSTOM --------
		  ${INFO}"
	    path="/usr/share/gde-cr/.info"
	    echo "$info" | sudo tee "$path" > /dev/null
	    dialog --backtitle "About (system and app)" --msgbox "${df}$(cat "$path")${df}" 0 0
	    ;;
	*)
	    echo "exited w/ code: $status"
	    break
	    ;;

    esac
done


