#!/bin/bash

# Ruta a la clave SSH
SSH_KEY="/root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift"
USER="core"

# Función para agregar rutas en una VM
add_route() {
    local ip=$1
    local gateway=$2
    echo "Configurando ruta en $ip (Gateway: $gateway)"
    ssh -i "$SSH_KEY" "${USER}@${ip}" "sudo ip route add 192.168.0.0/24 via $gateway"
}

# kube_network_02
add_route "10.17.3.11" "10.17.3.1"  # freeipa1
add_route "10.17.3.12" "10.17.3.1"  # load_balancer1
add_route "10.17.3.13" "10.17.3.1"  # postgresql1

# kube_network_03
add_route "10.17.4.20" "10.17.4.1"  # bootstrap1
add_route "10.17.4.21" "10.17.4.1"  # master1
add_route "10.17.4.22" "10.17.4.1"  # master2
add_route "10.17.4.23" "10.17.4.1"  # master3
add_route "10.17.4.24" "10.17.4.1"  # worker1
add_route "10.17.4.25" "10.17.4.1"  # worker2
add_route "10.17.4.26" "10.17.4.1"  # worker3

echo "Configuración de rutas completada."
