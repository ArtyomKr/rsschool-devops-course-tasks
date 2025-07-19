# Jenkins pipeline

This pipeline involves polling Git, building and testing the app, scanning it with SonarQube, building and pushing docker image and deploying helm chart. 

# Pipeline requirements:

1. Make sure you have a working jenkins installation with GitHub and SonarQube plugins.
2. Set up repository and branch for SCM polling with GitHub plugin (using Jenkins UI).
3. Install SonarQube Server.
4. Set up credentials in Jenkins for docker hub (or other provider). In my case credentials are named `docker-hub-creds`.
5. Set up SonarQube integration by creating token in SonarQube, adding it to credentials in Jenkins and adding SonarQube server in global settings .
6. For email notifications you can use [Google SMTP server](https://support.google.com/a/answer/176600?hl=en). You can configure SMTP server in global Jenkins server.
**Keep in mind, if you are running Jenkins locally, that some antiviruses can block SMTP connection.**
7. Jenkins check for updates in git repo every minute, so deploy will trigger within a minute after new pushes.


## Installing SonarQube

```
helm repo add sonarqube https://SonarSource.github.io/helm-chart-sonarqube
helm repo update

helm upgrade --install -n sonarqube sonarqube sonarqube/sonarqube \
  --create-namespace
  --set community.enabled=true \
  --set persistence.enabled=true \
  --set postgresql.enabled=true \
  --set service.type=NodePort \
  --set monitoringPasscode=<YOUR PASS>
```

To access SonarQube server dashboard run `minikube service sonarqube-sonarqube -n sonarqube`