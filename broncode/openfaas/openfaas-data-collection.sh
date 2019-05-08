#!/bin/bash
touch looptijd-functie-openfaas.csv
for i in {1..100};
do
  curl -s -w "%{time_total}\n" -o /dev/null -d "testing-openfaas" http://192.168.99.150:31112/function/serverless-demo  >> looptijd-functie-openfaas.csv
done