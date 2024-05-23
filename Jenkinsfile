pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('1909')
        AWS_SECRET_ACCESS_KEY = credentials('1909')
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials-id')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/todoappsworld/user-service.git', credentialsId: '1fc287af-fcff-421a-aeba-734cc9660dde'
            }
        }
        stage('Build Docker Image') {
            steps {
                script {
                    dockerImage = docker.build("saymontr/user-service:latest")
                }
            }
        }
        stage('Run Tests') {
            steps {
                script {
                    dockerImage.inside {
                        sh 'npm install'
                        sh 'npm run lint'
                        sh 'npm test'
                        sh 'npm run build'
                    }
                }
            }
        }
        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials-id') {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Package') {
            steps {
                sh 'sam package --template-file template.yaml --s3-bucket my-sam-artifacts-bucket --output-template-file packaged.yaml'
            }
        }
        stage('Deploy to Test') {
            steps {
                sh 'sam deploy --template-file packaged.yaml --stack-name user-service-test-stack --capabilities CAPABILITY_IAM --parameter-overrides Environment=testing'
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                script {
                    kubernetesDeploy(configs: 'k8s/*.yaml', kubeConfig: [path: '/root/.kube/config'])
                }
            }
        }
        stage('Deploy to Prod') {
            steps {
                input "Deploy to production?"
                sh 'sam deploy --template-file packaged.yaml --stack-name user-service-prod-stack --capabilities CAPABILITY_IAM --parameter-overrides Environment=production'
            }
        }
    }
}