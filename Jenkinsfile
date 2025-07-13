pipeline {
    triggers {
        pollSCM('* * * * *')
    }
    agent {
            docker {
                image 'python:3.9-slim'
                args '--privileged -v /var/run/docker.sock:/var/run/docker.sock'
            }
        }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Check Tools') {
            steps {
                sh 'python --version'
                sh 'docker --version'
            }
        }
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'make build'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'make test'
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