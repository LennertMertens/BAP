#!/bin/bash
touch uitvoeringstijd-fission.csv
echo Uitvoeringstijd Fission >> uitvoeringstijd-fission.csv
for i in {1..200};
do
  curl -X GET -s -w "%{time_total}\n" -o /dev/null -d "Test" $FISSION_ROUTER/serverless-demo  >> uitvoeringstijd-fission.csv
done