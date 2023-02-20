#!/bin/ksh
set -x
TODATE=`date`
mkdir -p /tmp/ta-script
CREATE_FILE=`hostname`"_linux_"`date +%m%d`.txt
RESULT=/tmp/ta-script/result_$TODATE.log
LOG=/tmp/ta-script/check_$TODATE.log

> /tmp/$CREATE_FILE
> $RESULT
> $LOG

BAR() {
echo "========================================================================" >> $RESULT
}

PSSWD_PERM() {
stat -c "%a %A %U:%G %n" /etc/passwd| awk '{print $1}'
}

OK() {
echo -e '\033[32m'"[ 양호 ] : $*"'\033[0m'
} >> $RESULT

WARN() {
echo -e '\033[31m'"[ 취약 -> 조치 ] : $*"'\033[0m'
} >> $RESULT



function S_Banner(){
cat << EOF
  ******************************************************************************
  *                                                                            *
  *                       CJONS 아키텍처팀 점검 스크립트 시작                         *
  *                                                                            *
  *                                                                            *
  *                                        - Order by Architecture TA Team-    *
  *                                                                            *
  ******************************************************************************

EOF
}

function E_Banner(){
cat << EOF
******************************************************************************
*                                                                            *
*                       CJONS 아키텍처팀 점검 스크립트 종료                         *
*                                                                            *
*                                                                            *
*                                        - Order by Architecture TA Team-    *
*                                                                            *
******************************************************************************

EOF
}


CUT_LINE() {
echo "========================================================================" >> $RESULT
}

TOUCH_FILE()
{
if [ -f ${CHK_FILE} ]
then
chown root ${CHK_FILE}
chmod 640 ${CHK_FILE}

fi
}


FindPatternReturnValue() {
# $1 : File name
# $2 : Find Pattern
if grep -E -v '^#|^$' $1 | grep -q $2 ; then # -q = 출력 내용 없도록
	ReturnValue=$(grep -E -v '^#|^$' $1 | grep $2 | awk -F= '{print $2}')
else
	ReturnValue=None
fi
echo $ReturnValue
}

IsFindPattern() {
if grep -E -v '^#|^$' $1 | grep -q $2 ; then # 라인의 처음이#, 라인의 처음이 마지막으로 되어있는
	ReturnValue=$?
else
	ReturnValue=$?
fi
echo $ReturnValue
}
