kubeadm init --service-cidr 10.96.0.0/12 --pod-network-cidr 172.17.0.0/16 | tee kubeadm.log

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f https://github.com/antrea-io/antrea/releases/download/v1.2.4/antrea.yml
