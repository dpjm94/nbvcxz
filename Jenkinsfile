pipeline {
    agent any
    tools {
        maven 'm2'
        jdk 'Java8'
    }
    stages {
        stage ('Initialize') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                '''
            }
        }

        stage ('Build') {
            steps {
                sh 'mvn package'
            }
        }
        
        stage('Test'){
            steps{
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
            }
        }
        
        stage('Test archive'){
            steps{
                archive '**/target/*.jar'
            }
        }
        
        stage('build & SonarQube Scan') {
            steps{
            withSonarQubeEnv('Sonar5.4') {
                sh 'mvn clean package sonar:sonar'
            }   // SonarQube taskId is automatically attached to the pipeline context
        }
        }
        
        // No need to occupy a node
        stage("Quality Gate") {
            steps{
            timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
                def qg = waitForQualityGate('Sonar5.4') 
                if (qg.status != 'OK') {
                   error "Pipeline aborted due to quality gate failure: ${qg.status}"
                }
                }
            }
        }
    }
}
