#!/bin/bash

# Definir el archivo de reporte
reporte="reporte_conectividad.log"

# Limpiar el archivo de reporte anterior
> "$reporte"

# Encabezado de la tabla
echo -e "IP Address\t\tStatus" >> "$reporte"
echo -e "----------\t\t------" >> "$reporte"

# Lista de direcciones IP
ips=("192.168.0.20" "10.17.4.20" "10.17.3.11" "10.17.4.1" "10.17.3.1" "8.8.8.8")

# Función para hacer ping y guardar errores
ping_and_log() {
    local ip=$1
    if ping -c 4 "$ip" > /dev/null 2>> "$reporte"; then
        echo -e "$ip\t\tSuccess" >> "$reporte"
    else
        echo -e "$ip\t\tFailed" >> "$reporte"
    fi
}

# Función para mostrar la barra de progreso
show_progress() {
    local progress=$1
    local total=$2
    local percent=$(( progress * 100 / total ))
    local bar=""

    for ((i = 0; i < percent; i += 2)); do
        bar="${bar}#"
    done

    printf "\r[%-50s] %d%%" "$bar" "$percent"
}

# Realizar pings y registrar resultados en la tabla con barra de progreso
total_ips=${#ips[@]}
for i in "${!ips[@]}"; do
    ping_and_log "${ips[$i]}"
    show_progress $((i + 1)) $total_ips
done

echo

# Comprobar si hubo errores y agregar el resultado final
if grep -q "Failed" "$reporte"; then
    echo -e "\nConectividad Fallida" >> "$reporte"
else
    echo -e "\nConectividad Exitosa" >> "$reporte"
fi

# Mostrar el reporte
cat "$reporte"
