# Creación de un Adaptador Puente (Bridge) en Linux

Para configurar un adaptador puente en un sistema Linux, existen dos métodos principales: utilizando la herramienta de línea de comandos `nmcli` para gestionar NetworkManager, o editando manualmente los archivos de configuración de NetworkManager. A continuación se detallan los pasos para ambos métodos:

## Método 1: Usando `nmcli`

`nmcli` es una herramienta de línea de comandos para controlar NetworkManager, útil para scripts y automatización.

### Paso 1: Crear el puente `br0`
Para crear un puente, utiliza el siguiente comando:
```bash
sudo nmcli connection add type bridge ifname br0 con-name br0
