#!/bin/bash
# Install Kubernetes Helm
brew install kubernetes-Helm
sleep 10 

# Install Fission CLI tools
curl -Lo fission \
https://github.com/fission/fission/releases/download/1.2.0/fission-cli-osx \
&& chmod +x fission && sudo mv fission /usr/local/bin/
sleep 15

# Deploy Fission to Minikube
# 1. Initialize Helm
kubectl -n kube-system create sa tiller && \
kubectl create clusterrolebinding tiller --clusterrole \
cluster-admin --serviceaccount=kube-system:tiller
sleep 10

# 2. Install tiller
helm init --skip-refresh --upgrade --service-account tiller
sleep 15

# 2. Install Fission Framework
helm repo update && \
helm install --name fission --namespace fission \
--set serviceType=NodePort,routerServiceType=NodePort \
https://github.com/fission/fission/releases/download/1.2.0/fission-all-1.2.0.tgz
sleep 15

# Install Fission UI
# 1. Clone the git repository
cd ~
git clone git@github.com:fission/fission-ui.git
cd fission-ui

# 2. Deploy the Fission UI with other services
kubectl create -f docker/fission-ui.yaml
cd

# Expose the Fission IP addresses
export FISSION_UI=$(minikube ip):31319
export FISSION_URL=http://$(minikube ip):31313
export FISSION_ROUTER=$(minikube ip):31314