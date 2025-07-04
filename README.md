# Jenkins local config

This Jenkins config can be used to install jenkins with helm on minikube cluster. 
The JCasC configs are stored in `jenkins-values.yaml` file (`controller/JCasC/configScripts`).

## Running Jenkins

1. Clone the repository.
2. `cd` into `/jenkins` folder.
3. Make sure you have [minikube](https://minikube.sigs.k8s.io/) and [helm](https://helm.sh/) installed.
4. Run `install.sh` file. It should automatically create and configure jenkins from helm in devops-tools namespace.
5. [Obtain](https://www.jenkins.io/doc/book/installing/kubernetes/#install-jenkins) jenkins admin password. 
6. To run jenkins in you browser start minikube `minikube start` and then run `start.sh` script.

To apply new JCasC config script:

1. Modify `jenkins-values.yaml` file.
2. Run `helm upgrade jenkins jenkinsci/jenkins -n devops-tools -f jenkins-values.yaml`.