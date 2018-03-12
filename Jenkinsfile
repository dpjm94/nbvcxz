node{
 //Mark the code checkout 'stage'...   
 stage 'Checkout'
 git url: 'https://github.com/dpjm94/nbvcxz.git'
    
 //Get a maven tool
 def mvnHome = tool 'm2'
    
 //Mark the code build 'stage'...
 stage 'Build'
 // Run the maven build
 sh "${mvnHome}/bin/mvn - Dmaven.test.failure.ignore clean package"
}
