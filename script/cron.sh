#!/bin/bash

TOUCH_FILE()
{
if [ -f ${CHK_FILE} ]
then
chown root ${CHK_FILE}
chmod 640 ${CHK_FILE}

fi
}



FILE1="/etc/cron.allowd"
FILE2="/etc/cron.deny"

if [ ! -e $FILE] && [ ! -e $FILE ];then
  touch ${FILE1} ${FILE2}
  chown root ${FILE1}
  chown root ${FILE2}
  chmod 640 ${FILE1}
  chmod 640 ${FILE2}
else
  CRON=`find -type f -name "cron.allow" -o -name "cron.deny"`
  for I in `$CRON`
  do
    CHK_FILE=${I}
    echo ${CHK_FILE}
    TOUCH_FILE > /dev/null
done
