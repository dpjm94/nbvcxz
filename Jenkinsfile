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
                  sh 'mvn clean install' 
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
                   //sh '${sonarQube}/bin/sonar-scanner'
                   sh 'mvn clean package sonar:sonar'
            }   // SonarQube taskId is automatically attached to the pipeline context
        }
    }
    }
    
    post {
        always {
            echo 'Pipeline unit tests completed - recording JUnit results'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo 'I succeeeded!'
        }
        failure {
            mail to: 'dpjm94@live.ie',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
        }
        changed {
            echo 'Things were different before...'
        }
    }
}
