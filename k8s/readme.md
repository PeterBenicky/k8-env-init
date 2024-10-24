



Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of control-plane nodes by copying certificate authorities
and service account keys on each node and then running the following as root:

  kubeadm join k8s-master:6443 --token 7vnzhl.ykx1t5b5dvkr8q2m \
	--discovery-token-ca-cert-hash sha256:90ef2e59b1117f0c5e627e57d446075d046c65e075a6350b800b28edb659909c \
	--control-plane 

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join k8s-master:6443 --token 7vnzhl.ykx1t5b5dvkr8q2m \
	--discovery-token-ca-cert-hash sha256:90ef2e59b1117f0c5e627e57d446075d046c65e075a6350b800b28edb659909c 