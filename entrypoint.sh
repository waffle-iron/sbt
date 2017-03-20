#!/bin/bash

mv /tmp/.sbt ~/
mv /tmp/.ivy2 ~/

exec "$@"
