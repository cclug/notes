WireGuard presentation
======================

Into
----

WireGuard® is an extremely simple yet fast and modern VPN that utilizes
state-of-the-art cryptography.

- What it is  
- Why you might care  
- How to use it  

What it is
----------

https://www.wireguard.com/

Wireguard securely encapsulates IP packets over UDP.  It works by adding a
network interface i.e wg0.  You can then configure that interface normally using
`ifconfig`, `route` etc.

Why you might care
------------------

- Linus likes it.

	> Can I just once again state my love for [WireGuard] and hope it gets merged
    > soon? Maybe the code isn't perfect, but I've skimmed it, and compared to the
    > horrors that are OpenVPN and IPSec, it's a work of art. (Linus on LKML)


https://arstechnica.com/gadgets/2018/08/wireguard-vpn-review-fast-connections-amaze-but-windows-support-needs-to-happen/

- Lines of Code

WireGuard: approx 4000  
OpenVPN + OpenSSl: 600,000  
XFRM+StrongSwan for an IPSEC VPN: 400,000  

- Its done in kernel space and should in theory be much faster.

How to use it
-------------

Host (client and server): Ubuntu

## Installation

See https://www.wireguard.com/install

	sudo add-apt-repository ppa:wireguard/wireguard
	sudo apt-get update
	sudo apt-get install wireguard


## Set up

### Generate keys

On client and server do:

	wg genkey | tee privatekey | wg pubkey > publickey

### Configure

Server /etc/wireguard/wg0.conf

	[Interface]
	PrivateKey = <private key>
	Address = 192.168.0.1/24
	ListenPort = 51820

	PostUp = iptables -A FORWARD -i wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; ip6tables -A FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
		 	 
	PostDown = iptables -D FORWARD -i wg0 -j ACCEPT; iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; ip6tables -D FORWARD -i wg0 -j ACCEPT; ip6tables -t nat -D POSTROUTING -o eth0 -j MASQUERADE \

	SaveConfig = true

	[Peer]
	PublicKey = ZSkamiOye34q6Z9/yobnyj6vD3ed0DbMxV12QKsxZHg=
	AllowedIPs = 192.168.0.2/32

Client /etc/wireguard/wg0.conf

	[Interface]
	Address = 192.168.0.2/24
	PrivateKey = <private key>
	DNS = 192.168.0.1

	[Peer]
	PublicKey = kEoWdKBBwg8fyiLY/DqQg6ciRycvA9KDznOS/UOAHWs=
	Endpoint = 159.65.7.29:51820
	AllowedIPs = 0.0.0.0/0, ::/0
	PersistentKeepalive = 21

### Firewall

On server using ufw open port:

	sudo ufw allow 51820/udp

## Start and enable

Using systemd on server:

	sudo systemctl enable wg-quick@wg0
	sudo systemctl start wg-quick@wg0

Using wg tool on client:

	wg-quick up wg0

## Verify

	sudo wg show
	interface: wg0
	public key: ZSkamiOye34q6Z9/yobnyj6vD3ed0DbMxV12QKsxZHg=
	private key: (hidden)
	listening port: 51820
	fwmark: 0xca6c

	peer: kEoWdKBBwg8fyiLY/DqQg6ciRycvA9KDznOS/UOAHWs=
	endpoint: 159.65.7.29:51820
	allowed ips: 0.0.0.0/0, ::/0
	latest handshake: 7 seconds ago
	transfer: 15.28 KiB received, 7.44 KiB sent
	persistent keepalive: every 21 seconds

	ifconfig wg0
	wg0: flags=209<UP,POINTOPOINT,RUNNING,NOARP>  mtu 1420
        inet 192.168.0.2  netmask 255.255.255.0  destination 192.168.0.2
        unspec 00-00-00-00-00-00-00-00-00-00-00-00-00-00-00-00  txqueuelen 1000  (UNSPEC)
        RX packets 261  bytes 64288 (64.2 KB)
        RX errors 0  dropped 17  overruns 0  frame 0
        TX packets 427  bytes 60132 (60.1 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 

	ip route
	default via 192.168.178.1 dev enxec2280a341c8 proto dhcp metric 100 
	169.254.0.0/16 dev enxec2280a341c8 scope link metric 1000
	192.168.0.0/24 dev wg0 proto kernel scope link src 192.168.0.2 
	192.168.178.0/24 dev enxec2280a341c8 proto kernel scope link src 192.168.178.20 metric 100


## Killswitch

We can define a 'killswitch' using ufw

    # Allow LAN access.
    sudo ufw allow in to 192.168.178.0/24
    sudo ufw allow out to 192.168.178.0/24

    # Block all connections except LAN.
    sudo ufw default deny outgoing
    sudo ufw default deny incoming
    sudo ufw allow out on wg0 from any to any

    # Allow connection to wireguard server. Do we need this?
    sudo ufw allow out to 159.65.7.29 port 51820 proto udp
