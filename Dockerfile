FROM hello-world
MAINTAINER Donal Maher <dpjm94@live.ie>
RUN sudo -y update && sudo -y install wget && sudo -y install tar

# Set Environment Variables
ENV JAVA_HOME /usr/java
ENV CATALINA_HOME /usr/tomcat

# Download and Install Java 8 : http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads- 2133151.html
RUN wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u92-b14/jdk-8u92-linux-x64.tar.gz" && tar -xvf jdk-8u92-linux-x64.tar.gz && rm jdk-8u92-linux-x64.tar.gz && mv jdk* ${JAVA_HOME}

#Download and Install Tomcat : http://apache-mirror.rbc.ru/pub/apache/tomcat/
RUN wget http://apache-mirror.rbc.ru/pub/apache/tomcat/tomcat-9/v9.0.0.M8/bin/apache-tomcat-9.0.0.M8.tar.gz && tar -xvf apache-tomcat-9.0.0.M8.tar.gz && rm apache-tomcat-9.0.0.M8.tar.gz && mv apache-tomcat* ${CATALINA_HOME}

WORKDIR /usr/tomcat

EXPOSE 8080
EXPOSE 8009



