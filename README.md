# Flask custom chart

This chart installs custom flask chart. 

## Running Jenkins

1. Clone the repository.
2. `cd` into `/helm` folder.
3. Make sure you have [minikube](https://minikube.sigs.k8s.io/) and [helm](https://helm.sh/) installed.
4. Create desired namespace: `kubectl create namespace flask-app`.
5.  Install chart dependencies: `helm dependency build ./jenkins-chart`.
6. Install chart: `helm install flask-app ./flask-app -n flask-app`.  
7. To run the app in you browser start minikube `minikube start` and then run `minikube service flask-app -n flask-app`.

To change docker image of the app:

1. `cd` into `/docker` folder.
2. Modify `Dockerfile`.
3. Build image with `docker build . -t yourname/flask-app:1.0`.
4. Push your image with `docker push yourname/flask-app:1.0`.
5. Modify helm chart's `values.yaml` to use you image.

## Installing SonarQube

```
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

helm upgrade --install -n sonarqube sonarqube sonarqube/sonarqube \
  --create-namespace
  --set edition=developer \
  --set persistence.enabled=true \
  --set postgresql.enabled=true \
  --set service.type=NodePort \
  --set monitoringPasscode=<YOUR PASS>
```

To access SonarQube server dashboard run `minikube service sonarqube-sonarqube -n sonarqube`