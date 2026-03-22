pipeline {
    agent any

    stages {
        stage('Prepare Network') {
            steps {
                sh 'docker network create blue-green-net || true'
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
                docker run -d --name green-app --network blue-green-net green-app
                '''
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh '''
                # 1. Update the local config file
                sed -i 's/server blue-app:80;/# server blue-app:80;\\n        server green-app:80;/g' nginx/nginx.conf
                
                # 2. Ensure nginx-lb is running and on the same network
                if [ ! "$(docker ps -q -f name=nginx-lb)" ]; then
                    docker rm -f nginx-lb || true
                    docker run -d --name nginx-lb -p 80:80 --network blue-green-net \
                        -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
                        nginx:latest
                else
                    # 3. Copy the updated config and reload
                    docker cp nginx/nginx.conf nginx-lb:/etc/nginx/nginx.conf
                    docker exec nginx-lb nginx -s reload
                fi
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
