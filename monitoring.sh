
sudo kubectl create namespace monitoring
git clone https://github.com/techiescamp/kubernetes-prometheus.git
cd kubernetes-prometheus/
sudo kubectl create -f clusterRole.yaml
sudo kubectl create -f config-map.yaml
sudo kubectl create  -f prometheus-deployment.yaml 
sudo kubectl get deployments --namespace=monitoring
sudo kubectl create -f prometheus-service.yaml --namespace=monitoring
## pour acceder dashboard promeutheus http://@ip publique master:30000/
cd ../
git clone https://github.com/bibinwilson/kubernetes-grafana.git
cd kubernetes-grafana/
sudo kubectl create -f grafana-datasource-config.yaml
sudo kubectl create -f deployment.yaml
sudo kubectl create -f service.yaml
sudo kubectl get pods --all-namespaces

## pour acceder dashboard grafana  http://@ip publique master:32000/

#id template dashboard 8588



