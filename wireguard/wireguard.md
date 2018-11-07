WireGuard presentation
======================

https://www.wireguard.com/

Host (client and server): Ubuntu

## Installation

See https://www.wireguard.com/install

	$ sudo add-apt-repository ppa:wireguard/wireguard
	$ sudo apt-get update
	$ sudo apt-get install wireguard


## Set up

### Generate keys

On client and server do:

	$ wg genkey | tee privatekey | wg pubkey > publickey

### Firewall

On server using ufw open port:

	$ sudo ufw allow 51820/udp

### Configure

Client /etc/wireguard/wg.conf

	[Interface]
	Address = 192.168.0.2/24
	PrivateKey = <private key>
	DNS = 192.168.0.1

	[Peer]
	PublicKey = kEoWdKBBwg8fyiLY/DqQg6ciRycvA9KDznOS/UOAHWs=
	Endpoint = 159.65.7.29:51820
	AllowedIPs = 0.0.0.0/0, ::/0
	PersistentKeepalive = 21

Server /etc/wireguard/wg.conf

	[Interface]
	PrivateKey = <private key>
	Address = 192.168.0.1/24
	ListenPort = 51820

	PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; \
		 	 iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; \
			 ip6tables -A FORWARD -i wg0 -j ACCEPT; \
			 ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

	PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; \
			   iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; \
			   ip6tables -D FORWARD -i wg0 -j ACCEPT; \
			   ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE \

	SaveConfig = true

	[Peer]
	PublicKey = ZSkamiOye34q6Z9/yobnyj6vD3ed0DbMxV12QKsxZHg=
	AllowedIPs = 192.168.0.2/32


## Start and enable

Using systemd on server:

	sudo systemctl enable wg-quick@wg0
	sudo systemctl start wg-quick@wg0

Using wg tool on client:

	wg-quick up wg0

## Verify

	wg show
	ifconfig wg0
	route -n