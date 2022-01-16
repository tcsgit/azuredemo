helm lint demo-chart/

helm template demo-chart/

helm install asademo demo-chart/ --namespace asademo --create-namespace --dry-run --debug

helm upgrade --install asademo demo-chart/ --namespace asademo --create-namespace

helm ls -n asademo

helm status asademo -n asademo

helm history asademo -n asademo

helm uninstall asademo -n asademo