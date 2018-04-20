pipeline {
  agent any
  options {
    buildDiscarder(logRotator(numToKeepStr: '5'))
  }
  triggers {
    cron('@daily')
  }
    tools {
        maven 'm2'
        jdk 'Java8'
    }
    
    stages {
        stage ('Initialize') {
            steps {
              script{
                
                def SCANNER_HOME = tool 'Scanner'
                
                sh '''
                    echo "PATH = ${PATH}"
                    echo "JAVA_HOME = ${JAVA_HOME}"
                    echo "MAVEN_HOME = ${MAVEN_HOME}"
                    echo "SONAR_RUNNER_HOME = ${SCANNER_HOME}"
                '''
              }
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
        
        stage('Sonar scan execution') {
            steps{
                script {
                echo 'Sonar Scanner'
                def mvnHome = tool 'm2'
                def SCANNER_HOME = tool 'Scanner'
                  
                withSonarQubeEnv{
                    
                    //sh "'${mvnHome}/bin/mvn'  verify sonar:sonar -Dintegration-tests.skip=true -Dmaven.test.failure.ignore=true"
         
                    //sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'  
                    sh "${SCANNER_HOME}/bin/sonar-scanner -Dmaven.test.failure.ignore=true"
                    //sh 'mvn clean package sonar:sonar'
                    
                }
            }   
                  
                    
        }
    }
        
         stage('Sonar scan result check') {
            steps {
                timeout(time: 2, unit: 'MINUTES') {
                    retry(3) {
                        script {
                            def qg = waitForQualityGate()
                            if (qg.status != 'OK') {
                                error "Pipeline aborted due to quality gate failure: ${qg.status}"
                            }
                        }
                    }
                }
            }
        }
      
      stage('Docker'){
        steps{
          script{
          def DOCKER_HOME = tool 'doc'
          
          sh '''
          echo "DOCKER_HOME = ${DOCKER_HOME}"
          '''
          }
        }
      }
        
 
        
    }//end of stages

 
       
    post {
        always {
            echo 'Pipeline unit tests completed - recording JUnit results'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo 'It succeeeded!'
        }
        failure {
            mail to: 'donalmaher25@gmail.com',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
        }
        changed {
            mail to: 'donalmaher25gmail.com',
             subject: "Changed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Things were different before with ${env.BUILD_URL}"
        }
    }
}



