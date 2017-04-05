FROM openjdk:8-jdk-alpine

ENV HOME=/home/jenkins

RUN mkdir -p $HOME && \
  sed -i "s|\/root|$HOME|g" /etc/passwd && \
  apk --no-cache add bash curl tree && \
  curl -Lsk https://dl.bintray.com/sbt/native-packages/sbt/0.13.13/sbt-0.13.13.tgz | tar -zxC /var

ENV PATH=/var/sbt-launcher-packaging-0.13.13/bin:$PATH

ADD global.sbt $HOME/.sbt/0.13/global.sbt

RUN mkdir ~/proj1 && cd $_ \
  && sbt about \
  && rm -rf ~/proj1

VOLUME ["$HOME/.sbt","$HOME/.ivy2"]
WORKDIR $HOME
