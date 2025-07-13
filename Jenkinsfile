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
    stages {
        stage('Run in K8s Pod') {
            steps {
                container('python') {
                    sh 'python --version'
                }
                container('docker') {
                    sh 'docker --version'
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