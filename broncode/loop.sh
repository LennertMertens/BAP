# !/bin/bash
# Loop 200 times over the function to retrieve data and write it to Google spreadsheets
for i in {1..200}; do
  curl http://192.168.99.119:31112/function/serverless-demo
done
