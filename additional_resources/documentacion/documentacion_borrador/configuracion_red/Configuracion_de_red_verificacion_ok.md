
sudo nano /etc/sysconfig/iptables


```
 plaintext
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

# Permitir tráfico ICMP (ping)
-A INPUT -p icmp -j ACCEPT
-A FORWARD -p icmp -j ACCEPT

# Permitir tráfico SSH
-A INPUT -p tcp --dport 22 -j ACCEPT

# Permitir tráfico HTTP y HTTPS
-A INPUT -p tcp --dport 80 -j ACCEPT
-A INPUT -p tcp --dport 443 -j ACCEPT

# Permitir tráfico DNS
-A INPUT -p udp --dport 53 -j ACCEPT
-A INPUT -p tcp --dport 53 -j ACCEPT

# Permitir tráfico entre br0 y las subredes
-A FORWARD -i br0 -o virbr0 -j ACCEPT
-A FORWARD -i br0 -o virbr1 -j ACCEPT
-A FORWARD -i virbr0 -o br0 -j ACCEPT
-A FORWARD -i virbr1 -o br0 -j ACCEPT

# Permitir tráfico entre las subredes 10.17.3.0/24 y 10.17.4.0/24
-A FORWARD -s 10.17.3.0/24 -d 10.17.4.0/24 -j ACCEPT
-A FORWARD -s 10.17.4.0/24 -d 10.17.3.0/24 -j ACCEPT

# Permitir tráfico entre la red 192.168.0.0/24 y las subredes
-A FORWARD -s 192.168.0.0/24 -d 10.17.3.0/24 -j ACCEPT
-A FORWARD -s 192.168.0.0/24 -d 10.17.4.0/24 -j ACCEPT
-A FORWARD -s 10.17.3.0/24 -d 192.168.0.0/24 -j ACCEPT
-A FORWARD -s 10.17.4.0/24 -d 192.168.0.0/24 -j ACCEPT

# Permitir todo el tráfico entrante y saliente en la interfaz br0
-A INPUT -i br0 -j ACCEPT
-A OUTPUT -o br0 -j ACCEPT

COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]

# Configurar NAT para la red kube_network_02
-A POSTROUTING -s 10.17.3.0/24 -o br0 -j MASQUERADE

# Configurar NAT para la red kube_network_03
-A POSTROUTING -s 10.17.4.0/24 -o br0 -j MASQUERADE

# Configurar NAT para la red local a Internet
-A POSTROUTING -s 192.168.0.0/24 -o enp4s0f0 -j MASQUERADE
-A POSTROUTING -s 10.17.3.0/24 -o enp4s0f0 -j MASQUERADE
-A POSTROUTING -s 10.17.4.0/24 -o enp4s0f0 -j MASQUERADE

COMMIT
```
Reinicia el servicio iptables:



```bash
sudo systemctl restart iptables
```


# Bootstrap1

```bash
sudo ip route add 10.17.3.0/24 via 10.17.4.1 dev eth0
sudo ip route add 192.168.0.0/24 via 10.17.4.1 dev eth0
```


# FreeIPA1

```bash
sudo ip route add 10.17.4.0/24 via 10.17.3.1 dev eth0
sudo ip route add 192.168.0.0/24 via 10.17.3.1 dev eth0
```

# Bastion1

```bash
sudo ip route add 10.17.3.0/24 via 192.168.0.21 dev eth0
sudo ip route add 10.17.4.0/24 via 192.168.0.21 dev eth0
```

```bash
sudo systemctl restart libvirtd


sudo systemctl restart iptables

sudo systemctl restart NetworkManager

```