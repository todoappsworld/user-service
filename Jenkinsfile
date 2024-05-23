pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('1909')
        AWS_SECRET_ACCESS_KEY = credentials('1909')
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/todoappsworld/user-service.git', credentialsId: '1fc287af-fcff-421a-aeba-734cc9660dde'
            }
        }
        stage('Install dependencies') {
            steps {
                sh 'npm install'
            }
        }
        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }
        stage('Test') {
            steps {
                sh 'npm test'
            }
        }
        stage('Build') {
            steps {
                sh 'npm run build'
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
        stage('Deploy to Prod') {
            steps {
                input "Deploy to production?"
                sh 'sam deploy --template-file packaged.yaml --stack-name user-service-prod-stack --capabilities CAPABILITY_IAM --parameter-overrides Environment=production'
            }
        }
    }
}