#!/bin/bash

# Script per testare la raggiungibilità di un servizio web
# Uso: ./test_web.sh

echo "=== Test Raggiungibilità Servizio Web ==="
echo

# Input parametri
read -p "Inserisci IP/hostname: " HOST
read -p "Inserisci porta: " PORT
read -p "Protocollo (http/https): " PROTOCOL
read -p "Inserisci URL path (es: /api/health): " URL_PATH

# Costruisci URL completo
FULL_URL="${PROTOCOL}://${HOST}:${PORT}${URL_PATH}"

echo
echo "Testando: $FULL_URL"
echo "Timeout: 1 secondo | Frequenza: 1 richiesta/secondo"
echo "Premi Ctrl+C per fermare"
echo "----------------------------------------"

# Contatori
SUCCESS=0
FAILED=0
COUNTER=1

# Loop infinito
while true; do
    TIMESTAMP=$(date '+%H:%M:%S')
    
    # Testa la connessione con curl
    if curl -s --max-time 1 --connect-timeout 1 "$FULL_URL" >/dev/null 2>&1; then
        echo "[$TIMESTAMP] #$COUNTER ✓ ONLINE"
        ((SUCCESS++))
    else
        echo "[$TIMESTAMP] #$COUNTER ✗ OFFLINE/TIMEOUT"
        ((FAILED++))
    fi
    
    # Statistiche ogni 10 richieste
    if [ $((COUNTER % 10)) -eq 0 ]; then
        TOTAL=$((SUCCESS + FAILED))
        UPTIME=$(echo "scale=1; $SUCCESS * 100 / $TOTAL" | bc -l 2>/dev/null || echo "0")
        echo "    [Stats] Online: $SUCCESS | Offline: $FAILED | Uptime: ${UPTIME}%"
    fi
    
    ((COUNTER++))
    sleep 1
done