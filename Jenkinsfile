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
                echo 'Clean Build'
                withMaven(jdk: 'JDK9.0.1', maven: 'Maven3.5.2') {
                  sh 'mvn clean install'
                }
            }
        }
        
        stage('Test'){
            steps{
                echo 'Testing'
                sh 'mvn test'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                echo 'Unit Testing'
                junit '**/target/test-reports/*.xml'
            }
        }
        
        stage('Sonar') {
            steps{
                echo 'Sonar Scanner'
                withSonarQubeEnv('Sonar5.4'){
                   //sh '${sonarQube}/bin/sonar-scanner'
                   sh 'mvn clean package sonar:sonar'
            }   // SonarQube taskId is automatically attached to the pipeline context
        }
        }
    }
    
    post {
        always {
            echo 'One way or another, I have finished'
            deleteDir() /* clean up our workspace */
        }
        success {
            echo 'I succeeeded!'
        }
        failure {
            echo 'I failed :('
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
}
