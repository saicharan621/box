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
        NEXUS_URL = "15.206.210.117:8081"
        EKS_CLUSTER = "helloworld-cluster"
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
                sh 'mvn clean package'
            }
        }

        stage('Push JAR to Nexus') {
            steps {
                sh 'mvn deploy -DaltDeploymentRepository=nexus::default::http://$NEXUS_URL/repository/maven-releases/'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh '''
                docker build -t $DOCKER_IMAGE .
                docker login -u $DOCKER_HUB_USER -p $DOCKER_HUB_PASS
                '''
            }
        }

        stage('Push Image to Docker Hub') {
            steps {
                sh 'docker push $DOCKER_IMAGE'
            }
        }

        stage('Deploy to EKS') {
            steps {
                sh '''
                aws eks --region us-east-1 update-kubeconfig --name $EKS_CLUSTER
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
