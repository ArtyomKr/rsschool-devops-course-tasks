pipeline {
    triggers {
        pollSCM('* * * * *')
    }
    agent any
    stages {
        stage('Checkout') {
            steps {
                checkout scm
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