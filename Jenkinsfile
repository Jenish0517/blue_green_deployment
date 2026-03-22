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
                # Ensure the container is on the same network as Nginx
                docker run -d --name green-app --network blue-green-deployment_calc-net green-app
                '''
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh '''
                # 1. Update the config on disk
                sed -i 's/server blue-app:80;/# server blue-app:80;\\n        server green-app:80;/g' nginx/nginx.conf
                
                # 2. Sync the config into the Nginx container
                docker cp nginx/nginx.conf nginx-lb:/etc/nginx/nginx.conf
                
                # 3. Reload Nginx
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
