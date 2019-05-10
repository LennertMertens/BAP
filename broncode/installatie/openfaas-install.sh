#!/bin/bash
echo > artifacts.txt
## Minikube enable metrics-server
minikube addons enable metrics-server

## Install brew packages
brew install faas-cli
brew install kubernetes-helm

## Set up Kubernetes cluster
# 1. Create a tiller service account 
kubectl -n kube-system create sa tiller && \
kubectl create clusterrolebinding tiller --clusterrole \
cluster-admin --serviceaccount=kube-system:tiller

# 2. Initialize tiller service account
helm init --skip-refresh --upgrade --service-account tiller

## Install OpenFaaS
# 1. Create namespaces for OpenFaaS 
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
sleep 10

# 2. Add the OpenFaaS helm repository
helm repo add openfaas https://openfaas.github.io/faas-netes/
sleep 20

# 3. Generate a password
export PASSWORD="Serverless123"
echo PASSWORD=$PASSWORD >> artifacts.txt

# 4. Add authentication user admin with password
kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin --from-literal=basic-auth-password="$PASSWORD"
sleep 10

# 5. Install OpenFaaS using Helm chart
helm repo update \
&& helm upgrade openfaas --install openfaas/openfaas \
--namespace openfaas --set functionNamespace=openfaas-fn --set basic_auth=true
sleep 30

# 9. Set an environment variable for the OpenFaaS URL: OPENFAAS_URL
export OPENFAAS_URL=http://$(minikube ip):31112
echo OPENFAAS_URL=$OPENFAAS_URL >> artifacts.txt
echo OPENFAAS_UI=$OPENFAAS_URL/ui >> artifacts.txt