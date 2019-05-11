#!/bin/bash
echo > artifacts.txt
## Minikube enable metrics-server
minikube addons enable metrics-server

## Installeer brew packages
brew install faas-cli
brew install kubernetes-helm

## Configureer Kubernetes cluster
# 1. Maak tiller service account
kubectl -n kube-system create sa tiller && \
kubectl create clusterrolebinding tiller --clusterrole \
cluster-admin --serviceaccount=kube-system:tiller

# 2. Initialiseer tiller service account
helm init --skip-refresh --upgrade --service-account tiller

## Installeer OpenFaaS
# 1. Maak namespaces voor OpenFaaS 
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
sleep 10

# 2. Voeg OpenFaaS Helm repository toe
helm repo add openfaas https://openfaas.github.io/faas-netes/
sleep 20

# 3. Stel een paswoord in
export PASSWORD="Serverless123"
echo PASSWORD=$PASSWORD >> artifacts.txt

# 4. Maak admin account en configureer met paswoord
kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin --from-literal=basic-auth-password="$PASSWORD"
sleep 10

# 5. Installeer OpenFaaS met Helm chart
helm repo update \
&& helm upgrade openfaas --install openfaas/openfaas \
--namespace openfaas --set functionNamespace=openfaas-fn --set basic_auth=true
sleep 30

# 6. Stel OPENFAAS_URL omgevingsvariabele in
export OPENFAAS_URL=http://$(minikube ip):31112
echo OPENFAAS_URL=$OPENFAAS_URL >> artifacts.txt
echo OPENFAAS_UI=$OPENFAAS_URL/ui >> artifacts.txt

## Installeer Fission
# 1. Update Helm repo en voeg Fission namespaces toe
helm repo update && \
helm install --name fission --namespace fission \
--set serviceType=NodePort,routerServiceType=NodePort \
https://github.com/fission/fission/releases/download/1.2.0/fission-all-1.2.0.tgz
sleep 20

# 2. Installeer Fission CLI tools
if ! ls -f /usr/local/bin/fission;
then
curl -Lo fission \
https://github.com/fission/fission/releases/download/1.2.0/fission-cli-osx && \
chmod +x fission && sudo mv fission /usr/local/bin/;
else
echo "Fission CLI tools already installed!"
fi

# Stel Fission omgevingsvariabelen in
export FISSION_URL=http://$(minikube ip):31313
echo FISSION_URL=$FISSION_URL >> artifacts.txt
export FISSION_ROUTER=http://$(minikube ip):31314
echo FISSION_ROUTER=${FISSION_ROUTER} >> artifacts.txt

## Installer Fission UI (optioneel)
MINIKUBE_IP=$(minikube ip)
echo -n "Wilt u de Fission UI installeren? [y/n] "
read answer

if [ "$answer" != "${answer#[Yy]}" ]; then
  PAD=$(pwd)
  # 1. Clone de Git repository
  cd ~
  git clone git@github.com:fission/fission-ui.git
  cd fission-ui
  # 2. Deploy de Fission UI
  kubectl create -f docker/fission-ui.yaml
  cd $PAD
  # Schrijf IP adres naar artifacts
  export FISSION_UI=http://$MINIKUBE_IP:31319
  echo FISSION_UI=$FISSION_UI >> artifacts.txt
else
  echo Fission UI wordt niet geïnstalleerd!
fi

# Print het bestand met alle gegenereerde variabelen
cat artifacts.txt