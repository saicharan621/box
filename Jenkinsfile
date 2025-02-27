pipeline {
    agent any

    environment {
        MAVEN_HOME = "/usr/share/maven"
        PATH = "${MAVEN_HOME}/bin:${PATH}"
        SONARQUBE_NAME = "sonar-box"
        SONAR_URL = "http://3.110.104.81:9000"
        SONAR_TOKEN = "squ_f7d1496e2b53a5c1d19b66130385a573ddd1ac43"
        DOCKER_HUB_USER = "saicharan6771"
        DOCKER_HUB_PASS = "Welcome@123"
        DOCKER_IMAGE = "saicharan6771/helloworld"
        NEXUS_URL = "http://15.206.210.117:8081"
        EKS_CLUSTER = "helloworld-cluster"
        MAVEN_SETTINGS = "/var/lib/jenkins/.m2/settings.xml"
    }

    stages {
        stage('Checkout Code from GitHub') {
            steps {
                git branch: 'main', url: 'https://github.com/saicharan621/box.git'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-box') {
                    sh 'mvn clean verify sonar:sonar -Dsonar.login=$SONAR_TOKEN'
                }
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
                sh 'ls -lh target/' // ✅ Debug: Ensure JAR is created
            }
        }

        stage('Set Version and Push JAR to Nexus') {
            steps {
                script {
                    def timestamp = sh(script: "date +%Y%m%d-%H%M%S", returnStdout: true).trim()
                    env.BUILD_VERSION = "1.0.0-${timestamp}"
                }
                sh '''
                mvn versions:set -DnewVersion=$BUILD_VERSION
                mvn clean deploy -s $MAVEN_SETTINGS
                ls -lh target/  # ✅ Debug: Ensure JAR exists before Docker build
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build --no-cache -t $DOCKER_IMAGE:$BUILD_VERSION .
                docker tag $DOCKER_IMAGE:$BUILD_VERSION $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh '''
                echo "$DOCKER_HUB_PASS" | docker login -u "$DOCKER_HUB_USER" --password-stdin
                docker push $DOCKER_IMAGE:$BUILD_VERSION
                docker push $DOCKER_IMAGE:latest
                '''
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region ap-south-1 update-kubeconfig --name $EKS_CLUSTER
                sed -i "s|IMAGE_PLACEHOLDER|$DOCKER_IMAGE:$BUILD_VERSION|g" deployment.yaml
                kubectl apply -f deployment.yaml
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Deployment Successful! Version: $BUILD_VERSION"
        }
        failure {
            echo "❌ Deployment Failed!"
        }
    }
}
