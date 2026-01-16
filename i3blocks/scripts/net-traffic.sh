#!/bin/sh

IFACE="enp9s0"

# Interface check
[ ! -d "/sys/class/net/$IFACE" ] && echo "NET: DOWN" && exit 0

RX1=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX1=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)
sleep 1
RX2=$(cat /sys/class/net/$IFACE/statistics/rx_bytes)
TX2=$(cat /sys/class/net/$IFACE/statistics/tx_bytes)

RX_BYTES=$((RX2 - RX1))
TX_BYTES=$((TX2 - TX1))

# Convert bytes/sec → Mbps (bits/sec / 1,000,000)
RX_Mbps=$(echo "scale=1; ($RX_BYTES * 8) / 1000000" | bc)
TX_Mbps=$(echo "scale=1; ($TX_BYTES * 8) / 1000000" | bc)

echo "<span foreground=\"#ffffff\">󰒍 [NET]: </span><span foreground=\"#e7ecf2\">↓ ${RX_Mbps}Mbps ↑ ${TX_Mbps}Mbps</span>"
