def CONTAINER_NAME="jenkins"
def CONTAINER_TAG="latest"
def DOCKER_HUB_USER="dpjm94"
def HTTP_PORT="8090"

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
        
        customWorkspace '/Users/Shared/Jenkins/Home/workspace/Password_strength-Pipeline'
        
        stage("Image Prune"){
            steps{
                imagePrune(CONTAINER_NAME)
            }
        }
        
         stage('Docker Build') {
            agent none
                steps {
                    imageBuild(CONTAINER_NAME, CONTAINER_TAG)
                    script{
                        def dockerHome = tool 'myDocker'
                        env.PATH = "${dockerHome}/bin"
                      }
                    
                }
            }
        
          stage('Push to Docker Registry'){
              steps{
            withCredentials([usernamePassword(credentialsId: 'dockerHubAccount', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
            pushToImage(CONTAINER_NAME, CONTAINER_TAG, USERNAME, PASSWORD)
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
            echo 'I succeeeded!'
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

def imagePrune(containerName){
    try {
        sh "docker image prune -f"
        sh "docker stop $containerName"
    } catch(error){}
}

def imageBuild(containerName, tag){
    sh "docker build -t $containerName:$tag  -t $containerName --pull --no-cache ."
    echo "Image build complete"
}

def pushToImage(containerName, tag, dockerUser, dockerPassword){
    sh "docker login -u $dockerUser -p $dockerPassword"
    sh "docker tag $containerName:$tag $dockerUser/$containerName:$tag"
    sh "docker push $dockerUser/$containerName:$tag"
    echo "Image push complete"
}

