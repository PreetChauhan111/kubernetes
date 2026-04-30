#!/bin/bash

# Update and upgrade
sudo apt update && sudo apt upgrade -y

# Swap off
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Install Docker
sudo apt install docker.io -y
sudo systemctl start docker
sudo systemctl enable docker
sudo chmod 666 /var/run/docker.sock

# Install Keyrings
sudo apt install -y apt-transport-https ca-certificates curl
sudo mkdir -p /etc/apt/keyrings 
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | \
sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Add Kubernetes repo to sources
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] \
https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /" | \
sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes
sudo apt update
sudo apt install -y kubelet kubeadm kubectl

# Initialize Kubernetes
sudo kubeadm init --pod-network-cidr=192.168.0.0/16

# Config Kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.31.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
git clone https://github.com/PreetChauhan111/kubernetes.git
cd kubernetes
mkdir learn
cd learn
mkdir first-cluster
cd first-cluster
vi config.yml
kind create cluster --name first-cluster --config=config.yml