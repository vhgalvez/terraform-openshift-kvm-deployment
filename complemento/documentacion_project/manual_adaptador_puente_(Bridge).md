# Creación Manual de un Adaptador Puente (Bridge)

Puedes crear manualmente un adaptador puente (bridge) usando `nmcli` o directamente editando los archivos de configuración en `/etc/NetworkManager/system-connections/`. Aquí te dejo ambos métodos.

## Método 1: Usando nmcli

1. **Crear el puente `br0`:**

```bash
   sudo nmcli connection add type bridge ifname br0 con-name br0
```

### Agregar la interfaz esclava al puente br0:

```bash
sudo nmcli connection add type ethernet ifname enp3s0f0 con-name bridge-slave-enp3s0f0 master br0
```

### Configurar el puente para obtener una IP mediante DHCP:

```bash
sudo nmcli connection modify br0 ipv4.method auto ipv6.method ignore
```

### Activar la conexión del puente br0:

```bash
sudo nmcli connection up br0
```

### Verificar el estado del puente br0:

```bash
nmcli device status
ip addr show br0
sudo brctl show
```

## Método 2: Editando Archivos de Configuración

Crear el archivo de configuración para el puente br0:

Crear el archivo /etc/NetworkManager/system-connections/br0.nmconnection con el siguiente contenido:

```ini
[connection]
id=br0
uuid=e3bdeaea-c256-4592-aef2-8e4639b66dc2
type=bridge
interface-name=br0

[ethernet]

[bridge]

[ipv4]
method=auto

[ipv6]
addr-gen-mode=default
method=auto

[proxy]
```

Crear el archivo de configuración para la interfaz esclava enp3s0f0:

Crear el archivo /etc/NetworkManager/system-connections/bridge-slave-enp3s0f0.nmconnection con el siguiente contenido:

```ini
[connection]
id=bridge-slave-enp3s0f0
uuid=92822580-241e-40ec-9f17-55649b2b0df3
type=ethernet
interface-name=enp3s0f0
master=br0
slave-type=bridge

[ethernet]

[bridge-port]
```

### Reiniciar NetworkManager para aplicar las configuraciones:

```bash
sudo systemctl restart NetworkManager
```

Verificar el estado de las interfaces y el puente:

```bash
nmcli device status
ip addr show br0
sudo brctl show
```

Estos métodos deberían permitirte crear y configurar manualmente el adaptador puente (br0). Si ya has creado configuraciones previas, asegúrate de eliminarlas o modificarlas para evitar conflictos.




Documentación de la Configuración de un Adaptador Puente (Bridge)
Resumen
En esta configuración, se ha creado un adaptador puente (br0) en un servidor para conectar varias interfaces de red y permitir que las máquinas virtuales (VMs) se comuniquen con la red física del servidor. El puente (br0) actúa como un switch virtual, permitiendo el flujo de tráfico de red entre las interfaces conectadas.

Topología de Red
Router de Fibra Óptica: Conexión a internet y asignación de direcciones IP mediante DHCP.
Switch TP-Link LS1008G: Conecta las interfaces físicas del servidor al router.
Servidor ProLiant DL380 G7: Configurado con múltiples interfaces de red y un adaptador puente.
Interfaces de Red Identificadas en el Servidor
enp3s0f0: 192.168.0.15 (Interfaz general del servidor)
enp3s0f1: 192.168.0.16 (Utilizada para Bridge en el nodo bastion1)
enp4s0f0: 192.168.0.20 (Otra interfaz general del servidor)
enp4s0f1: 192.168.0.18 (Reserva o conexión redundante)
lo (Loopback): 127.0.0.1 (Tráfico local solo)
Configuración del Adaptador Puente (Bridge)
Paso 1: Creación del Puente br0
Se creó un puente (br0) utilizando nmcli o editando los archivos de configuración en /etc/NetworkManager/system-connections/. Este puente actúa como un switch virtual, conectando las interfaces físicas del servidor.

Paso 2: Adición de la Interfaz enp3s0f0 al Puente br0
La interfaz enp3s0f0 se añadió al puente br0, permitiendo que el tráfico de red fluya a través del puente.

Paso 3: Configuración del Puente para Obtener una IP Mediante DHCP
El puente br0 se configuró para obtener una dirección IP automáticamente mediante DHCP, facilitando la administración de la red.

Paso 4: Activación del Puente br0
La conexión del puente br0 se activó para permitir el flujo de tráfico de red.

Paso 5: Verificación del Estado del Puente y las Interfaces
Se verificó el estado del puente br0 y las interfaces conectadas para asegurar que todo esté configurado correctamente.

Flujo de Conexiones
Router de Fibra Óptica: Asigna direcciones IP a través de DHCP y conecta a internet.
Switch TP-Link LS1008G: Conecta las interfaces físicas del servidor al router, facilitando el tráfico de red.
Servidor ProLiant DL380 G7:
Interfaz enp3s0f0: Conectada al puente br0.
Puente br0: Actúa como un switch virtual, conectando la interfaz enp3s0f0 y permitiendo el tráfico de red entre la red física y las máquinas virtuales.
Configuración de Red
Open vSwitch: Utilizado para la gestión de redes virtuales y VLANs.
VPN con WireGuard: Proporciona acceso seguro para la administración del servidor y el clúster.
Firewall: Configuración de reglas para proteger el clúster.
Modo NAT y Bridge: Facilita la conexión y comunicación entre las VMs y la red física.
DHCP en KVM: Asigna automáticamente direcciones IP a las VMs.
Configuración de la Infraestructura de Red
Switch: Conecta las interfaces físicas del servidor al router, permitiendo la comunicación y conectividad del clúster.
Router de Fibra Óptica: Proporciona acceso a internet y asigna direcciones IP mediante DHCP.
Bastion Node: Configurado en modo bridge, conectando enp3s0f1 al puente br0 para proporcionar un punto de acceso seguro.
Redes NAT: Configuradas para permitir la comunicación entre las VMs y la red física, utilizando reglas de enrutamiento y firewall para gestionar el tráfico entre las redes NAT y el puente br0.
Seguridad y Protección
Firewall: Configuración de reglas para proteger el tráfico que cruza diferentes segmentos de red.
VPN con WireGuard: Proporciona acceso seguro para la gestión del servidor y el clúster.
DNS y FreeIPA: Gestión centralizada de autenticación y políticas de seguridad.
Almacenamiento Persistente
Rook y Ceph: Implementados en Kubernetes para proporcionar almacenamiento persistente para las aplicaciones y servicios del clúster.
Consideraciones Finales
Este diseño de red permite una comprensión clara de cómo se pueden estructurar y gestionar eficazmente las redes dentro de un entorno de clúster, asegurando tanto la funcionalidad como la seguridad. Las configuraciones de firewall, VPN y Open vSwitch son esenciales para proteger y gestionar el tráfico de red, mientras que las configuraciones de DHCP y NAT facilitan la administración y conectividad de las VMs.