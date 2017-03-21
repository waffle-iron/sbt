FROM openjdk:8-jdk-alpine

RUN mkdir -p /home/jenkins && \
  sed -i 's/\/root/\/home\/jenkins/g' /etc/passwd

RUN apk --no-cache add curl bash && \
  curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt && \
  chmod 0755 /usr/local/bin/sbt
  
ENV HOME=/home/jenkins

ARG scalaVer=211

USER root

RUN mkdir ~/project && \
  cd ~/project && \
  sbt -sbt-create -v -${scalaVer} about

VOLUME ["/home/jenkins/.sbt","/home/jenkins/.ivy2"]
