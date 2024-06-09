pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                script {
                    // Pull the code from GitHub
                    git 'https://github.com/Ankitdevops18/capstone_1_website.git'
                    // Build Docker image
                    sh 'docker build -t my_webapp .'

                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Remove any existing container running on port 82
                    sh 'docker rm -f web || true'

                    // Run the new container
                    sh 'docker run -d -p 82:80 --name web my_webapp'
                }
            }
        }
    }
    post {
        always {
            // Clean up Docker resources
            sh 'docker rmi my_webapp'
        }
    }
}
