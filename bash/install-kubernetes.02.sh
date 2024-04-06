#https://www.linuxtechi.com/install-kubernetes-on-ubuntu-22-04/
#Master Node:  192.168.1.173 – k8smaster.example.net
#First Worker Node:  192.168.1.174 – k8sworker1.example.net
#Second Worker Node:  192.168.1.175 – k8sworker2.example.net
#master node
sudo hostnamectl set-hostname "k8smaster.example.net"
exec bash
#worker nodes
sudo hostnamectl set-hostname "k8sworker1.example.net"   // 1st worker node
sudo hostnamectl set-hostname "k8sworker2.example.net"   // 2nd worker node
exec bash
#each node
cat >> /etc/hosts << EOL
192.168.1.173   k8smaster.example.net k8smaster
192.168.1.174   k8sworker1.example.net k8sworker1
192.168.1.175   k8sworker2.example.net k8sworker2
EOL
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo tee /etc/modules-load.d/containerd.conf << EOL
overlay
br_netfilter
EOL
sudo modprobe overlay
sudo modprobe br_netfilter
sudo tee /etc/sysctl.d/kubernetes.conf << EOL
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOL
sudo sysctl --system
sudo apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install -y containerd.io
containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
#master node
sudo kubeadm init --control-plane-endpoint=k8smaster.example.net
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl cluster-info
kubectl get nodes
#worker node
sudo kubeadm join k8smaster.example.net:6443 --token vt4ua6.wcma2y8pl4menxh2 \
   --discovery-token-ca-cert-hash sha256:0494aa7fc6ced8f8e7b20137ec0c5d2699dc5f8e616656932ff9173c94962a36
#master node
kubectl get nodes
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
kubectl get pods -n kube-system
kubectl get nodes
#tests
kubectl create deployment nginx-app --image=nginx --replicas=2
kubectl get deployment nginx-app
kubectl expose deployment nginx-app --type=NodePort --port=80
kubectl get svc nginx-app
kubectl describe svc nginx-app
curl http://<woker-node-ip-addres>:31246