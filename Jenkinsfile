pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/saicharan621/helloworld.git'  // Update with your Git repo
        NEXUS_URL = '15.206.210.117:8081'
        NEXUS_REPO = 'maven-releases'
        DOCKER_IMAGE = 'saicharan6771/helloworld'
        EKS_CLUSTER = 'helloworld-cluster'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: "${GIT_REPO}"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                script {
                    withSonarQubeEnv('SonarQube') {
                        sh 'mvn sonar:sonar -Dsonar.host.url=http://3.110.104.81:9000 -Dsonar.login=admin -Dsonar.password=admin123'
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
                sh """
                mvn deploy:deploy-file \
                -DgroupId=com.helloworld \
                -DartifactId=helloworld \
                -Dversion=1.0.0 \
                -Dpackaging=jar \
                -Dfile=target/helloworld-1.0.0.jar \
                -DrepositoryId=nexus \
                -Durl=http://${NEXUS_URL}/repository/${NEXUS_REPO}/ \
                -DgeneratePom=true \
                -Dauth.username=admin -Dauth.password=admin
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                sh """
                docker build -t ${DOCKER_IMAGE}:latest .
                docker tag ${DOCKER_IMAGE}:latest ${DOCKER_IMAGE}:1.0
                """
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh """
                echo "Welcome@123" | docker login -u saicharan6771 --password-stdin
                docker push ${DOCKER_IMAGE}:latest
                docker push ${DOCKER_IMAGE}:1.0
                """
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh """
                aws eks update-kubeconfig --region ap-south-1 --name ${EKS_CLUSTER}
                kubectl apply -f deployment.yaml
                kubectl apply -f service.yaml
                """
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
