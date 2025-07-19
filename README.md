# Prometheus Deployment on K8s

This prometheus and grafana setup can be installed with helm and has custom dashboards, alert rules and smtp config.

## Create config maps for grafana:

```
kubectl create namespace monitoring

kubectl apply -f ./helm/kube-prometheus-stack/grafana-contact-points.yaml \
              -f ./helm/kube-prometheus-stack/grafana-alert-rules.yaml \
              -f ./helm/kube-prometheus-stack/grafana-dashboards.yaml \
              -n monitoring
```

## Installing Prometheus

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring -f .\helm\kube-prometheus-stack\values.yaml --create-namespace
```

## Jenkins pipeline requirements:

1. Add admin cluster role to jenkins: `kubectl create clusterrolebinding jenkins-admin --clusterrole=cluster-admin --serviceaccount=jenkins:default`.
2. Push code to GitHub repo.
3. Jenkins checks for updates in git repo every hour, so deploy will trigger within an hour after new pushes.