pipeline {
    agent any

    stages {

        stage('Build Green Image') {
            steps {
                sh 'docker build -t green-app ./green'
            }
        }

        stage('Deploy Green') {
            steps {
                sh '''
                docker rm -f green-app || true
                docker run -d --name green-app green-app
                '''
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

        stage('Done') {
            steps {
                echo "Deployment to GREEN successful"
            }
        }
    }
}
