pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'
    }

    environment {
        APP_NAME = "bluegreen-calculator"
        BLUE_CONTAINER = "bluegreen-blue"
        GREEN_CONTAINER = "bluegreen-green"
        BLUE_PORT = "8081"
        GREEN_PORT = "8082"
        NGINX_CONF = "/etc/nginx/conf.d/bluegreen.conf"
    }

    stages {

        stage('Build App') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                COMMIT=$(echo $GIT_COMMIT | cut -c1-7)
                docker build -t $APP_NAME:$COMMIT .
                '''
            }
        }

        stage('Deploy GREEN') {
            steps {
                sh '''
                COMMIT=$(echo $GIT_COMMIT | cut -c1-7)

                docker rm -f $GREEN_CONTAINER || true

                docker run -d \
                  --name $GREEN_CONTAINER \
                  -p $GREEN_PORT:8080 \
                  $APP_NAME:$COMMIT
                '''
            }
        }

        stage('Smoke Test GREEN') {
            steps {
                sh '''
                sleep 10
                curl -f http://localhost:$GREEN_PORT || exit 1
                '''
            }
        }

        stage('Switch NGINX to GREEN') {
            steps {
                sh '''
                sudo sed -i 's/8081/8082/' $NGINX_CONF
                sudo nginx -t
                sudo systemctl reload nginx
                '''
            }
        }

        stage('Stop BLUE') {
            steps {
                sh '''
                docker stop $BLUE_CONTAINER || true
                docker rm $BLUE_CONTAINER || true
                '''
            }
        }
    }
}
