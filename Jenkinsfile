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
                sh 'mvn sonar:sonar -Dsonar.host.url=http://3.110.104.81:9000'
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
                    credentialsId: 'nexus-credentials',  // Add this in Jenkins Credentials
                    groupId: 'com.example',
                    artifactId: 'hello-world-game',
                    version: '1.0.0',
                    packaging: 'jar',
                    file: 'target/hello-world-game-1.0.0.jar'
                )
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t saicharan6771/helloworld .'
            }
        }
        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
                    sh 'docker push saicharan6771/helloworld'
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
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
