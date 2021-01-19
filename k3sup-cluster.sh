#!/bin/bash
export K3S_VERSION="v1.19.5+k3s2"

# Download the k3ups binary on k3sup node
curl -sLS https://get.k3sup.dev | sh
sudo install k3sup /usr/local/bin/
k3sup --help

# Download and Install kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.20.0/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

# Create the k3s cluster - Server
k3sup install --ip $SERVER_IP --user $USER --k3s-version $K3S_VERSION --cluster --k3s-extra-args '--flannel-iface enp0s8'
# Create the k3s cluster - Nodes
k3sup join --ip $NODE1_IP --server-ip $SERVER_IP --user $USER --server-user $USER --k3s-version $K3S_VERSION --k3s-extra-args '--flannel-iface enp0s8'
k3sup join --ip $NODE2_IP --server-ip $SERVER_IP --user $USER --server-user $USER --k3s-version $K3S_VERSION --k3s-extra-args '--flannel-iface enp0s8'