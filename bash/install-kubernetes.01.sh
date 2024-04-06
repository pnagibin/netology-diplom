#https://phoenixnap.com/kb/install-kubernetes-on-ubuntu
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl status docker
sudo systemctl start docker
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/kubernetes.gpg] http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list
sudo apt update
sudo apt install kubeadm kubelet kubectl
sudo apt-mark hold kubeadm kubelet kubectl
kubeadm version
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
cat >> /etc/modules-load.d/containerd.conf << EOL
overlay
br_netfilter
EOL
sudo modprobe overlay
sudo modprobe br_netfilter
cat >> /etc/sysctl.d/kubernetes.conf << EOL
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOL
sudo sysctl --system
sudo hostnamectl set-hostname master-node
sudo hostnamectl set-hostname worker01-node
sudo hostnamectl set-hostname worker02-node
cat >> /etc/hosts << EOL
<IP> master-node
<IP> worker01-node
<IP> worker02-node
EOL
#Initialize Kubernetes on Master Node
cat >> /etc/default/kubelet << EOL
KUBELET_EXTRA_ARGS="--cgroup-driver=cgroupfs"
EOL
sudo systemctl daemon-reload && sudo systemctl restart kubelet
cat >> /etc/docker/daemon.json << EOL
{
      "exec-opts": ["native.cgroupdriver=systemd"],
      "log-driver": "json-file",
      "log-opts": {
      "max-size": "100m"
   },
       "storage-driver": "overlay2"
       }
EOL
sudo systemctl daemon-reload && sudo systemctl restart docker
cat >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf << EOL
Environment="KUBELET_EXTRA_ARGS=--fail-swap-on=false"
EOL
sudo systemctl daemon-reload && sudo systemctl restart kubelet
#Once the operation finishes, the output displays a kubeadm join command at the bottom. Make a note of this command, as you will use it to join the worker nodes to the cluster.
sudo kubeadm init --control-plane-endpoint=master-node --upload-certs
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
#Join Worker Node to Cluster
sudo systemctl stop apparmor && sudo systemctl disable apparmor
sudo systemctl restart containerd.service
sudo kubeadm join [master-node-ip]:6443 --token [token] --discovery-token-ca-cert-hash sha256:[hash]
kubectl get nodes