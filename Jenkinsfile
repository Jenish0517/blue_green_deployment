pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'
    }

    environment {
        APP_NAME        = "bluegreen-calculator"
        BLUE_CONTAINER  = "bluegreen-blue"
        GREEN_CONTAINER = "bluegreen-green"
        BLUE_PORT       = "8081"
        GREEN_PORT      = "8082"
        NGINX_CONF      = "./nginx/nginx.conf"
    }

    stages {

        stage('Build App') {
            steps {
                sh '''
                mvn clean package -Pblue
                mvn package -Pgreen
                '''
            }
        }

        stage('Build Docker Images') {
            steps {
                sh '''
                docker build -t $APP_NAME:blue  --build-arg JAR_FILE=calculator-blue.jar .
                docker build -t $APP_NAME:green --build-arg JAR_FILE=calculator-green.jar .
                '''
            }
        }

        stage('Deploy GREEN') {
            steps {
                sh '''
                docker rm -f $GREEN_CONTAINER || true

                docker run -d \
                  --name $GREEN_CONTAINER \
                  -p $GREEN_PORT:8082 \
                  $APP_NAME:green

                sleep 15
                docker ps
                docker logs $GREEN_CONTAINER
                '''
            }
        }

        stage('Smoke Test GREEN') {
            steps {
                sh '''
                sleep 10
                curl -f http://localhost:8082
                '''
            }
        }

        stage('Switch NGINX to GREEN') {
            steps {
                sh '''
                echo "Switching traffic to GREEN..."

                sed -i 's/set \\$deployment "blue"/set \\$deployment "green"/' $NGINX_CONF

                sudo nginx -t
                sudo systemctl reload nginx
                '''
            }
        }

        stage('Stop BLUE') {
            steps {
                sh '''
                docker stop $BLUE_CONTAINER || true
                docker rm   $BLUE_CONTAINER || true
                '''
            }
        }
    }

    post {
        failure {
            echo "Deployment failed. BLUE is still active."
        }
        success {
            echo "Deployment successful. GREEN is live."
        }
    }
}
