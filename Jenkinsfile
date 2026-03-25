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
                # Connect to the exact network name: blue-green-net
                docker run -d --name green-app --network blue-green-net green-app
                '''
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh '''
                # 1. Update the config on disk in the workspace
                sed -i 's|server blue-app:80;|# server blue-app:80;\\n        server green-app:80;|g' nginx/nginx.conf
                
                # 2. Sync the config into the Nginx container
                # We use cat | docker exec to avoid 'device or resource busy' error on bind mounts
                cat nginx/nginx.conf | docker exec -i nginx-lb sh -c 'cat > /etc/nginx/nginx.conf'
                
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
