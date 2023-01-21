#!/bin/bash


#install Docker
sudo bash
apt-get update
wget -qO- https://get.docker.com/ | sh

#install kubernets
sudo apt install apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d
sudo apt update
sudo apt install kubelet
sudo apt install kubeadm
sudo apt install kubectl
sudo apt-get install -y kubernetes-cni
sudo swapoff -a

#setting unique hostnames
sudo hostnamectl set-hostname kubernetes-master

#Letting iptables see Bridged traffic
lsmod | grep br_netfilter
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1

#Changing Docker Cgroup Driver
sudo mkdir /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
EOF
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

#to fix cri error
rm /etc/containerd/config.toml
systemctl restart containerd

#initializing the kubernets Master Node
kubeadm init --ignore-preflight-errors=NumCPU,Mem --pod-network-cidr=10.244.0.0/16


#regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#deploying a pod network
sudo ufw allow 6443
sudo ufw allow 6443/tcp
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


kubectl get pods --all-namespaces

