FROM openjdk:8-jdk-alpine

ENV HOME=/home/jenkins

RUN apk --no-cache add curl bash && \
  curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt && \
  chmod 0755 /usr/local/bin/sbt
  
RUN mkdir -p /home/jenkins

ARG scalaVer=211

RUN mkdir ~/project && \
  cd ~/project && \
  sbt -sbt-create -v -${scalaVer} about && \
  mv ~/.sbt /tmp && \
  mv ~/.ivy2 /tmp

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
