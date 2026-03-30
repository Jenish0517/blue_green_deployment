pipeline {
    agent any

    stages {

        stage('Cleanup') {
            steps {
                sh 'docker compose down || true'
            }
        }

        stage('Start Blue') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Pause') {
            steps {
                input message: '🔵 Blue is live. Proceed to deploy Green.'
            }
        }

        stage('Deploy Green') {
            steps {
                sh 'docker compose build green'
                sh 'docker compose up -d green'
            }
        }

        stage('Health Check Green') {
            steps {
                sh './scripts/health_check.sh'
            }
        }

        stage('Switch Traffic to Green') {
            steps {
                sh './scripts/switch_to_green.sh'
            }
        }
    }

    post {
        failure {
            echo "Rollback triggered..."

            sh './scripts/switch_to_blue.sh'
        }
    }
}
