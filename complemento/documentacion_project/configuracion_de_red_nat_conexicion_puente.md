Documentación Técnica para Configuración de Comunicación entre Redes NAT y una Red Bridge en KVM
Este documento proporciona una guía detallada sobre cómo configurar la comunicación entre redes NAT y una red puente (bridge) en un entorno KVM. La configuración se realiza en un servidor KVM físico y sus máquinas virtuales (VMs).

1. Configuración de la Red Bridge (Bridge Network)
Paso 1: Asegurar que la Red Bridge esté Configurada y Funcionando
La red bridge (br0) debe estar configurada y operativa. En tu configuración de Terraform, esto se ha definido como:

terraform
Copiar código
# Red br0 - Bridge Network - Rocky Linux 9.3
resource "libvirt_network" "br0" {
  name      = var.rocky9_network_name
  mode      = "bridge"
  bridge    = "br0"
  autostart = true
  addresses = ["192.168.0.0/24"]
}
2. Habilitar el Reenvío de IP en el Servidor KVM
El reenvío de IP debe estar habilitado en el servidor KVM para permitir la comunicación entre las redes NAT y la red bridge.

Paso 2: Editar el Archivo sysctl.conf
En el servidor KVM físico (Servidor KVM: ProLiant DL380 G7), edita el archivo /etc/sysctl.conf y añade la siguiente línea:

sh
Copiar código
net.ipv4.ip_forward = 1
Paso 3: Aplicar los Cambios
Ejecuta el siguiente comando para aplicar los cambios:

sh
Copiar código
sudo sysctl -p
3. Configurar el Enrutamiento entre las Redes
Necesitarás agregar las reglas de enrutamiento necesarias para permitir la comunicación entre las redes NAT y la red bridge utilizando iptables.

Paso 4: Agregar Reglas de Enrutamiento
Configuración para nat_network_02
sh
Copiar código
# En el servidor KVM físico
sudo iptables -t nat -A POSTROUTING -s 10.17.3.0/24 -o br0 -j MASQUERADE
sudo iptables -A FORWARD -i br0 -o virbr0 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i virbr0 -o br0 -j ACCEPT
Configuración para nat_network_03
sh
Copiar código
# En el servidor KVM físico
sudo iptables -t nat -A POSTROUTING -s 10.17.4.0/24 -o br0 -j MASQUERADE
sudo iptables -A FORWARD -i br0 -o virbr1 -m state --state RELATED,ESTABLISHED -j ACCEPT
sudo iptables -A FORWARD -i virbr1 -o br0 -j ACCEPT
4. Persistir las Reglas de iptables
Para asegurar que las reglas de iptables se mantengan después de un reinicio, utiliza iptables-save y iptables-restore.

Paso 5: Guardar las Reglas Actuales
sh
Copiar código
# En el servidor KVM físico
sudo iptables-save > /etc/iptables/rules.v4
Paso 6: Configurar la Restauración de las Reglas al Inicio
En sistemas basados en Debian/Ubuntu, puedes hacerlo añadiendo el siguiente comando en el archivo /etc/network/interfaces o en un script de inicio:

sh
Copiar código
iptables-restore < /etc/iptables/rules.v4
5. Configurar las Rutas en las Máquinas Virtuales
Asegúrate de que las máquinas virtuales en las redes NAT sepan cómo llegar a la red bridge. Esto generalmente implica agregar rutas estáticas en las máquinas virtuales.

Paso 7: Agregar Rutas Estáticas
Ejemplo en una Máquina Virtual en nat_network_02
En la VM freeipa1:

sh
Copiar código
sudo ip route add 192.168.0.0/24 via 10.17.3.1
Aquí, 10.17.3.1 es la puerta de enlace de la red NAT nat_network_02.

6. Verificar la Conectividad
Finalmente, verifica la conectividad entre las máquinas virtuales en las redes NAT y la red bridge utilizando herramientas como ping.

Paso 8: Comprobar la Conexión
En la VM freeipa1 en nat_network_02:

sh
Copiar código
ping 192.168.0.35
Este comando debería hacer ping a la IP del nodo bastión bastion1 en la red bridge br0.

Resumen
Para lograr la comunicación entre redes NAT y la red bridge (bridge) en tu entorno KVM, debes:

Configurar correctamente la red bridge (br0).
Habilitar el reenvío de IP en el servidor KVM.
Configurar las reglas de iptables para enmascarar y permitir el tráfico entre las redes.
Persistir las reglas de iptables.
Agregar las rutas necesarias en las máquinas virtuales.
Verificar la conectividad.
Siguiendo estos pasos, podrás establecer comunicación entre tus redes NAT y la red bridge en tu entorno KVM.

Para cualquier duda o problema, por favor, abre un issue en el repositorio o contacta al mantenedor del proyecto.

Mantenedor del Proyecto: Victor Galvez