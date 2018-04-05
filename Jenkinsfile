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
        
        stage('Sonar scan execution') {
            steps{
                script {
                echo 'Sonar Scanner'
                def mvnHome = tool 'm2'
                withSonarQubeEnv{
                    
                    sh "'${mvnHome}/bin/mvn'  verify sonar:sonar -Dintegration-tests.skip=true -Dmaven.test.failure.ignore=true"
                   //sh '${sonarQube}/bin/sonar-scanner'
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
        
        stage('Docker - Build Image'){
            steps{
                script{
                    echo 'Building image...'
                    
                    withDockerRegistry([url: 'unix:///var/run/docker.sock']) {
                      sh 'Docker pull version'
                    }
                    //docker.withTool('Docker') {
                        
                        //sh 'Docker pull maven:3.5.0-jdk-8-alpine'
                    //def root = tool 'Docker'
                    //withDockerContainer('maven:3.5.0-jdk-8-alpine', toolName: 'Docker') { sh "mvn clean install"}
                    //withDockerContainer("maven:3.5.0-jdk-8-alpine") { sh "mvn clean install"}
                    //step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'] )
                    //}
                }//end script
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
            mail to: 'dpjm94@live.ie',
             subject: "Failed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Something is wrong with ${env.BUILD_URL}"
        }
        changed {
            mail to: 'dpjm94@live.ie',
             subject: "Changed Pipeline: ${currentBuild.fullDisplayName}",
             body: "Things were different before with ${env.BUILD_URL}"
        }
    }
}



