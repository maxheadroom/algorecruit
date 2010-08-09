#!/bin/bash


export CLASSPATH=`echo lib/*jar | tr ' ' :`:.
export PATH=$PATH:/Users/fzurell/jruby-1.5.0.RC3/bin
echo "-J-Dcom.sun.management.jmxremote.port=9999 -J-Dcom.sun.management.jmxremote.authenticate=false -J-Dcom.sun.management.jmxremote.ssl=false "
