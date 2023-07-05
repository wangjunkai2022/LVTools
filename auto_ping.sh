#!/bin/sh

ping -c 1 10.211.55.29 >/dev/null #将192.168.5.1改为自己路由器的IP

ret=$?

if [ $ret -eq 0 ]; then

  echo 'AC Power OK !'

else

  sudo shutdown -h now
#  echo 'AC Power Error !'
fi
