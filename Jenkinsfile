pipeline {
    agent any
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Build') {
            steps {
                bat 'mvn clean package'
            }
        }
        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }
    }
    post {
            success {
            echo 'Build successful! The WAR file is ready for deployment.'
            }
            failure {
            echo 'Build failed! Please check the logs for details.'
            }
    }
    
}
