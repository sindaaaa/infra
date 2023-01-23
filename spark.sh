#!/bin/bash

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

apt-get install apt-transport-https --yes

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

apt-get update

apt-get install helm -y

helm repo add repo https://charts.bitnami.com/bitnami

helm install --set worker.replicaCount=3 projet repo/spark

sleep 120

kubectl port-forward  --address=0.0.0.0 --namespace default svc/projet-spark-master-svc 80:80 > /dev/null &

sleep 180

curl -o /tmp/filesample.txt https://pastebin.com/raw/9dpn1YZ0

kubectl cp /tmp/filesample.txt default/projet-spark-master-0:/tmp/

kubectl cp /tmp/filesample.txt default/projet-spark-worker-0:/tmp/

kubectl cp /tmp/filesample.txt default/projet-spark-worker-1:/tmp/

kubectl cp /tmp/filesample.txt default/projet-spark-worker-2:/tmp/

kubectl exec -ti --namespace default projet-spark-worker-0 -- spark-submit \
  --master spark://projet-spark-master-svc:7077 \
  --class org.apache.spark.examples.JavaWordCount \
  local:///opt/bitnami/spark/examples/jars/spark-examples_2.12-3.3.1.jar \
  /tmp/filesample.txt

sleep 180

kubectl port-forward  --address=0.0.0.0 --namespace default svc/projet-spark-master-svc 80:80 > /dev/null &
