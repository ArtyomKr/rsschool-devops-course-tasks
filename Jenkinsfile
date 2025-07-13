pipeline {
    triggers {
        pollSCM('* * * * *')
    }
    agent {
        kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: python
                image: python:3.9-slim
                command: ["cat"]
                tty: true
              - name: docker
                image: docker:latest
                command: ["cat"]
                tty: true
                volumeMounts:
                - name: docker-sock
                  mountPath: /var/run/docker.sock
              - name: helm
                image: alpine/helm:3.12.0
                command: ["cat"]
                tty: true
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
            '''
        }
    }
    environment {
        FLASK_APP_DIR = "docker/flask-app/"
        DOCKER_IMAGE_TAG = "artyomkr/flask-app:latest"
        HELM_CHART_DIR = "helm/flask-app/"
        APP_CLUSTER_NAMESPACE = "default"
        HELM_RELEASE_NAME = "flask-app"
    }
    stages {
        stage('Build app') {
            steps {
                container('python') {
                    dir(FLASK_APP_DIR) {
                        sh 'pip install -r requirements.txt'
                    }
                }
            }
        }
        stage('Test') {
            steps {
                container('python') {
                    dir(FLASK_APP_DIR) {
                        sh 'python -m unittest discover -s tests'
                    }
                }
            }
        }
        stage('Build and push docker image') {
            steps {
                container('docker') {
                    dir(FLASK_APP_DIR) {
                        withCredentials([usernamePassword(
                            credentialsId: 'docker-hub-creds',
                            usernameVariable: 'DOCKER_USERNAME',
                            passwordVariable: 'DOCKER_PASSWORD'
                        )]) {
                            sh '''
                                docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD
                                docker build . -t ${DOCKER_IMAGE_TAG}
                                docker push ${DOCKER_IMAGE_TAG}
                            '''
                        }
                    }
                }
            }
        }
        stage('Deploy with Helm') {
            steps {
                container('helm') {
                    dir(HELM_CHART_DIR) {
                        sh '''
                            helm upgrade --install ${HELM_RELEASE_NAME} . \
                                --namespace ${APP_CLUSTER_NAMESPACE} \
                                --atomic \
                                --wait
                        '''
                    }
                }
            }
        }
    }
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}