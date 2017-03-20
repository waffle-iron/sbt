FROM openjdk:8-jdk-alpine

RUN apk --no-cache add curl bash && \
  curl -s https://raw.githubusercontent.com/paulp/sbt-extras/master/sbt > /usr/local/bin/sbt && \
  chmod 0755 /usr/local/bin/sbt

ARG SBT_DIR
ARG SBT_BOOT
ARG IVY
ARG SBT_LAUNCH_DIR
ARG scalaVer=211
ENV SBT_DIR ${SBT_DIR:-/var/sbt/0.13.13}
ENV SBT_BOOT ${SBT_BOOT:-/var/sbt/boot}
ENV IVY ${IVY:-/var/ivy2}
ENV SBT_LAUNCH_DIR ${SBT_LAUNCH_DIR:-/var/sbt/launchers}

ADD .bashrc /root/.bashrc

RUN mkdir -p $HOME/project && \
  cd $HOME/project && \
  sbt -sbt-dir $SBT_DIR -sbt-boot $SBT_BOOT -ivy $IVY -sbt-launch-dir $SBT_LAUNCH_DIR -v -${scalaVer} -sbt-create about && \
  rm -rf $HOME/project
