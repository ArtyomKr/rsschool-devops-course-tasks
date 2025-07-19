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
              - name: helm
                image: alpine/helm:3.12.0
                command: ["cat"]
                tty: true
              - name: kubectl
                image: bitnami/kubectl:latest
                command: ["cat"]
                tty: true
            '''
        }
    }
    environment {
        PROMETHEUS_CHART_NAME = "kube-prometheus-stack"
        PROMETHEUS_CLUSTER_NAMESPACE = "monitoring"
        CONFIG_DIR = "./helm/kube-prometheus-stack"
    }
    stages {
            stage('Apply Grafana Configurations') {
                steps {
                    container('kubectl') {
                        sh '''
                            kubectl apply -f ${CONFIG_DIR}/grafana-contact-points.yaml \
                                          -f ${CONFIG_DIR}/grafana-alert-rules.yaml \
                                          -f ${CONFIG_DIR}/grafana-dashboards.yaml \
                                          -n ${PROMETHEUS_CLUSTER_NAMESPACE}
                        '''
                    }
                }
            }

            stage('Deploy Prometheus Stack') {
                steps {
                    container('helm') {
                        sh '''
                            helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
                            helm repo update
                            helm upgrade --install prometheus prometheus-community/${PROMETHEUS_CHART_NAME} \
                                -n ${PROMETHEUS_CLUSTER_NAMESPACE} \
                                -f ${CONFIG_DIR}/values.yaml \
                                --create-namespace \
                                --atomic \
                                --wait
                        '''
                    }
                }
            }
        }
    post {
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}