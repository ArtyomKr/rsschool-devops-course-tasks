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
                volumeMounts:
                - name: workspace
                  mountPath: /home/jenkins/agent
              - name: docker
                image: docker:latest
                command: ["cat"]
                tty: true
                volumeMounts:
                - name: docker-sock
                  mountPath: /var/run/docker.sock
                - name: workspace
                  mountPath: /home/jenkins/agent
              volumes:
              - name: docker-sock
                hostPath:
                  path: /var/run/docker.sock
              - name: workspace
                emptyDir: {}
            '''
        }
    }
    environment {
        FLASK_APP_DIR = "docker/flask-app/app/"
    }
    stages {
        stage('Verify Setup') {
            steps {
                container('python') {
                    sh 'python --version'
                }
            }
        }
        stage('Build') {
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