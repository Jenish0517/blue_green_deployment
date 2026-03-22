pipeline {
    agent any

    environment {
        IMAGE_NAME      = "bluegreen-calculator"
        BLUE_CONTAINER  = "bluegreen-blue"
        GREEN_CONTAINER = "bluegreen-green"
        NGINX_CONTAINER = "bluegreen-nginx"
        NGINX_CONF      = "./nginx/nginx.conf"
    }

    stages {
        stage('Build Image') {
            steps {
                // Build inside Docker so we don't need Java on the Jenkins host
                sh "docker build -t ${IMAGE_NAME} ."
            }
        }

        stage('Deploy Containers') {
            steps {
                sh """
                # 1. Clean up old containers
                docker rm -f ${BLUE_CONTAINER} ${GREEN_CONTAINER} ${NGINX_CONTAINER} || true

                # 2. Start BLUE (Port 8082)
                docker run -d --name ${BLUE_CONTAINER} -p 8082:8082 -e SERVER_PORT=8082 -e STATIC_DIR=blue ${IMAGE_NAME}

                # 3. Start GREEN (Port 8083)
                docker run -d --name ${GREEN_CONTAINER} -p 8083:8083 -e SERVER_PORT=8083 -e STATIC_DIR=green ${IMAGE_NAME}

                # 4. Start NGINX
                docker run -d --name ${NGINX_CONTAINER} -p 8090:80 \
                  --add-host host.docker.internal:host-gateway \
                  -v \$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
                  nginx
                """
            }
        }

        stage('Health Check') {
            steps {
                sh "sleep 5 && curl -f http://localhost:8082/ && curl -f http://localhost:8083/"
            }
        }
    }
}
