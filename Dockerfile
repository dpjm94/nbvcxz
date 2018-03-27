FROM maven:3-alpine

LABEL maintainer="dpjm94@live.ie"

COPY /target/nbvcxz-1.4.0.jar

CMD ["java","-jar","/target/nbvcxz-1.4.0-javadoc.jar"]
