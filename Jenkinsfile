pipeline {
    agent { label 'worker-1' }

    environment {
        IMAGE_NAME = "yourdockerhub/step-project-2"
    }

    stages {
        stage('Pull code') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run tests') {
            steps {
                sh 'docker run --rm $IMAGE_NAME'
            }
        }

        stage('Push image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh '''
                      echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                      docker push $IMAGE_NAME
                    '''
                }
            }
        }
    }

    post {
        failure {
            echo 'Tests failed'
        }
    }
}
