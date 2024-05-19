# Creación de un Adaptador Puente (Bridge) en Linux

Para configurar un adaptador puente en un sistema Linux, existen dos métodos principales: utilizando la herramienta de línea de comandos `nmcli` para gestionar NetworkManager, o editando manualmente los archivos de configuración de NetworkManager. A continuación se detallan los pasos para ambos métodos:

## Método 1: Usando `nmcli`

`nmcli` es una herramienta de línea de comandos para controlar NetworkManager, útil para scripts y automatización.

### Paso 1: Crear el puente `br0`

Para crear un puente, utiliza el siguiente comando:

```bash
sudo nmcli connection add type bridge ifname br0 con-name br0
```

Este comando crea un nuevo puente denominado `br0`.

### Paso 2: Agregar una interfaz esclava al puente

Para agregar una interfaz Ethernet como esclava al puente, usa este comando:

```bash
sudo nmcli connection add type ethernet ifname enp3s0f0 con-name bridge-slave-enp3s0f0 master br0
```

Este comando configura la interfaz `enp3s0f0` para que funcione como parte del puente `br0`.

### Paso 3: Configurar el puente para obtener una dirección IP automáticamente

Configura el puente para obtener una dirección IP mediante DHCP:

```bash
sudo nmcli connection modify br0 ipv4.method auto ipv6.method ignore
```

Para activar el puente, ejecuta:

### Paso 4: Activar la conexión del puente

Para activar el puente, ejecuta:

```bash
sudo nmcli connection up br0
```

### Paso 5: Verificar el estado del puente

Para verificar que el puente está configurado correctamente, puedes comprobar su estado con:

```bash
nmcli device status
ip addr show br0
sudo brctl show
```

## Método 2: Editando Archivos de Configuración

Este método implica editar directamente los archivos de configuración de NetworkManager.

### Paso 1: Crear el archivo de configuración del puente br0


Crea un archivo en `/etc/NetworkManager/system-connections/` con el nombre `br0.nmconnection` y el siguiente contenido:

```ini
[connection]
id=br0
uuid=e3bdeaea-c256-4592-aef2-8e4639b66dc2
type=bridge
interface-name=br0

[ipv4]
method=auto

[ipv6]
method=auto
addr-gen-mode=default
```

### Paso 2: Crear el archivo de configuración para la interfaz esclava

Crea otro archivo en `/etc/NetworkManager/system-connections/` con el nombre `bridge-slave-enp3s0f0.nmconnection` y el siguiente contenido:


```ini
[connection]
id=bridge-slave-enp3s0f0
uuid=92822580-241e-40ec-9f17-55649b2b0df3
type=ethernet
interface-name=enp3s0f0
master=br0
slave-type=bridge
```

### Paso 3: Reiniciar NetworkManager

Para aplicar las configuraciones, reinicia NetworkManager:


```bash
sudo systemctl restart NetworkManager
```

### Paso 4: Verificar el estado

Finalmente, verifica el estado de las interfaces y el puente con los mismos comandos utilizados en el método 1.

Ambos métodos son efectivos para configurar un adaptador puente en Linux, y la elección entre uno u otro puede depender de si prefieres una solución de línea de comandos o trabajar directamente con archivos de configuración.