#!/usr/bin/env bash
set -xe
~/bin/flix build
~/bin/flix build-jar
java -jar artifact/flix.jar $@
