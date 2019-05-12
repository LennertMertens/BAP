#!/bin/bash
touch uitvoeringstijd-fission-hello.csv
echo Uitvoeringstijd Hello functie Fission >> uitvoeringstijd-fission-hello.csv
for i in {1..200};
do
  curl -X GET -s -w "%{time_total}\n" -o /dev/null $FISSION_ROUTER/hello-fission  >> uitvoeringstijd-fission-hello.csv
done