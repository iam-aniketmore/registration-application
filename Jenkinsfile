pipeline {
    agent none

    tools {
        maven 'mvn'   // Make sure 'mvn' is defined under Jenkins -> Global Tool Configuration
    }

    environment {
        IMAGE_NAME = "my-image2"
        CONTAINER_NAME = "my-container2"
    }

    stages {
        stage('Checkout') {
            agent any
            steps {
                git branch: 'main', url: 'https://github.com/iam-aniketmore/registration-application.git'
            }
        }

        stage('Build') {
            agent{ label 'mvn'}
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                agent { label 'docker' }
                sh 'rm -rf $IMAGE_NAME || true'
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Run Container') {
            steps {
                agent { label 'docker' }
                sh "docker rm -f $CONTAINER_NAME || true"
                sh "docker run -dt --name $CONTAINER_NAME -p 8082:8080 $IMAGE_NAME"
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed.'
        }

        always {
            echo 'Pipeline finished running (success or fail).'
        }
    }
}
