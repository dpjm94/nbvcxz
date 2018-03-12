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
                sh 'mvn clean install'
            }
        }
        
        stage('Test'){
            steps{
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                step([$class: 'ArtifactArchiver', artifacts: '**/target/*.jar', fingerprint: true])
                
        }
        }
    }
}
