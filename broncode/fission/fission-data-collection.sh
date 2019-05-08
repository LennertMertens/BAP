#!/bin/bash
touch looptijd-functie-fission.csv
for i in {1..100};
do
  curl -s -w "%{time_total}\n" -o /dev/null -d "testing-fission" http://192.168.99.149:31314/serverless  >> looptijd-functie-fission.csv
done