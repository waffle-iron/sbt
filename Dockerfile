FROM openjdk:8-jdk-alpine

RUN apk --no-cache add curl bash && \
  curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt && \
  chmod 0755 /usr/local/bin/sbt
