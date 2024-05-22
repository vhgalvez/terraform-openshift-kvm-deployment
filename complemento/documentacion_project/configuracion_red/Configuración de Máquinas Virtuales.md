Configuración de Máquinas Virtuales para Enrutamiento y Red
Este documento describe los pasos necesarios para configurar las máquinas virtuales bootstrap1, bastion1, y freeipa1 en el entorno cefaslocalserver.com. La configuración incluye la asignación de direcciones IP, la configuración de rutas y la configuración de reglas de firewall iptables.

Tabla de Contenidos
Requisitos Previos
Configuración de bootstrap1
Configuración de bastion1
Configuración de freeipa1
Configuración de Redes NAT en el Servidor
Configuración de iptables en el Servidor
Habilitación del Reenvío de IP
Verificación de la Conectividad
Conclusión
Requisitos Previos
Antes de comenzar, asegúrese de tener:

Acceso de administrador a las máquinas virtuales.
Conexión de red entre las máquinas virtuales.
Conocimiento básico de comandos de red y administración de sistemas en Linux.
Configuración de bootstrap1
Configuración de la Dirección IP
Verificar la configuración actual de la dirección IP:
bash
Copiar código
ip addr
Verificar la configuración de rutas:
bash
Copiar código
sudo ip route
Salida esperada:
plaintext
Copiar código
default via 10.17.4.1 dev eth0 proto dhcp src 10.17.4.20 metric 1024
10.17.4.0/24 dev eth0 proto kernel scope link src 10.17.4.20 metric 1024
10.17.4.1 dev eth0 proto dhcp scope link src 10.17.4.20 metric 1024
Configuración de bastion1
Configuración de la Dirección IP y Rutas
Verificar la configuración actual de la dirección IP:
bash
Copiar código
ip addr
Configurar las rutas estáticas:
bash
Copiar código
sudo ip route add 10.17.3.0/24 via 192.168.0.42
sudo ip route add 10.17.4.0/24 via 192.168.0.42
Verificar la configuración de rutas:
bash
Copiar código
sudo ip route
Salida esperada:
plaintext
Copiar código
default via 192.168.0.1 dev eth0 proto static metric 100
10.17.3.0/24 via 192.168.0.42 dev eth0
10.17.4.0/24 via 192.168.0.42 dev eth0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.20 metric 100
Configuración de freeipa1
Configuración de la Dirección IP
Verificar la configuración actual de la dirección IP:
bash
Copiar código
ip addr
Verificar la configuración de rutas:
bash
Copiar código
sudo ip route
Salida esperada:
plaintext
Copiar código
default via 10.17.3.1 dev eth0 proto dhcp src 10.17.3.11 metric 100
10.17.3.0/24 dev eth0 proto kernel scope link src 10.17.3.11 metric 100
Configuración de Redes NAT en el Servidor
Configuración de Redes Virtuales
Red br0 - Bridge Network

hcl
Copiar código
resource "libvirt_network" "br0" {
  name      = "br0"
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}
Red kube_network_02 - NAT Network

hcl
Copiar código
resource "libvirt_network" "kube_network_02" {
  name      = "kube_network_02"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.3.0/24"]
}
Red kube_network_03 - NAT Network

hcl
Copiar código
resource "libvirt_network" "kube_network_03" {
  name      = "kube_network_03"
  mode      = "nat"
  autostart = true
  addresses = ["10.17.4.0/24"]
}
Configuración de iptables en el Servidor
Instalación de iptables

Actualizar la lista de paquetes:
bash
Copiar código
sudo dnf update -y
Instalar iptables:
bash
Copiar código
sudo dnf install iptables iptables-services -y
Crear el archivo de servicio para iptables

Crear el archivo de servicio:
bash
Copiar código
sudo nano /usr/lib/systemd/system/iptables.service
Contenido del archivo:
ini
Copiar código
[Unit]
Description=IPv4 firewall with iptables
AssertPathExists=/etc/sysconfig/iptables
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/libexec/iptables/iptables.init start
ExecReload=/usr/libexec/iptables/iptables.init reload
ExecStop=/usr/libexec/iptables/iptables.init stop
Environment=BOOTUP=serial
Environment=CONSOLETYPE=serial

[Install]
WantedBy=multi-user.target
Crear el archivo de configuración de iptables

Crear el archivo de configuración:
bash
Copiar código
sudo nano /etc/sysconfig/iptables
Agregar las reglas necesarias:
plaintext
Copiar código
*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]

# Enmascaramiento para las redes NAT
-A POSTROUTING -s 10.17.3.0/24 -o enp3s0f1 -j MASQUERADE
-A POSTROUTING -s 10.17.4.0/24 -o enp3s0f1 -j MASQUERADE

COMMIT

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]

# Permitir tráfico hacia y desde las redes NAT
-A FORWARD -i enp3s0f1 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i enp3s0f1 -o virbr1 -m state --state RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -i virbr0 -o enp3s0f1 -j ACCEPT
-A FORWARD -i virbr1 -o enp3s0f1 -j ACCEPT

# Permitir tráfico entre las redes NAT
-A FORWARD -i virbr0 -o virbr1 -j ACCEPT
-A FORWARD -i virbr1 -o virbr0 -j ACCEPT

COMMIT
Habilitar y Arrancar el Servicio iptables

Recargar los archivos de configuración del sistema:
bash
Copiar código
sudo systemctl daemon-reload
Habilitar el servicio iptables para que se inicie al arranque:
bash
Copiar código
sudo systemctl enable iptables
Iniciar el servicio iptables:
bash
Copiar código
sudo systemctl start iptables
Verificación del Estado del Servicio iptables

Verificar el estado del servicio iptables:
bash
Copiar código
sudo systemctl status iptables
Habilitación del Reenvío de IP
Habilitar Temporalmente el Reenvío de IP

bash
Copiar código
sudo sysctl -w net.ipv4.ip_forward=1
Habilitar Permanentemente el Reenvío de IP

Editar el archivo de configuración sysctl:
bash
Copiar código
sudo nano /etc/sysctl.conf
Asegúrese de que la siguiente línea esté presente:
plaintext
Copiar código
net.ipv4.ip_forward = 1
Aplicar la configuración:
bash
Copiar código
sudo sysctl -p
Verificación de la Conectividad
Verificar Conectividad con Pings

Desde bastion1:

bash
Copiar código
ping -c 2 192.168.0.20
ping -c 2 10.17.4.20
ping -c 2 10.17.3.11
ping -c 2 10.17.4.1
ping -c 2 10.17.3.1
ping -c 2 8.8.8.8
Desde bootstrap1:

bash
Copiar código
ping -c 2 192.168.0.20
ping -c 2 10.17.4.20
ping -c 2 10.17.3.11
ping -c 2 10.17.4.1
ping -c 2 10.17.3.1
ping -c 2 8.8.8.8
Desde freeipa1:

bash
Copiar código
ping -c 2 192.168.0.20
ping -c 2 10.17.4.20
ping -c 2 10.17.3.11
ping -c 2 10.17.4.1
ping -c 2 10.17.3.1
ping -c 2 8.8.8.8
Verificar la Configuración de Red y Rutas

Verificar direcciones IP:
bash
Copiar código
ip addr
Verificar las rutas:
bash
Copiar código
sudo ip route
Verificar la información del sistema:
bash
Copiar código
hostnamectl
Conclusión
Siguiendo estos pasos, hemos configurado con éxito el enrutamiento y las reglas de firewall para permitir la conectividad adecuada entre las diferentes redes en el entorno cefaslocalserver.com. Esta documentación proporciona una guía detallada para replicar esta configuración en otros entornos similares.