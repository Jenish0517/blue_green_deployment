pipeline {
    agent any

    environment {
        APP_NAME        = "bluegreen-calculator"
        BLUE_CONTAINER  = "bluegreen-blue"
        GREEN_CONTAINER = "bluegreen-green"
        BLUE_PORT       = "8082"
        GREEN_PORT      = "8083"
        NGINX_CONF      = "./nginx/nginx.conf"
    }

    stages {
        stage('Build Java App') {
            steps {
                sh 'javac Server.java'
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t $APP_NAME:latest .
                '''
            }
        }

        stage('Deploy BLUE') {
            steps {
                sh '''
                docker rm -f $BLUE_CONTAINER || true
                docker run -d \
                  --name $BLUE_CONTAINER \
                  -p $BLUE_PORT:8082 \
                  $APP_NAME:latest \
                  java -Dserver.port=8082 -Dstatic.dir=blue Server
                '''
            }
        }

        stage('Deploy GREEN') {
            steps {
                sh '''
                docker rm -f $GREEN_CONTAINER || true
                docker run -d \
                  --name $GREEN_CONTAINER \
                  -p $GREEN_PORT:8083 \
                  $APP_NAME:latest \
                  java -Dserver.port=8083 -Dstatic.dir=green Server
                '''
            }
        }

        stage('Health Check') {
            steps {
                sh '''
                echo "Waiting for containers to initialize..."
                sleep 5
                curl -f -s http://localhost:8082/ || exit 1
                curl -f -s http://localhost:8083/ || exit 1
                '''
            }
        }

        stage('Configure Nginx') {
            steps {
                sh '''
                if [ -z "$(docker ps -q -f name=bluegreen-nginx)" ]; then
                    docker rm -f bluegreen-nginx || true
                    docker run -d \
                      --name bluegreen-nginx \
                      -p 8090:80 \
                      --add-host host.docker.internal:host-gateway \
                      -v $(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
                      nginx
                else
                    docker cp $NGINX_CONF bluegreen-nginx:/etc/nginx/nginx.conf
                    docker exec bluegreen-nginx nginx -s reload
                fi
                '''
            }
        }
    }
}
