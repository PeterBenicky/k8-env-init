# https://www.linuxtechi.com/install-kubernetes-cluster-on-debian/

NONROOT_USER="peter"
HOSTNAME_MASTER="k8s-master"
HOSTNAME_WORKER01="k8s-worker01"
HOSTNAME_WORKER02="k8s-worker02"
HOSTS_FILE="/etc/hosts"
HOST_LINES=(
	"192.168.1.127   k8s-master"
	"192.168.1.127   k8s-node1"
	"192.168.1.127   k8s-node2"
)
KUBELET_CINFIG_FILE=/var/lib/kubelet/config.yaml

su -
apt update
apt install sudo
usermod -aG sudo $NONROOT_USER
su - $NONROOT_USER

sudo swapoff -a

# if using k8s-master.local that inclkudes a dot, then DNS ia needed
sudo hostnamectl set-hostname $HOSTNAME_MASTER     # Run on master node
# sudo hostnamectl set-hostname $HOSTNAME_WORKER01   # Run on 1st worker node
# sudo hostnamectl set-hostname $HOSTNAME_WORKER02    # Run on 2nd worker node


# ! run this on all workers
# the content (ip addresses need to be adjusted)
# Loop through each line and check if it already exists
for LINE in "${HOST_LINES[@]}"; do
  if ! grep -q "$LINE" "$HOSTS_FILE"; then
    # If the line doesn't exist, append it to the hosts file
    echo "$LINE" | sudo tee -a "$HOSTS_FILE" > /dev/null
    echo "Entry added: $LINE"
  else
    echo "Entry already exists: $LINE"
  fi
done

sudo sudo apt install -y ufw
sudo ufw --force enable

sudo ufw allow 6443/tcp
sudo ufw allow 2379/tcp
sudo ufw allow 2380/tcp
sudo ufw allow 10250/tcp
sudo ufw allow 10251/tcp
sudo ufw allow 10252/tcp
sudo ufw allow 10255/tcp
sudo ufw reload

cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay 
br_netfilter
EOF

sudo modprobe overlay 
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
EOF

sudo sysctl --system

sudo apt update
sudo apt -y install containerd

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1

CONFIG_FILE="/etc/containerd/config.toml"
if [ -f "$CONFIG_FILE" ]; then
  sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' "$CONFIG_FILE"
  echo "SystemdCgroup has been changed to true in $CONFIG_FILE"
  sudo systemctl restart containerd
else
  echo "Config file not found at $CONFIG_FILE"
fi

sudo systemctl enable containerd

sudo apt install curl gnupg -y

echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg  # Force Y

sudo apt update
sudo apt install kubelet kubeadm kubectl -y
sudo apt-mark hold kubelet kubeadm kubectl

# sudo bash -c  "cat <<EOF >> $KUBELET_CINFIG_FILE
# evictionHard:
#  imagefs.available: 1%
#  memory.available: 100Mi
#  nodefs.available: 1%
#  nodefs.inodesFree: 1%
# EOF"


cat <<EOF > kubelet.yaml
apiVersion: kubeadm.k8s.io/v1beta3
kind: InitConfiguration
---
apiVersion: kubeadm.k8s.io/v1beta3
kind: ClusterConfiguration
kubernetesVersion: "1.28.0" # Replace with your desired version
controlPlaneEndpoint: "$HOSTNAME_MASTER"
---
apiVersion: kubelet.config.k8s.io/v1beta1
kind: KubeletConfiguration
EOF


sudo kubeadm init --config kubelet.yaml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl get nodes
kubectl cluster-info

exit 0

sudo journalctl -u kubelet -f

#export KUBECONFIG=/etc/kubernetes/admin.conf
#sudo apt install socat -y

# You should now deploy a pod network to the cluster.
# Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
#   https://kubernetes.io/docs/concepts/cluster-administration/addons/

# You can now join any number of control-plane nodes by copying certificate authorities
# and service account keys on each node and then running the following as root:

#   kubeadm join k8s-master:6443 --token pjdtma.ar8nz3hxcslll04g \
# 	--discovery-token-ca-cert-hash sha256:44e4c6b8c9bd5ef4efcc8a68308ac786ea4e6de5121528354a86ae521b0b5389 \
# 	--control-plane 

# Then you can join any number of worker nodes by running the following on each as root:

# kubeadm join k8s-master:6443 --token pjdtma.ar8nz3hxcslll04g \
# 	--discovery-token-ca-cert-hash sha256:44e4c6b8c9bd5ef4efcc8a68308ac786ea4e6de5121528354a86ae521b0b5389 





