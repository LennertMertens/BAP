#!/bin/bash
touch uitvoeringstijd-openfaas.csv
echo Uitvoeringstijd OpenFaaS >> uitvoeringstijd-openfaas.csv
for i in {1..200};
do
  curl -s -w "%{time_total}\n" -d "Test" -X GET -o /dev/null $OPENFAAS_URL/function/serverless-demo  >> uitvoeringstijd-openfaas.csv
done