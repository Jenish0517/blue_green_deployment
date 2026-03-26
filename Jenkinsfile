lpipeline {
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

        stage('Pause for Demo (Blue Live)') {
            steps {
                input message: '🔵 Blue is live! Check http://localhost. Click "Proceed" to switch to Green.'
            }
        }

        stage('Deploy Green') {
            steps {
                sh 'docker compose build green'
                sh 'docker compose up -d green'
            }
        }

    }
}
