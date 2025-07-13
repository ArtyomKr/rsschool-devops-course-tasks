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
                        sh 'docker build . -t ${DOCKER_IMAGE_TAG}'
                        sh 'docker push ${DOCKER_IMAGE_TAG}'
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