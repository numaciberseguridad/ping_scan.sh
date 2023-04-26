#!/bin/bash

# Verifica si se proporcionó un rango de IP
if [ $# -ne 2 ]; then
    echo "Uso: $0 <IP inicial> <IP final>"
    exit 1
fi

# Define las IP inicial y final del rango
IP_INICIAL=$1
IP_FINAL=$2

# Función para convertir una IP a formato numérico
ip_a_numero() {
    local IFS=.
    local ip=($1)
    echo $(( (${ip[0]} * 256 ** 3) + (${ip[1]} * 256 ** 2) + (${ip[2]} * 256) + ${ip[3]} ))
}

# Función para convertir un número a formato IP
numero_a_ip() {
    local num=$1
    local ip1=$((num >> 24))
    local ip2=$(( (num >> 16) & 255 ))
    local ip3=$(( (num >> 8) & 255 ))
    local ip4=$(( num & 255 ))
    echo "$ip1.$ip2.$ip3.$ip4"
}

# Convierte las IP a números
NUM_IP_INICIAL=$(ip_a_numero "$IP_INICIAL")
NUM_IP_FINAL=$(ip_a_numero "$IP_FINAL")

# Realiza un ping a cada IP del rango y muestra las IP activas
for num_ip in $(seq "$NUM_IP_INICIAL" "$NUM_IP_FINAL"); do
    ip_actual=$(numero_a_ip "$num_ip")
    ping -c 1 -W 1 "$ip_actual" &> /dev/null

    if [ $? -eq 0 ]; then
        echo "IP activa: $ip_actual"
    fi
done
