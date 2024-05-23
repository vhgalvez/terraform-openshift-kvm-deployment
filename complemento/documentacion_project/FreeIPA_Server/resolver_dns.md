Aquí tienes una guía paso a paso para configurar la resolución de DNS manualmente en tus máquinas virtuales, tanto para Rocky Linux como para Flatcar Linux. Esta guía cubre cómo actualizar el archivo resolv.conf y configurar NetworkManager en cada sistema operativo.

Configuración de DNS en Rocky Linux
Paso 1: Editar /etc/resolv.conf
Accede a la máquina Rocky Linux (bastion, freeipa, load_balancer, postgresql) mediante SSH.

Abre el archivo /etc/resolv.conf con un editor de texto:

sh
Copy code
sudo nano /etc/resolv.conf
Añade las entradas de los servidores DNS:

sh
Copy code
nameserver 10.17.3.11
nameserver 8.8.8.8
Guarda y cierra el archivo.

Paso 2: Hacer que el archivo resolv.conf sea inmutable
Ejecuta el siguiente comando para evitar que el archivo resolv.conf sea modificado por otros servicios:

sh
Copy code
sudo chattr +i /etc/resolv.conf
Paso 3: Configurar NetworkManager
Crea un archivo de configuración para NetworkManager:

sh
Copy code
sudo nano /etc/NetworkManager/conf.d/dns.conf
Añade el siguiente contenido:

sh
Copy code
[main]
dns=none
Guarda y cierra el archivo.

Reinicia NetworkManager para aplicar los cambios:

sh
Copy code
sudo systemctl restart NetworkManager
Configuración de DNS en Flatcar Linux
Paso 1: Acceder a la máquina Flatcar Linux
Accede a la máquina Flatcar Linux (bootstrap, master1, master2, master3, worker1, worker2, worker3) mediante SSH.
Paso 2: Editar /etc/resolv.conf
Monta el sistema de archivos / como read-write:

sh
Copy code
sudo mount -o remount,rw /
Abre el archivo /etc/resolv.conf con un editor de texto:

sh
Copy code
sudo nano /etc/resolv.conf
Añade las entradas de los servidores DNS:

sh
Copy code
nameserver 10.17.3.11
nameserver 8.8.8.8
Guarda y cierra el archivo.

Paso 3: Hacer que el archivo resolv.conf sea inmutable
Ejecuta el siguiente comando para evitar que el archivo resolv.conf sea modificado por otros servicios:

sh
Copy code
sudo chattr +i /etc/resolv.conf
Paso 4: Configurar systemd-networkd
Crea un archivo de configuración para systemd-networkd:

sh
Copy code
sudo nano /etc/systemd/network/00-dns.conf
Añade el siguiente contenido:

sh
Copy code
[Network]
DNS=10.17.3.11 8.8.8.8
Guarda y cierra el archivo.

Reinicia systemd-networkd para aplicar los cambios:

sh
Copy code
sudo systemctl restart systemd-networkd
Paso 5: Montar el sistema de archivos / como read-only (opcional)
Si deseas volver a montar el sistema de archivos / como read-only:

sh
Copy code
sudo mount -o remount,ro /
Validación de la Configuración
Después de realizar los cambios en cada máquina, puedes validar la configuración de DNS ejecutando el siguiente comando:

sh
Copy code
nslookup <hostname>
Por ejemplo:

sh
Copy code
nslookup master1.localcefas.com
Si la configuración es correcta, deberías ver la dirección IP correspondiente al nombre de host.

Resumen de los Hostnames e IPs
bootstrap.localcefas.com - 10.17.4.20
master1.localcefas.com - 10.17.4.21
master2.localcefas.com - 10.17.4.22
master3.localcefas.com - 10.17.4.23
worker1.localcefas.com - 10.17.4.24
worker2.localcefas.com - 10.17.4.25
worker3.localcefas.com - 10.17.4.26
bastion.localcefas.com - 192.168.0.20
freeipa.localcefas.com - 10.17.3.11
lb.localcefas.com - 10.17.3.12
db.localcefas.com - 10.17.3.13
bastion1.localcefas.com - 192.168.0.20
Esta guía debe ayudarte a configurar manualmente la resolución de DNS en tus máquinas virtuales Rocky Linux y Flatcar Linux.