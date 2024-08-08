pipeline {
    agent any

    tools {
        maven 'M2_HOME' // Assumes Maven is installed on Jenkins and labeled as 'M2'
    }

    environment {
        GIT_REPO_URL = 'https://github.com/tausif7541/centralgit.git'
        GIT_CREDENTIALS_ID = 'Tausif_123' // The ID of the GitHub credentials in Jenkins
        CONTAINER_NAME = 'testing'
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
                    def app = docker.build("${CONTAINER_NAME}")
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    sh "docker run -d -p 8081:8081 --name ${env.CONTAINER_NAME} ${env.CONTAINER_NAME}"
                }
            }
        }
    }
}
