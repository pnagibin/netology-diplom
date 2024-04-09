apt install -y git jsonnet
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus
# Create the namespace and CRDs, and then wait for them to be availble before creating the remaining resources
kubectl create -f manifests/setup
# Wait until the "servicemonitors" CRD is created. The message "No resources found" means success in this context.
until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
kubectl create -f manifests/

kubectl apply --server-side -f manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f manifests/

kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090 --address 0.0.0.0
kubectl --namespace monitoring port-forward svc/alertmanager-main 9093  --address 0.0.0.0
kubectl --namespace monitoring port-forward svc/grafana 3000  --address 0.0.0.0
kubectl --namespace default port-forward svc/webserver-entrypoint 8888  --address 0.0.0.0

kubectl delete --ignore-not-found=true -f manifests/ -f manifests/setup