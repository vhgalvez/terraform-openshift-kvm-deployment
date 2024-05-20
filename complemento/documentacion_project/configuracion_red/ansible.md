# Configuración de Rutas Estáticas con Ansible

Este documento describe los pasos para configurar rutas estáticas en máquinas virtuales utilizando Ansible. Asumimos que Ansible se instalará en el servidor físico ProLiant DL380 G7, que tiene acceso a todas las máquinas virtuales.

## Paso 1: Instalar Ansible

En el servidor ProLiant DL380 G7, instala Ansible con los siguientes comandos:

```bash
sudo dnf install epel-release -y
sudo dnf install ansible -y
```


## Paso 2: Configurar el Inventario de Ansible

Crea un archivo de inventario llamado hosts que contenga la información de las máquinas virtuales. Puedes crear este archivo en el directorio /etc/ansible o en un directorio de tu elección.

```ini
# /etc/ansible/hosts

[kube_network_02]
freeipa1 ansible_host=10.17.3.11
load_balancer1 ansible_host=10.17.3.12
postgresql1 ansible_host=10.17.3.13

[kube_network_03]
bootstrap1 ansible_host=10.17.4.20
master1 ansible_host=10.17.4.21
master2 ansible_host=10.17.4.22
master3 ansible_host=10.17.4.23
worker1 ansible_host=10.17.4.24
worker2 ansible_host=10.17.4.25
worker3 ansible_host=10.17.4.26

[all:vars]
ansible_user=core
ansible_ssh_private_key_file=/root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift
```

## Paso 3: Crear el Playbook de Ansible

Crea un archivo llamado `configurar_rutas.yml` con el siguiente contenido:


```yaml
# /etc/ansible/configurar_rutas.yml

---
- name: Configurar rutas estáticas en las máquinas virtuales
  hosts: all
  become: yes
  tasks:
    - name: Agregar ruta estática a la red bridge para kube_network_02
      ansible.builtin.command:
        cmd: ip route add 192.168.0.0/24 via {{ gateway }}
      when: inventory_hostname in groups['kube_network_02']
      vars:
        gateway: 10.17.3.1

    - name: Agregar ruta estática a la red bridge para kube_network_03
      ansible.builtin.command:
        cmd: ip route add 192.168.0.0/24 via {{ gateway }}
      when: inventory_hostname in groups['kube_network_03']
      vars:
        gateway: 10.17.4.1
```

## Paso 4: Ejecutar el Playbook

Ejecuta el playbook con el siguiente comando desde el servidor ProLiant DL380 G7:

```bash
ansible-playbook -i /etc/ansible/hosts /etc/ansible/configurar_rutas.yml
```


## Explicación

- Inventario de Ansible (hosts): Define los grupos de hosts (kube_network_02 y kube_network_03) y especifica las direcciones IP y las variables necesarias para la conexión SSH.
- Playbook de Ansible (configurar_rutas.yml): Define las tareas que se ejecutarán en cada host. Utiliza el módulo command para agregar las rutas estáticas. El uso de when y vars permite definir diferentes gateways para cada grupo de hosts.
- Ejecución del Playbook: El comando ansible-playbook ejecuta el playbook en los hosts definidos en el inventario, configurando las rutas estáticas como se especifica.

## Notas Adicionales

- Asegúrate de que las máquinas virtuales sean accesibles por SSH. Verifica que puedes conectarte a cada una de ellas usando la clave SSH especificada.
- Verifica que el usuario y la clave SSH sean correctos. El usuario core y la clave privada /root/.ssh/cluster_openshift/key_cluster_openshift/id_rsa_key_cluster_openshift deben ser correctos y tener permisos adecuados.
- Si encuentras problemas de conectividad o permisos, verifica los logs de Ansible y ajusta las configuraciones según sea necesario.
Esta configuración de Ansible es más escalable y eficiente, ya que permite aplicar configuraciones en múltiples máquinas virtuales en paralelo, asegurando consistencia y ahorrando tiempo.
