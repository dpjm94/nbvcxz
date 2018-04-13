FROM hello-world
MAINTAINER Donal Maher <dpjm94@live.ie>
RUN sudo -y update && sudo -y install wget && sudo -y install tar

# Set Environment Variables
ENV JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.8.0_161.jdk/Contents/Home
ENV MAVEN_HOME /Users/donalmaher/apache-maven-3.5.2
ENV CATALINA_HOME /usr/tomcat


#Download and Install Tomcat : http://apache-mirror.rbc.ru/pub/apache/tomcat/
RUN wget http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-9/v9.0.0.M8/bin/apache-tomcat-9.0.0.M8.tar.gz && tar -xvf apache-tomcat-9.0.0.M8.tar.gz && rm apache-tomcat-9.0.0.M8.tar.gz && mv apache-tomcat* ${CATALINA_HOME}

WORKDIR /usr/tomcat

EXPOSE 8080
EXPOSE 8009



