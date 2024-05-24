Opción 1: Usar un Script de Inicio

Crea el directorio si no existe:

bash
Copiar código
sudo mkdir -p /etc/network/if-pre-up.d/
Crea el script de inicio:

bash
Copiar código
sudo nano /etc/network/if-pre-up.d/iptables
Añade las siguientes líneas al script:

bash
Copiar código
#!/bin/sh
/sbin/iptables-restore < /etc/iptables/rules.v4
Guarda el archivo y hazlo ejecutable:

bash
Copiar código
sudo chmod +x /etc/network/if-pre-up.d/iptables
Opción 2: Usar un Servicio de iptables

Crea un archivo de servicio para iptables:

bash
Copiar código
sudo nano /etc/systemd/system/iptables-restore.service
Añade las siguientes líneas al archivo del servicio:

ini
Copiar código
[Unit]
Description=Restore iptables rules
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
ExecStart=/sbin/iptables-restore /etc/iptables/rules.v4
ExecReload=/sbin/iptables-restore /etc/iptables/rules.v4
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
Guarda el archivo y carga el servicio en systemd:

bash
Copiar código
sudo systemctl daemon-reload
sudo systemctl enable iptables-restore.service
sudo systemctl start iptables-restore.service