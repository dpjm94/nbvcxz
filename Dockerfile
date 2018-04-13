FROM hello-world
MAINTAINER Donal Maher <dpjm94@live.ie>
RUN sudo -y update && sudo -y install wget && sudo -y install tar

ARG some_variable_name
# or with a default:
#ARG some_variable_name=default_value

RUN echo "Oh dang look at that $some_variable_name"
# or with ${some_variable_name}



