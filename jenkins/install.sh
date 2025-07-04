kubectl create namespace devops-tools

# Create PV and StorageClass
kubectl apply -f jenkins-01-volume.yaml

# Set permissions on the volume (inside Minikube)
minikube ssh -- "sudo mkdir -p /data/jenkins-volume && sudo chown -R 1000:1000 /data/jenkins-volume"

# Create ServiceAccount
kubectl apply -f jenkins-02-sa.yaml

# Install Jenkins via Helm
helm repo add jenkins https://charts.jenkins.io
helm repo update
helm install jenkins -n devops-tools -f jenkins-values.yaml jenkinsci/jenkins