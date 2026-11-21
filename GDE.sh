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
	   3>&1 1>&2 2>&3
}

dpkgs() {
    dialog --backtitle "Useful Packages" \
	   --menu "Packages:" 0 0 0 \
	   1 "python3" \
	   2 "git" \
	   3 "github" \
	   3>&1 1>&2 2>&3
}


sudo mkdir -p /usr/share/gde-cr

if [ ! -f "$CRED_SAVE_PATH" ]; then
    dialog --msgbox "No password configured!" 0 0
fi

while true; do
    mainmenu=$(dialog --backtitle "GDE | Graphical Development Enviroment" \
	              --menu "Tools:" 0 0 0 \
		      1 "Edit script" \
		      2 "Install packages" \
		      3 "Upgrade & update" \
		      4 "Set password" \
		      3>&1 1>&2 2>&3)
    status=$?

    clear

    case "$mainmenu" in
	1)
	    PASSWORD=$(cat /usr/share/gde-cr/global.pswd)
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
		    *)
			clear
			;;
		esac
	    fi
	    ;;
	2)
	    PASSWORD=$(cat /usr/share/gde-cr/global.pswd)
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
	        pkg=$(dpkgs)
		case "$pkg" in
		    1)
		        sudo apt install python3 -y
			clear
			;;
		    2)
			sudo apt install git -y
			clear
			;;
		    3)
			sudo apt install gh -y
			clear
			;;
		    *)
			clear
			;;
		esac
	    fi
	    ;;
	3)
	    PASSWORD=$(cat /usr/share/gde-cr/global.pswd)
	    usimp=$(pswdbox)
	    if [ "$usimp" = "$PASSWORD" ]; then
		clear
	        sudo apt update && sudo apt upgrade -y
	    fi
	    ;;
	4)
	    sudo -v
	    usimp=$(pswdbox)
	    echo "$usimp" | sudo tee "$CRED_SAVE_PATH" > /dev/null
	    clear
	    ;;
	*)
	    echo "exited w/ code: $status"
	    break
	    ;;

    esac
done
	    
