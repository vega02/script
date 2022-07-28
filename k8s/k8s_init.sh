swapoff -a
free -m
cp /etc/fstab /etc/fstab.bak
cat /etc/fstab.bak |grep -v swap > /etc/fstab

modprobe overlay
modprobe br_netfilter
echo 'overlay' >> /etc/modules
echo 'br_netfilter' >> /etc/modules
echo 1 > /proc/sys/net/ipv4/ip_forward

cat <<EOF > /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

echo 'net.ipv4.ip_forward = 1' >> /etc/sysctl.conf
sysctl -p

sudo apt-get update 
sudo apt-get install curl
sudo apt-get install -y apt-transport-https

curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

curl -fsSLo /usr/share/keyrings/release1.key https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.24/xUbuntu_22.04/Release.key
echo "deb [signed-by=/usr/share/keyrings/release1.key] http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/1.24/xUbuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:1.24.list

curl -fsSLo /usr/share/keyrings/release2.key https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/Release.key
echo "deb [signed-by=/usr/share/keyrings/release2.key] https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_22.04/ /" | sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

sudo apt-get update 
sudo apt-get install -y kubelet kubeadm kubectl
apt-get install -y cri-o cri-o-runc

sudo apt-mark hold kubelet kubeadm kubectl

systemctl daemon-reload
systemctl enable crio
systemctl start crio
#systemctl status crio
