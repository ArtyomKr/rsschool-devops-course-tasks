# Jenkins custom chart

This chart installs preconfigured jenkins. 
The JCasC configs are stored in `jenkins/jenkins-chart/values.yaml` file (`controller/JCasC/configScripts`).

## Running Jenkins

1. Clone the repository.
2. `cd` into `/jenkins` folder.
3. Make sure you have [minikube](https://minikube.sigs.k8s.io/) and [helm](https://helm.sh/) installed.
4. Create desired namespace: `kubectl create namespace jenkins`.
5.  Install chart dependencies: `helm dependency build ./jenkins-chart`.
6. Install chart: `helm install jenkins ./jenkins-chart -n jenkins`.  
7. **!Important**: If you use minicude run `minikube ssh -- "sudo mkdir -p /data/jenkins-volume && sudo chown -R 1000:1000 /data/jenkins-volume"` to set correct permissions after installing the chart.
8. Obtain jenkins admin password: `kubectl get secret -n jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 -d`
9. To run jenkins in you browser start minikube `minikube start` and then run `start.sh` script.

To apply new config:

1. Modify `values.yaml` file.
2. Run `helm upgrade jenkins ./jenkins-chart -n jenkins`.