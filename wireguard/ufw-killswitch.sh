#!/bin/bash
#
# ufw kill switch

main() {
    if [ $# -lt 1 ]; then
	echo "Usage: $0 ( off | on )"
	exit 1
    fi

    local _command=$1

    case "$_command" in
	off )
	    disable-killswitch
	    ;;
	on )
	    enable-killswitch
	    ;;
        * )
            err "available commands: 'off', 'on'"
            ;;
    esac

}

enable-killswitch() {
    # Allow LAN access.
    sudo ufw allow in to 192.168.178.0/24
    sudo ufw allow out to 192.168.178.0/24

    # Block all connections except LAN.
    sudo ufw default deny outgoing
    sudo ufw default deny incoming
    sudo ufw allow out on wg0 from any to any

    # Allow connection to wireguard server. Do we need this?
    sudo ufw allow out to 159.65.7.29 port 51820 proto udp
}

# Resets and enables empty firewall.
disable-killswitch() {
    sudo ufw reset
    sudo ufw default allow outgoing
    sudo ufw default deny incoming
    sudo ufw enable
    sudo ufw status verbose
}

main $@
