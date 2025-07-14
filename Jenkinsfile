pipeline {
    parameters {
        booleanParam(
            name: 'MANUAL_DOCKER_PUSH',
            defaultValue: true,
            description: 'Check to manually trigger Docker build/push'
        )
    }
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
              - name: sonarscanner
                image: sonarsource/sonar-scanner-cli:latest
                command: ["cat"]
                tty: true
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
        stage('SonarQube Analysis') {
            steps {
                container('sonarscanner') {
                    withSonarQubeEnv('SonarQube') {
                        sh """
                        sonar-scanner \
                            -Dsonar.projectKey=flask-app \
                            -Dsonar.sources=${FLASK_APP_DIR} \
                            -Dsonar.python.version=3.9
                        """
                    }
                }
            }
        }
        stage('Build and push docker image') {
            when { expression { params.MANUAL_DOCKER_PUSH == true } }
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
                        script {
                            env.DOCKER_PUSH_SUCCEEDED = "true"
                        }
                    }
                }
            }
        }
        stage('Deploy with Helm') {
            when { expression { env.DOCKER_PUSH_SUCCEEDED == "true" } }
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
        stage('Smoke test') {
            when {
                expression { env.DOCKER_PUSH_SUCCEEDED == "true" }
            }
            steps {
                container('python') {
                    script {
                        def url = "http://${HELM_RELEASE_NAME}.${APP_CLUSTER_NAMESPACE}.svc.cluster.local:8080"
                        def max_retries = 3
                        def timeout = 10
                        def success = false

                        for (int i = 1; i <= max_retries && !success; i++) {
                            try {
                                sh """
                                    pip install requests --quiet && \
                                    python -c "import requests,sys;r=requests.get('${url}',timeout=${timeout});sys.exit(0 if r.status_code==200 else 1)"
                                """
                                success = true
                                echo "✅ Service returned HTTP 200"
                            } catch (e) {
                                echo "⚠️ Attempt ${i} failed: ${e.message}"
                                if (i == max_retries) error("Smoke test failed after ${max_retries} attempts")
                                sleep(time: timeout, unit: 'SECONDS')
                            }
                        }
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