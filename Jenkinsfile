pipeline{
    agent any
    tools{
        maven 'mvn'
    }

    parameters{
        string(name: 'APP_NAME', defaultValue: 'my-app', description: 'Appliction Name')
        booleanParam(name: 'DEPLOY', defaultValue: true, description: 'Should we deploy?')
    }

    environment{
        IMAGE_NAME = 'my-image'
        REPO_URL = 'https://github.com/iam-aniketmore/registration-application.git'
        BRANCH = 'main'
    }

    stages{
        stage('checkout code'){
            steps{
                git branch: "${env.BRANCH}", url: "${env.REPO_URL}"
            }
        }

        stage('Build App') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Deploy to Dev Stage') {
            when {
                expression { return params.DEPLOY }
            }
            steps {
                script {
                    def port = '8081'
                    def env = 'dev'
                    def cname = "${params.APP_NAME}-${env}"
                    sh "docker build -t ${IMAGE_NAME}:${env} ."
                    sh "docker rm -f ${cname} || true"
                    sh "docker run -dt --name ${cname} -p ${port}:8080 ${IMAGE_NAME}:${env}"
                }
            }
        }

        stage('Deploy to QA Stage') {
            when {
                expression { return params.DEPLOY }
            }
            steps {
                script {
                    def port = '8082'
                    def env = 'qa'
                    def cname = "${params.APP_NAME}-${env}"
                    sh "docker build -t ${IMAGE_NAME}:${env} ."
                    sh "docker rm -f ${cname} || true"
                    sh "docker run -dt --name ${cname} -p ${port}:8080 ${IMAGE_NAME}:${env}"
                }
            }
        }

        stage('Approve for Production') {
            steps {
                timeout(time: 3, unit: 'MINUTES') {
                    input message: "Do you approve deploying to PROD", ok: 'Yes, Deploy'
                }
            }
        }

        stage('Deploy to PROD Stage') {
            when {
                expression { return params.DEPLOY }
            }
            steps {
                script {
                    def port = '8083'
                    def env = 'prod'
                    def cname = "${params.APP_NAME}-${env}"
                    sh "docker build -t ${IMAGE_NAME}:${env} ."
                    sh "docker rm -f ${cname} || true"
                    sh "docker run -dt --name ${cname} -p ${port}:8080 ${IMAGE_NAME}:${env}"
                }
            }
        }
    }
    post {
        always {
            echo "Pipeline complete for ${params.APP_NAME}"
        }
    }
}
