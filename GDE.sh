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
	   5 "reprepro" \
	   6 "curl" \
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
		      7 "Log in to Github" \
		      8 "Initialise UDR repository" \
		      9 "Set as startup terminal application" \
		      10 "Wipe program data (password)" \
		      11 "About" \
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

	    chmod 755 /etc/apt/sources.list.d/udr.list
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
	        dialog --backtitle "Wipe program data" --yesno "Are you sure you want to continue?" 0 0
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
	    info="Version: 1.3 Budapest
	          Codename theme: Capitals
		  ------- SYSTEM --------
		  Hostname: $(hostname)
		  User: $USER
		  Distro: $(. /etc/os-release && echo ""$PRETTY_NAME"")"
	    dialog --backtitle "About (system and app)" --msgbox "$info" 0 0
	    ;;
	*)
	    echo "exited w/ code: $status"
	    break
	    ;;

    esac
done
	    
