pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'mvn clean package -DskipTests'
        sh '''#Truncate the GIT_COMMIT to the first 7 characters
 GIT_SHORT_COMMIT=$(echo $GIT_COMMIT | cut -c 1-7)

#Set the version using Maven

mvn versions:set -DnewVersion="$GIT_SHORT_COMMIT"
mvn versions:commit'''
      }
    }

    stage('Docker Build') {
      steps {
        sh 'docker build -t bluegreen-calculator:green .'
      }
    }

    stage('Deploy') {
      steps {
        sh 'docker run -d -p 8082:8080 bluegreen-calculator:green'
      }
    }

  }
  tools {
    maven 'Maven 3.9.6'
  }
}
