#!/bin/bash
echo "Waiting for K3s service to be active..."
until sudo systemctl is-active k3s; do sleep 5; done
echo "K3s service is active. Retrieving token..."
K3S_NODE_TOKEN=$(sudo cat /var/lib/rancher/k3s/server/token)
echo "{\"k3s_token\":\"${K3S_NODE_TOKEN}\"}"