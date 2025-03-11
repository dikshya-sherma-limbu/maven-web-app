// pipeline {
//     agent any
//
//     stages {
//         stage('Checkout') {
//             steps {
//                 checkout scm
//             }
//         }
//         stage('Build') {
//             steps {
//                 bat 'mvn clean package'
//             }
//         }
//         stage('Archive') {
//             steps {
//                 archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
//             }
//         }
//     }
//     post {
//             success {
//             echo 'Build successful! The WAR file is ready for deployment.'
//             }
//             failure {
//             echo 'Build failed! Please check the logs for details.'
//             }
//     }
//
// }

pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Maven Project') {
            steps {
                bat 'mvn clean package'
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/*.war', followSymlinks: false
            }
        }

        stage('Docker Login') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials',
                                              passwordVariable: 'DOCKER_PASSWORD',
                                              usernameVariable: 'DOCKER_USERNAME')]) {
                    bat 'echo %DOCKER_PASSWORD% | docker login -u %DOCKER_USERNAME% --password-stdin'
                }
            }
        }

        stage('Docker Build') {
            steps {
                bat 'docker build -t dikshya003/webapp:latest .'
            }
        }

        stage('Docker Push') {
            steps {
                bat 'docker push dikshya003/webapp:latest'
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
        always {
            bat 'docker logout'
        }
    }
}
