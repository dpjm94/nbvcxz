pipeline {
  agent any

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
                    echo "JAVA_HOME = ${JAVA_HOME}"
                    echo "MAVEN_HOME = ${MAVEN_HOME}"
                '''
              }
            }
        }
     
        
        stage ('Build') {
            steps {
                echo 'Clean Build...'
                  sh 'mvn -B -DskipTests clean package'
            }
        }
        
        stage('Test'){
            steps{
                echo 'Testing...'
                sh 'mvn test'
                step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
            }
        }
      
        stage('Sonar scan execution') {
            steps{
                script {
                echo 'Sonar Scanner...'
                def mvnHome = tool 'm2'
                def SCANNER_HOME = tool 'Scanner'
                  
                withSonarQubeEnv{
                    
                    //sh "'${mvnHome}/bin/mvn'  verify sonar:sonar -Dintegration-tests.skip=true -Dmaven.test.failure.ignore=true"
                    //sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar'  
                    //sh "'${SCANNER_HOME}/bin/sonar-scanner' verify sonar:sonar -Dintegration-tests.skip=true -Dmaven.test.failure.ignore=true"
                    
                    sh 'mvn clean install sonar:sonar'
                    
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
      
      stage('Package') {
            steps {
                echo 'Packaging...'
                sh 'mvn package -DskipTests'
            }
        }
      
       stage('Deliver') {
            steps {
                echo 'Delivering...'
                sh './scripts/deliver.sh'
            }
        }
       
        
    }//end of stages

 
       
    post {
        always {
            echo 'PIPELINE UNIT TESTS COMPLETED - RECORDING JUNIT RESULTS'
            junit '**/target/surefire-reports/*.xml'
        }
        success {
            echo 'JENKINS PIPELINE SUCCESSFUL'
        }
        failure {
            echo 'JENKINS PIPELINE FAILED'
            mail to: 'donalmaher25@gmail.com',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
        }
        changed {
            echo 'JENKINS PIPELINE STATUS HAS CHANGED SINCE LAST EXECUTION'
            mail to: 'donalmaher25gmail.com',
             subject: "Changed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Things were different before with ${env.BUILD_URL}"
        }
    }
}



