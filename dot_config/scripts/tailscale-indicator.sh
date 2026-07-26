#!/bin/bash

if ! command -v tailscale &>/dev/null; then
  exit 0
fi

STATUS=$(tailscale status --json 2>/dev/null)
if [ $? -ne 0 ]; then
  exit 0
fi

VPN=$(echo "$STATUS" | jq -r '.Self.Online // false')
IP=$(echo "$STATUS" | jq -r '.Self.TailscaleIPs[0] // "none"')
PEERS=$(echo "$STATUS" | jq '[.Peer[] | select(.Online == true)] | length')

if [ "$VPN" = "true" ]; then
  echo "{\"text\":\"[ts]\",\"tooltip\":\"Tailscale: connected\\nIP: $IP\\nPeers online: $PEERS\",\"class\":\"connected\"}"
fi
