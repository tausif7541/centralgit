pipeline {
    agent any

    environment {
        GIT_REPO_URL = 'https://github.com/tausif7541/centralgit.git'
        GIT_CREDENTIALS_ID = 'Tausif_123'
        CONTAINER_NAME = 'testing'
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_HUB_REPO = 'yourdockerhubusername/testing'
        KUBECONFIG_CREDENTIALS_ID = 'k8s-config'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'master', credentialsId: "${GIT_CREDENTIALS_ID}", url: "${GIT_REPO_URL}"
            }
        }

        stage('Build') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh """
                    if [ \$(docker ps -q -f name=${CONTAINER_NAME}) ]; then
                        docker stop ${CONTAINER_NAME}
                        docker rm -f ${CONTAINER_NAME}
                    fi
                    if [ \$(docker images -q ${CONTAINER_NAME}) ]; then
                        docker rmi -f ${CONTAINER_NAME}
                    fi
                    """
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def app = docker.build("${DOCKER_HUB_REPO}:${env.BUILD_ID}")
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS_ID}") {
                        sh "docker push ${DOCKER_HUB_REPO}:${env.BUILD_ID}"
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                withCredentials([string(credentialsId: "${KUBECONFIG_CREDENTIALS_ID}", variable: 'KUBECONFIG_CONTENT')]) {
                    sh '''
                    echo "$KUBECONFIG_CONTENT" | base64 --decode > $WORKSPACE/kubeconfig
                    export KUBECONFIG=$WORKSPACE/kubeconfig
                    kubectl apply -f deployment.yml
                    kubectl apply -f service.yml
                    '''
                }
            }
        }
    }
}
