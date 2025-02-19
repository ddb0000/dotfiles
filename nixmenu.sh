#!/usr/bin/env zsh

# Helper function to show menu
show_menu() {
    clear
    print -P "%F{cyan}"
    cat << "EOF"

   ▄   ▄█     ▄  █▀▄▀█ ▄███▄      ▄     ▄   
    █  ██ ▀▄   █ █ █ █ █▀   ▀      █     █  
██   █ ██   █ ▀  █ ▄ █ ██▄▄    ██   █ █   █ 
█ █  █ ▐█  ▄ █   █   █ █▄   ▄▀ █ █  █ █   █ 
█  █ █  ▐ █   ▀▄    █  ▀███▀   █  █ █ █▄ ▄█ 
█   ██     ▀       ▀           █   ██  ▀▀▀                                          
EOF
    print -P "%f"
    print -P "%F{green}1%f) System Update"
    print -P "%F{green}2%f) Flake Update"
    print -P "%F{green}3%f) Clean System"
    print -P "%F{green}4%f) View History"
    print -P "%F{green}5%f) Cookbook"
    print -P "%F{green}6%f) Exit"
}

# Helper function to handle system commands
handle_choice() {
    case $1 in
        1)
            print -P "%F{blue}Running system update...%f"
            sudo nixos-rebuild switch --flake .
            ;;
        2)
            print -P "%F{blue}Updating flake...%f"
            nix flake update
            ;;
        3)
            print -P "%F{blue}Cleaning system...%f"
            sudo nix profile wipe-history --older-than 7d --profile /nix/var/nix/profiles/system
            sudo nix-collect-garbage --delete-older-than 7d
            nix-collect-garbage --delete-older-than 7d
            ;;
        4)
            print -P "%F{blue}System history:%f"
            nix profile history --profile /nix/var/nix/profiles/system
            print -P "\n%F{blue}Home Manager history:%f"
            nix profile history --profile "$HOME/.local/state/nix/profiles/home-manager"
            ;;
        5)
            show_cookbook_menu
            return
            ;;
        6)
            print -P "%F{green}Goodbye!%f"
            exit 0
            ;;
        *)
            print -P "%F{red}Invalid option%f"
            ;;
    esac
    
    print -P "\n%F{yellow}Press any key to continue...%f"
    read -k1
}

# Cookbook menu
show_cookbook_menu() {
    while true; do
        clear
        print -P "%F{yellow}=== COOKBOOK MENU ===%f\n"
        print -P "%F{green}1%f) Stream"
        print -P "%F{green}2%f) Stream to Wallpaper"
        print -P "%F{green}3%f) Back to Main Menu"
        echo
        
        print -Pn "%F{blue}Choose an option: %f"
        read -k1 choice
        echo
        
        case $choice in
            1)
                print -Pn "\n%F{blue}Enter stream URL/path (default: twitch.tv/paveer2): %f"
                read stream_input
                stream_source=${stream_input:-"https://www.twitch.tv/paveer2"}
                mpv "$stream_source"
                ;;
            2)
                print -Pn "\n%F{blue}Enter stream URL/path (default: twitch.tv/paveer2): %f"
                read stream_input
                stream_source=${stream_input:-"https://www.twitch.tv/paveer2"}
                mpvpaper -o "loop" DP-2 "$stream_source"
                ;;
            3)
                return
                ;;
        esac
    done
}

# Main loop
cd ~/.dotfiles
while true; do
    show_menu
    echo 
    print -Pn "%F{blue}Choose an option: %f"
    read -k1 choice
    echo 
    handle_choice $choice
done