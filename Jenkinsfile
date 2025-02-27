pipeline {
    agent any

    environment {
        SONARQUBE_SERVER = 'sonarqube'  // The SonarQube server ID configured in Jenkins
        SONARQUBE_CREDENTIALS = 'sonar-new' // The new credential ID
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/box.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv(SONARQUBE_SERVER) {
                    sh '''
                        mvn sonar:sonar \
                        -Dsonar.projectKey=helloworld \
                        -Dsonar.host.url=http://3.110.104.81:9000 \
                        -Dsonar.login=$SONARQUBE_CREDENTIALS
                    '''
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
                sh '''
                    mvn deploy:deploy-file \
                    -DgroupId=com.example \
                    -DartifactId=helloworld \
                    -Dversion=1.0.0 \
                    -Dpackaging=jar \
                    -Dfile=target/helloworld.jar \
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
                withDockerRegistry([credentialsId: 'docker-hub', url: '']) {
                    sh '''
                        docker push saicharan6771/helloworld:latest
                    '''
                }
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                    kubectl apply -f k8s/deployment.yaml
                    kubectl apply -f k8s/service.yaml
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
