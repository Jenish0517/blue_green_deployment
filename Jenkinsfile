pipeline {
    agent any

    stages {
        stage('Init Infrastructure') {
            steps {
                sh '''
                # Remove existing containers to prevent naming conflicts
                docker rm -f blue-app green-app nginx-lb || true
                docker-compose up -d --build
                '''
            }
        }

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
                # Using a simpler sed approach that matches the current config structure
                sed -i 's/server blue-app:80;/# server blue-app:80;\\n        server green-app:80;/g' nginx/nginx.conf
                
                # 2. Ensure nginx-lb is running before syncing
                if [ "$(docker inspect -f '{{.State.Running}}' nginx-lb 2>/dev/null)" != "true" ]; then
                    echo "nginx-lb is not running. Starting infrastructure..."
                    docker-compose up -d nginx
                fi
                
                # 3. Sync the config into the Nginx container
                # We use -i for interactive stdin to pipe the file content
                docker exec -i nginx-lb sh -c 'cat > /etc/nginx/nginx.conf' < nginx/nginx.conf
                
                # 4. Reload Nginx
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
