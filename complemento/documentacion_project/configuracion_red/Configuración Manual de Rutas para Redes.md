# Configuración Manual de Rutas para Redes NAT y Bridge
Para configurar manualmente las rutas de red en las máquinas virtuales bastion1, bootstrap1, y freeipa1, siga las siguientes instrucciones. Estas rutas permitirán la correcta comunicación entre las distintas redes NAT y la red bridge.

Configuración de las Rutas en bastion1
Añadir ruta para kube_network_02 (10.17.3.0/24)

bash
Copiar código
sudo ip route add 10.17.3.0/24 via 192.168.0.42
Añadir ruta para kube_network_03 (10.17.4.0/24)

bash
Copiar código
sudo ip route add 10.17.4.0/24 via 192.168.0.42
Configuración de las Rutas en bootstrap1
Añadir ruta para br0 (192.168.0.0/24)

bash
Copiar código
sudo ip route add 192.168.0.0/24 via 10.17.4.1
Añadir ruta para kube_network_02 (10.17.3.0/24)

bash
Copiar código
sudo ip route add 10.17.3.0/24 via 10.17.4.1
Configuración de las Rutas en freeipa1
Añadir ruta para br0 (192.168.0.0/24)

bash
Copiar código
sudo ip route add 192.168.0.0/24 via 10.17.3.1
Añadir ruta para kube_network_03 (10.17.4.0/24)

bash
Copiar código
sudo ip route add 10.17.4.0/24 via 10.17.3.1
Resumen de Configuración de Rutas
Para bastion1:
bash
Copiar código
sudo ip route add 10.17.3.0/24 via 192.168.0.42
sudo ip route add 10.17.4.0/24 via 192.168.0.42
Para bootstrap1:
bash
Copiar código
sudo ip route add 192.168.0.0/24 via 10.17.4.1
sudo ip route add 10.17.3.0/24 via 10.17.4.1
Para freeipa1:
bash
Copiar código
sudo ip route add 192.168.0.0/24 via 10.17.3.1
sudo ip route add 10.17.4.0/24 via 10.17.3.1
Verificación de la Configuración de Rutas
Después de configurar las rutas, puede verificar que se hayan añadido correctamente utilizando el siguiente comando en cada máquina virtual:

bash
Copiar código
sudo ip route
La salida debe mostrar las rutas configuradas según lo especificado. Por ejemplo, en bastion1, debería ver algo similar a:

plaintext
Copiar código
default via 192.168.0.1 dev eth0 proto static metric 100
10.17.3.0/24 via 192.168.0.42 dev eth0
10.17.4.0/24 via 192.168.0.42 dev eth0
192.168.0.0/24 dev eth0 proto kernel scope link src 192.168.0.20 metric 100
Conclusión
Estas configuraciones manuales de rutas permiten que las máquinas virtuales en las diferentes redes (bridge y NAT) se comuniquen correctamente entre sí. Esta configuración es esencial para asegurar una correcta conectividad en el entorno cefaslocalserver.com.