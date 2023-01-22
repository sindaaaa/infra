#!/bin/bash

#sudo bash

#install Docker
su $SUDO_USER <<EOF
sudo su
echo "Salamu alaykom" 
echo "Salamu alaykom" >> /home/ubuntu/checkpoint.txt
apt-get update
echo "wa alaykom salam" >> /home/ubuntu/checkpoint.txt
echo "wa alaykom salam" 
wget -qO- https://get.docker.com/ | sh
echo "docker installed" >> /home/ubuntu/checkpoint.txt

#install kubernets
sudo apt install apt-transport-https curl -y 
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" >> ~/kubernetes.list
sudo mv ~/kubernetes.list /etc/apt/sources.list.d
sudo apt update
echo "updated" >> /home/ubuntu/checkpoint.txt
sudo apt install kubelet -y
echo "kubetlet ok" >> /home/ubuntu/checkpoint.txt
sudo apt install kubeadm -y 
echo "kubeadm ok" >> /home/ubuntu/checkpoint.txt
sudo apt install kubectl -y
echo "kubectl ok" >> /home/ubuntu/checkpoint.txt
sudo apt-get install -y kubernetes-cni -y
echo "kubernetes cni ok" >> /home/ubuntu/checkpoint.txt
sudo swapoff -a

#setting unique hostnames
sudo hostnamectl set-hostname kubernetes-master

#Letting iptables see Bridged traffic
lsmod | grep br_netfilter
sudo modprobe br_netfilter
sudo sysctl net.bridge.bridge-nf-call-iptables=1
env | grep ^SUDO_USER
EOF
#Changing Docker Cgroup Driver
sudo mkdir /etc/docker

docker_daemon=$(cat <<HERE | sudo tee /etc/docker/daemon.json
{ "exec-opts": ["native.cgroupdriver=systemd"],
"log-driver": "json-file",
"log-opts":
{ "max-size": "100m" },
"storage-driver": "overlay2"
}
HERE
);
$docker_daemon
sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker
echo "docker and deamon enabled and restarted" >> /home/ubuntu/checkpoint.txt

#to fix cri error
rm /etc/containerd/config.toml
systemctl restart containerd
echo "containerd restarted" >> /home/ubuntu/checkpoint.txt

#initializing the kubernets Master Node
sudo kubeadm init --ignore-preflight-errors=NumCPU,Mem --pod-network-cidr=10.244.0.0/16 >> join-cmd.txt
echo "kubeadm init ok" >> /home/ubuntu/checkpoint.txt


#regular user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


#deploying a pod network
sudo ufw allow 6443
sudo ufw allow 6443/tcp
echo "ports ok" >> /home/ubuntu/checkpoint.txt

sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml


sudo kubectl get pods --all-namespaces
echo "pods retrieved" >> /home/ubuntu/checkpoint.txt
