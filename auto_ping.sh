#!/bin/sh

ping -c 1 0.0.0.0 >/dev/null #将0.0.0.0改为自己路由器的IP

ret=$?

if [ $ret -eq 0 ]; then

  echo 'AC Power OK !'

else

  sudo shutdown -h now
#  echo 'AC Power Error !'
fi
