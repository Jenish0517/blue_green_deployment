pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }
        stage('Docker Build') {
            steps {
                sh 'docker build -t bluegreen-calculator:green .'
            }
        }
        stage('Deploy') {
            steps {
                sh 'docker run -d -p 8082:8080 bluegreen-calculator:green'
            }
        }
    }
}