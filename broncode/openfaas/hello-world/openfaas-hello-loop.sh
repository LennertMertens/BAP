#!/bin/bash
touch uitvoeringstijd-openfaas-hello.csv
echo Uitvoeringstijd Hello functie OpenFaaS >> uitvoeringstijd-openfaas-hello.csv
for i in {1..200};
do
  curl -s -w "%{time_total}\n" -X GET -o /dev/null $OPENFAAS_URL/function/hello-openfaas  >> uitvoeringstijd-openfaas-hello.csv
done