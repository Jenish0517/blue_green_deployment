pipeline {
    agent any

    stages {

        stage('Start Blue Environment') {
            steps {
                sh 'docker-compose up -d --build'
            }
        }

        stage('Deploy Green Version') {
            steps {
                sh 'docker-compose build green'
                sh 'docker-compose up -d green'
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh '''
                sed -i 's/server blue:80;/# server blue:80;\\n        server green:80;/g' nginx/nginx.conf
                docker exec nginx-lb nginx -s reload
                '''
            }
        }
    }
}