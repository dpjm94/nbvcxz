pipeline {
    agent any
    tools {
        maven 'm2'
        jdk 'Java8'
        hudson.plugins.sonar.SonarRunnerInstallation 'SonarQube Scanner'
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
                echo 'Clean Build'
                sh 'mvn clean package'
            }
        }
        
        stage('Test'){
            steps{
                echo 'Testing'
                sh 'mvn test'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
            }
        }
        
        stage('Sonar') {
            steps{
                echo 'Sonar Scanner'
                withSonarQubeEnv('Sonar5.4'){
                    sh '${scannerHome}/bin/sonar-scanner'
                //sh 'mvn clean package sonar:sonar'
            }   // SonarQube taskId is automatically attached to the pipeline context
        }
        }
    }
}
