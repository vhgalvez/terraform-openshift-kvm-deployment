# Configuración de DNS en Rocky Linux y Flatcar Linux

Aquí tienes una guía paso a paso para configurar la resolución de DNS manualmente en tus máquinas virtuales, tanto para Rocky Linux como para Flatcar Linux. Esta guía cubre cómo actualizar el archivo resolv.conf y configurar NetworkManager en cada sistema operativo.

Configuración de DNS en Rocky Linux

Paso 1: Editar `/etc/resolv.conf`

Accede a la máquina Rocky Linux (bastion, freeipa, load_balancer, postgresql) mediante SSH.

Abre el archivo `/etc/resolv.conf` con un editor de texto:


```bash
sudo nano /etc/resolv.conf
```

Añade las entradas de los servidores DNS:


```bash
nameserver 10.17.3.11
nameserver 8.8.8.8
```

Guarda y cierra el archivo.

Paso 2: Hacer que el archivo resolv.conf sea inmutable
Ejecuta el siguiente comando para evitar que el archivo resolv.conf sea modificado por otros servicios:

```bash
sudo chattr +i /etc/resolv.conf
```

Paso 3: Configurar NetworkManager

Crea un archivo de configuración para NetworkManager:

```bash
sudo nano /etc/NetworkManager/conf.d/dns.conf
```

Añade el siguiente contenido:

```bash
[main]
dns=none
```

Guarda y cierra el archivo.

Reinicia NetworkManager para aplicar los cambios:

```bash
sudo systemctl restart NetworkManager
```

Configuración de DNS en Flatcar Linux

Paso 1: Acceder a la máquina Flatcar Linux

Accede a la máquina Flatcar Linux (bootstrap, master1, master2, master3, worker1, worker2, worker3) mediante SSH.

Paso 2: Editar `/etc/resolv.conf`

Monta el sistema de archivos / como read-write:

```bash
sudo mount -o remount,rw /
```

Abre el archivo /etc/resolv.conf con un editor de texto:

```bash
sudo nano /etc/resolv.conf
```

Añade las entradas de los servidores DNS:

```bash
nameserver 10.17.3.11
nameserver 8.8.8.8
```

Guarda y cierra el archivo.

Paso 3: Hacer que el archivo resolv.conf sea inmutable

Ejecuta el siguiente comando para evitar que el archivo resolv.conf sea modificado por otros servicios:


```bash
sudo chattr +i /etc/resolv.conf
```

Paso 4: Configurar systemd-networkd

Crea un archivo de configuración para systemd-networkd:

```bash
sudo nano /etc/systemd/network/00-dns.conf
```

Añade el siguiente contenido:

```bash
[Network]
DNS=10.17.3.11 8.8.8.8
```

Guarda y cierra el archivo.

Reinicia systemd-networkd para aplicar los cambios:


```bash
sudo systemctl restart systemd-networkd
```

Paso 5: Montar el sistema de archivos / como read-only (opcional)
Si deseas volver a montar el sistema de archivos / como read-only:


```bash
sudo mount -o remount,ro /
```

Validación de la Configuración

Después de realizar los cambios en cada máquina, puedes validar la configuración de DNS ejecutando el siguiente comando:


```bash
nslookup <hostname>
```

Por ejemplo:


```bash
nslookup master1.localcefas.com
```

Si la configuración es correcta, deberías ver la dirección IP correspondiente al nombre de host.

Resumen de los Hostnames e IPs

10.17.4.20 bootstrap.serverlocalcefas.com
10.17.4.21 master1.serverlocalcefas.com
10.17.4.22 master2.serverlocalcefas.com
10.17.4.23 master3.serverlocalcefas.com
10.17.4.24 worker1.serverlocalcefas.com
10.17.4.25 worker2.serverlocalcefas.com
10.17.4.26 worker3.serverlocalcefas.com
192.168.0.20 bastion.serverlocalcefas.com
10.17.3.11 freeipa.serverlocalcefas.com
10.17.3.12 lb.serverlocalcefas.com
10.17.3.13 db.serverlocalcefas
192.168.0.20 bastion1.serverlocalcefas.com

Esta guía debe ayudarte a configurar manualmente la resolución de DNS en tus máquinas virtuales Rocky Linux y Flatcar Linux.


# Configuración de DNS en Rocky Linux

```bash
10.17.4.20 bootstrap.serverlocalcefas.com
10.17.4.21 master1.serverlocalcefas.com
10.17.4.22 master2.serverlocalcefas.com
10.17.4.23 master3.serverlocalcefas.com
10.17.4.24 worker1.serverlocalcefas.com
10.17.4.25 worker2.serverlocalcefas.com
10.17.4.26 worker3.serverlocalcefas.com
192.168.0.20 bastion.serverlocalcefas.com
10.17.3.11 freeipa.serverlocalcefas.com
10.17.3.12 lb.serverlocalcefas.com
10.17.3.13 db.serverlocalcefas
192.168.0.20 bastion1.serverlocalcefas.com
```
