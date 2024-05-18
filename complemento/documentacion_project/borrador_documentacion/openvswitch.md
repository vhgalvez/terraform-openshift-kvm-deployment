# Instalar Open vSwitch si aún no está instalado
sudo dnf install openvswitch

# Iniciar el servicio Open vSwitch
sudo systemctl start openvswitch
sudo systemctl enable openvswitch

# Crear un puente OVS
sudo ovs-vsctl add-br br0

# Asignar una dirección IP al puente, si aún no está configurada
sudo ip addr add 192.168.0.25/24 dev br0
sudo ip link set dev br0 up

 

sudo ovs-vsctl del-br br0
sudo systemctl stop openvswitch
sudo systemctl disable openvswitch


sudo systemctl restart network
sudo systemctl restart NetworkManager
sudo systemctl restart NetworkManager

# Crear un puente OVS
sudo ovs-vsctl add-br br0

# Asignar una dirección IP al puente, si aún no está configurada
sudo ip link set dev br0 up


sudo ip addr add 192.168.0.25/24 dev br0
