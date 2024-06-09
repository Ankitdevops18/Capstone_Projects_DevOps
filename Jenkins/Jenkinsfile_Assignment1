pipeline {
    agent any

    environment {
        GIT_REPO_URL = 'https://github.com/Ankitdevops18/capstone_1_website.git'
        TARGET_DIR = '/assignment1'  // Change this to your desired folder
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Clone Repository') {
            steps {
                script {
                    // Ensure the target directory exists and is clean
                    sh "rm -rf ${TARGET_DIR}"
                    sh "mkdir -p ${TARGET_DIR}"

                    // Clone the repository into the target directory
                    git branch: 'develop', url: "${GIT_REPO_URL}"
                    sh "cp -r * ${TARGET_DIR}/"
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up any temporary files if needed
                sh "rm -rf ${TARGET_DIR}/tmp"
            }
        }
    }
}
