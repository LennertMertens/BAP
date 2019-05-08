#!/bin/bash
# Install OpenFaaS
brew install faas-cli

# Install Kubernetes Helm
brew install kubernetes-helm

# Deploy OpenFaaS to Minikube
# 1. Create a service account for tiller
kubectl -n kube-system create sa tiller && \
kubectl create clusterrolebinding tiller --clusterrole \
cluster-admin --serviceaccount=kube-system:tiller
sleep 10

# 2. Install tiller
helm init --skip-refresh --upgrade --service-account tiller
sleep 10

# 3. Create namespaces for OpenFaaS core components and OpenFaaS Functions
kubectl apply -f https://raw.githubusercontent.com/openfaas/faas-netes/master/namespaces.yml
sleep 10

# 4. Add the OpenFaaS helm repository
helm repo add openfaas https://openfaas.github.io/faas-netes/

# 5. Generate a random password
export PASSWORD=$(head -c 12 /dev/urandom | shasum| cut -d' ' -f1)

# 6. Log the password value to the user
echo Password: $PASSWORD

# 7. Create a secret for the generated password and write it to gateway-password.txt
kubectl -n openfaas create secret generic basic-auth \
--from-literal=basic-auth-user=admin --from-literal=basic-auth-password="$PASSWORD"

echo $PASSWORD > gateway-password.txt

# 8. Install OpenFaaS using chart
helm repo update \
&& helm upgrade openfaas --install openfaas/openfaas \
--namespace openfaas --set functionNamespace=openfaas-fn --set basic_auth=true
sleep 10

# 9. Set an environment variable for the OpenFaaS URL: OPENFAAS_URL
export OPENFAAS_URL=$(minikube ip):31112
export URL=$(minikube ip)
echo URL: $OPENFAAS_URL


# Configure Prometheus Grafana dashboard
kubectl -n openfaas run \
--image=stefanprodan/faas-grafana:4.6.3 \
--port=3000 \
grafana

kubectl -n openfaas expose deployment grafana \
--type=NodePort \
--name=grafana

GRAFANA_PORT=$(kubectl -n openfaas get svc grafana -o \
jsonpath="{.spec.ports[0].nodePort}")
GRAFANA_URL=$URL:$GRAFANA_PORT/dashboard/db/openfaas