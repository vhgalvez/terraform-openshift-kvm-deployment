#!/bin/bash

# Función para agregar rutas en una VM
add_route() {
  local vm=$1
  local network=$2
  local gateway=$3
  echo "Configurando ruta en $vm (Red: $network, Gateway: $gateway)"
  ssh "$vm" "sudo ip route add 192.168.0.0/24 via $gateway"
}

# kube_network_02
add_route "freeipa1" "kube_network_02" "10.17.3.1"
add_route "load_balancer1" "kube_network_02" "10.17.3.1"
add_route "postgresql1" "kube_network_02" "10.17.3.1"

# kube_network_03
add_route "bootstrap1" "kube_network_03" "10.17.4.1"
add_route "master1" "kube_network_03" "10.17.4.1"
add_route "master2" "kube_network_03" "10.17.4.1"
add_route "master3" "kube_network_03" "10.17.4.1"
add_route "worker1" "kube_network_03" "10.17.4.1"
add_route "worker2" "kube_network_03" "10.17.4.1"
add_route "worker3" "kube_network_03" "10.17.4.1"

echo "Configuración de rutas completada."
