FROM openjdk:8-jdk-alpine

ENV HOME=/home/jenkins

RUN mkdir -p $HOME && \
  sed -i "s|\/root|$HOME|g" /etc/passwd && \
  apk --no-cache add bash curl tree && \
  curl -Lsk https://dl.bintray.com/sbt/native-packages/sbt/0.13.13/sbt-0.13.13.tgz | tar -zxC /var

ENV PATH=/var/sbt-launcher-packaging-0.13.13/bin:$PATH

ADD global.sbt $HOME/.sbt/0.13/global.sbt

RUN mkdir ~/proj1 && cd ~/proj1 \
  && sbt about 2>&1 | tee /tmp/sbt.log & printf "\n\nWaiting for sbt to initialize\n" && sleep 1; tail -f /tmp/sbt.log | grep -qm 1 'Available Plugins' && printf "\n\nOK\n" \
  && rm -rf ~/proj1

VOLUME ["/home/jenkins/.sbt","/home/jenkins/.ivy2"]
WORKDIR $HOME
