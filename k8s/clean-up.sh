for port in 6443 10259 10257 10250 2379 2380; do
    pid=$(sudo lsof -t -i :$port)
    if [ -n "$pid" ]; then
        echo "Killing process $pid occupaing port $port"
        sudo kill -9 $pid || true
    else
        echo "No process found on port $port"
    fi
done


for file in \
            /etc/kubernetes/manifests/kube-apiserver.yaml \
            /etc/kubernetes/manifests/kube-controller-manager.yaml \
            /etc/kubernetes/manifests/etcd.yaml \
            /etc/kubernetes/manifests/kube-scheduler.yaml \
    ; do
    if [ -e "$file" ]; then
        sudo rm "$file" && echo "Deleted $file" || echo "Failed to delete $file"
    else
        echo "$file does not exist"
    fi
done

sudo rm -rf /var/lib/etcd


sudo kubeadm init --config kubelet.yaml --ignore-preflight-errors=...


