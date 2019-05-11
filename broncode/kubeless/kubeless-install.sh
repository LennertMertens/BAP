#!/bin/bash 

brew install kubeless
kubectl create ns kubeless
kubectl create -f https://github.com/kubeless/kubeless/releases/download/v1.0.2/kubeless-v1.0.2.yaml