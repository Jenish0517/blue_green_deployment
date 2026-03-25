pipeline {
    agent any

    stages {

        stage('Cleanup') {
            steps {
                sh 'docker compose down || true'
            }
        }

        stage('Start Application (Blue Live)') {
            steps {
                sh 'docker compose up -d --build'
            }
        }

        stage('Wait Before Switch') {
            steps {
                echo "Waiting 10 seconds... Blue is live now"
                sleep 10
            }
        }

        stage('Deploy Green') {
            steps {
                sh 'docker compose build green'
                sh 'docker compose up -d green'
            }
        }

        stage('Switch Traffic') {
            steps {
                sh './scripts/switch_to_green.sh'
            }
        }
    }
}