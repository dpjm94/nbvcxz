FROM anapsix/alpine-java

LABEL maintainer="dpjm94@live.ie"

COPY /target/nbvcxz-1.4.0.jar /target/nbvcxz-1.4.0-javadoc.jar

CMD ["java","-jar","/target/nbvcxz-1.4.0-javadoc.jar"]
