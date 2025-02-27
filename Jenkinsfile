pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-credentials')
        NEXUS_CREDENTIALS = credentials('nexus-credentials')
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/box.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Push JAR to Nexus') {
            steps {
                sh '''
                mvn deploy:deploy-file \
                    -DgroupId=com.example \
                    -DartifactId=helloworld \
                    -Dversion=1.0 \
                    -Dpackaging=jar \
                    -Dfile=target/helloworld-1.0.jar \
                    -DrepositoryId=nexus \
                    -Durl=http://15.206.210.117:8081/repository/maven-releases/
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t saicharan6771/helloworld:latest .
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                withDockerRegistry([credentialsId: 'docker-hub-credentials', url: '']) {
                    sh 'docker push saicharan6771/helloworld:latest'
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                kubectl apply -f deployment.yaml
                '''
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
