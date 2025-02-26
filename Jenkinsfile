pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git 'https://github.com/saicharan621/box.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Push JAR to Nexus') {
            steps {
                nexusArtifactUploader(
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '15.206.210.117:8081',
                    repository: 'maven-releases',
                    credentialsId: 'nexus-credentials',   // ✅ FIXED: Added Required Credentials ID
                    groupId: 'com.example',
                    version: '1.0.0',
                    artifacts: [
                        [
                            artifactId: 'hello-world-game',
                            classifier: '',
                            type: 'jar',
                            file: 'target/hello-world-game-1.0.0.jar'
                        ]
                    ]
                )
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t saicharan6771/helloworld:1.0.0 .'
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push saicharan6771/helloworld:1.0.0'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh 'kubectl apply -f deployment.yaml'
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful!"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
