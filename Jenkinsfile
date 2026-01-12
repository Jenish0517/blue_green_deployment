pipeline {
    agent any

    tools {
        maven 'Maven 3.9.6'
    }

    environment {
        APP_NAME = "bluegreen-calculator"
        CONTAINER_NAME = "bluegreen-green"
    }

    stages {

        stage('Set Version & Build') {
            steps {
                sh '''
                # Get short Git commit (7 chars)
                GIT_SHORT_COMMIT=$(echo $GIT_COMMIT | cut -c 1-7)
                echo "Using version: $GIT_SHORT_COMMIT"

                # Set Maven version
                mvn versions:set -DnewVersion=$GIT_SHORT_COMMIT
                mvn versions:commit

                # Build package (skip tests)
                mvn clean package -DskipTests
                '''
            }
        }

        stage('Docker Build') {
            steps {
                sh '''
                GIT_SHORT_COMMIT=$(echo $GIT_COMMIT | cut -c 1-7)

                docker build -t $APP_NAME:$GIT_SHORT_COMMIT .
                '''
            }
        }

        stage('Deploy') {
            steps {
                sh '''
                GIT_SHORT_COMMIT=$(echo $GIT_COMMIT | cut -c 1-7)

                # Stop and remove old container if exists
                docker rm -f $CONTAINER_NAME || true

                # Run new container
                docker run -d \
                  --name $CONTAINER_NAME \
                  -p 8082:8080 \
                  $APP_NAME:$GIT_SHORT_COMMIT
                '''
            }
        }
    }
}
