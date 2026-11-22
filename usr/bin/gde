#!/usr/bin/env bash

CRED_SAVE_PATH="/usr/share/gde-cr/global.pswd"

pswdbox() {
    dialog --backtitle "PAS Auth manager" --insecure --passwordbox "enter password" 0 0 3>&1 1>&2 2>&3
}

filech() {
    dialog --backtitle "File Chooser" --inputbox "Enter file path:" 0 0 3>&1 1>&2 2>&3
}

editorch() {
    dialog --backtitle "Choose an editor" \
	   --menu "Options:" 0 0 0 \
	   1 "nano" \
	   2 "vim" \
	   3 "neovim" \
	   3>&1 1>&2 2>&3
}

dpkgs() {
    dialog --backtitle "Useful Packages" \
	   --menu "Packages:" 0 0 0 \
	   1 "python3" \
	   2 "git" \
	   3 "github" \
	   4 "neovim" \
	   3>&1 1>&2 2>&3
}

crepo() {
    dialog --backtitle "Create repository (public)" --inputbox "Enter repository name:" 0 0 3>&1 1>&2 2>&3
}

auth() {
    PASSWORD=$(cat /usr/share/gde-cr/global.pswd)
}

cont() {
    read -p "Press enter to continue..."
}

sudo mkdir -p /usr/share/gde-cr

if [ ! -f "$CRED_SAVE_PATH" ]; then
    dialog --msgbox "No password configured!" 0 0
fi

while true; do
    mainmenu=$(dialog --backtitle "GDE | Graphical Development Environment" \
	              --menu "Tools:" 0 0 0 \
		      1 "Edit script" \
		      2 "Install packages" \
		      3 "Upgrade & update" \
		      4 "Set password" \
		      5 "Create public github repository" \
		      6 "Initialise git in this directory" \
		      7 "Log in to Github CLI" \
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
			neovim "$fil"
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
		gh repo create "$usimp" --public
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
	*)
	    echo "exited w/ code: $status"
	    break
	    ;;

    esac
done
	    
