#!/bin/bsh
set -x
TODATE=`date`
banner "check script' $TODATE "

export LANG=ko_KR.utf8

mkdir -p /tmp/ta-script/

########### 권한 bit로 확인 하는 Function ##############
PERM() {
stat -c "%a %A %U:%G %n" $LIST| awk '{print $1}'
}

######### 정 상 유무 결과 보여주는 Function ###################
OK() {
echo -e '\033[32m'"[ 설정이 이미 적용 되어 있습니다.] : $*"'\033[0m'
} >> $RESULT

WARN() {
echo -e '\033[31m'"[ 절정이 안되어 있어서  조치를 진행 합니다 ] : $*"'\033[0m'
} >> $RESULT

############ 시작 하는 배너 보여주는 Function ################
function S_Banner(){
cat << EOF
  ******************************************************************************
  *                                                                            *
  *                       CJONS ArchiTech Part 점검 스크립트 시작                  *
  *                                                                            *
  *                                                                            *
  *                                     - Order by ArchiTech Part TA Team -    *
  *                                                                            *
  ******************************************************************************

EOF
}
############# 종료를 알려주는 Function #####################
function E_Banner(){
cat << EOF
******************************************************************************
*                                                                            *
*                       CJONS ArchiTech Part 점검 스크립트 종료                   *
*                                                                            *
*                                                                            *
*                                      - Order by ArchiTech Part TA Team -   *
*                                                                            *
******************************************************************************
EOF
}

S_Banner

 echo "##################################################"
  echo "#####     RHEL Linux 8 : 1 입력           ########"
  echo "##################################################"
  echo " "
  echo " "
  echo -n " 서버 OS를 선택 하세요! :  "

####### OSV = OS version 변수 #########
 while read OSV
  do

  case $OSV in

  	1)
############# banner Function Call ###########################
   S_Banner

echo "####### 1)RHEL Linux 8 점검을 시작 합니다.        ############"
echo "####### 1)SU 그룹 제안 (while group) 설정 및 조치 ############"
echo " "
  WHEEL=`cat /etc/group |grep wheel |awk -F : '{print $1}'`

 #if [ "{$WHEEL}" -eq "wheel" ];
 if [ "$?" != "$WHEEL" ];
 		then
 		echo " ######## wheel 그룹 등록 계정을 입력하세요 ######### "

########  WGROUP = wheel 그룹에 등록할 값의 변수 ########
    echo " ##### 예시 : apache,jboss ( ,로 구분하여 띄어 쓰기 없이 기입) ######## "
 		read WGROUP
LINE=`grep -n "^wheel" /etc/group |awk -F ":" '{print $1}'`
	find /etc/group -exec -i "$LINE s/$/,$WGROUP/" {} \;
    echo "`cat /etc/group |grep wheel` 등록 완료 "
    WARN

###### SU 명령어 그룹권한 설정 및 Permission 4750 변경 #############

  echo ">>>>>>>>>>>>>>>> Permission 4750 으로 변경 합니다."
   chgrp wheel /usr/bin/su && chmod 4750 /usr/bin/su
   STAT=`stat -c "%a %A %U:%G %n"  /usr/bin/su |awk '{print $1}'`
   STAT1=`stat -c "%a %A %U:%G %n"  /usr/bin/su`
   if [ "${STAT}" -eq "4750" ];
   then
     echo -e ">>>>>>>> 권한 4750 변경 완료\n $STAT1 "
  else
     echo -e ">>>>>>>  권한이 변경되지 않았습니다. chmod 4750 명령어를 다시 실행해주세요 \n `$STAT1` "
fi

  else
     echo -e "####### Wheel 그룹이 없어 그룹 생성 그룹 등록을 합니다. ##########"
    	groupadd wheel

    echo "##### 예시  : root,apache,jboss ( ,로 구분하여 띄어 쓰기 없이 기입) ######## "
     		read WGROUP
	LINE=`grep -n "^wheel" /etc/group |awk -F ":" '{print $1}'`

	find /etc/group -exec sed -i "$LINE s/$/$WGROUP/" {} \;
    echo "`cat /etc/group |grep wheel` 등록 완료 "
    WARN
  fi
sleep 2

echo "################################################################"
echo " ######           불필요한 계정 No login 설정                  ####"
echo "################################################################"
USER() {
NUM=`grep -n -v -E "^$IN|root|nologin" /etc/passwd |sed -i "s/\$/\/sbin\/nologin/p" |awk -F ":" '{print $1}'`
}

echo '\033[31m'"       root 계정은 필수 적으로 입력 하세요.   $*"'\033[0m'
echo -e ">>> 띄어쓰기로 계정을 구분하여 입력하세요 ex) root apache tomcat : "
while IFS= read LIST1
do
        array=($LIST1)
        for IN in ${array[@]}
        do
USER
#find /etc/passwd -exec sed -i "$NUM s/$/\/sbin\/nologin/" {} \; > /dev/null 2>&1
WARN
done
exit
done
sleep 2

echo "################################################################"
echo "######                    Cron 권한 설정                     ####"
echo "################################################################"
FILE1="/etc/cron.allow"
FILE2="/etc/cron.deny"
TOUCH_FILE()
{
if [ -f ${CHK_FILE} ]
then
chown root ${CHK_FILE}
chmod 640 ${CHK_FILE}

fi
}
if [ ! -e $FILE1 ] && [ ! -e $FILE2 ];
then
  touch ${FILE1} ${FILE2}
  chown root ${FILE1}
  chown root ${FILE2}
  chmod 640 ${FILE1}
  chmod 640 ${FILE2}
else
  CRON=`find /etc -type f -name "cron.allow" -o -name "cron.deny"`
  for I in $CRON
  do
    CHK_FILE=${I}
    echo ${CHK_FILE}
    TOUCH_FILE
done
fi
sleep 2

echo "################################################################"
echo "######           user login security 정책 설정             #####"
echo "###############################################################"

FINDLINE() {
LINE=`cat /etc/login.defs |grep -n ^$PASS |awk -F ":" '{print $1}'`
result=${LINE}
}

FINDVALU() {
VALU=`cat /etc/login.defs |grep -v "^#" |grep $PASS |awk '{print $2}'`
result1=${VALU}
}

ASVALU() {
	cat /etc/login.defs |grep -v "^#" |grep $PASS
}

CHANG_VALU() {
	sed -i ""$result" s/"$result1"/"$PASS1"/" /etc/login.defs
}
echo -e '\033[31m'"[ 취약 -> 조치 ] : $*"'\033[0m'

MENU() {
echo -e "####################################################"
echo -e '####  \033[31m'"USER PASSWORD Security Policy Select NUM $*"'\033[0m #####'
echo -e "####################################################"
echo -e '####  \033[31m'"1) PASS_MAX_DAYS                         $*"'\033[0m #####'
echo -e '####  \033[31m'"2) PASS_MIN_DAYS                         $*"'\033[0m #####'
echo -e '####  \033[31m'"3) PASS_MIN_LNG                          $*"'\033[0m #####'
echo -e '####  \033[31m'"4) PASS_WARN_AGE                         $*"'\033[0m #####'
echo -e '####  \033[31m'"5) Exit Setting Security Policy          $*"'\033[0m #####'
echo -e '####################################################'
}

PS3='설정할 보안정책 설정 값을 선택 하세요: '
select PASS in "PASS_MAX_DAYS" "PASS_MIN_DAYS" "PASS_MIN_LNG" "PASS_WARN_AGE" "EXIT"
do
  if [ "$PASS" = "EXIT" ] ;
  then break
else
	echo "$PASS 를선택 하셨습니다."
  	echo "설정된 값은`ASVALU`입니다."
	 echo "$PASS 변경할 입력값을 입력 해주세요:  "
FINDLINE
FINDVALU
read PASS1
CHANG_VALU
   echo -e '\033[31m'"보안정책 설정값 $PASS = `PASS1` 변경 하였습니다. $*"'\033[0m'
  fi
done
sleep 2

echo -e "################################################################"
echo -e '####    \033[31m WARRING!!! change /etc/Pam.d/system-auth   \033[0m #####'
echo -e '###############################################################'

PAM-AUTH="/etc/pam.d/system-auth"
PAM-PASS="/etc/pam.d/password-auth"
if [ -e ${PAM-AUTH} ];
then
  cp -rp /etc/pam.d/system-auth /etc/pam.d/system-auth_orig
  echo " system-auth 원본 파일을 system-auth_orig 파일로 백업 하였습니다. "
  cat /dev/null > /etc/pam.d/system-auth

cat << EOF > /etc/pam.d/system-auth
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so
auth        required      pam_tally2.so deny=3 unlock_time=120 no_magic_root

account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so
account     required      pam_tally2.so reset

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    requisite     pam_cracklib.so retry=3 minlen=8 lcredit=-2 ucredit=-1 dcredit=-1 ocredit=-1
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so
password    sufficient    pam_unix.so md5 shadow nullok try_first_pass use_authtok remember=3

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF

   echo -e '\033[31m'"system-auth 파일의 설정값을 변경 하였습니다. $*"'\033[0m'
   cat /etc/pam.d/system-auth
else
  echo "해당 위치에 파일이 존재 하지 않습니다. OS 버전에 따라 다를 수도 있습니다."
  echo " OS 및 Version을 추가적으로 확인 해보요"
fi

echo "####################################################"
echo "####    \033[31m WARRING!!! changes Pam.d       \033[0m     #####"
echo "####################################################"
if [ -e ${PAM-PASS} ];
then
  cp -rp /etc/pam.d/password-auth /etc/pam.d/password-auth_orig
  echo " password-auth 원본 파일을 password-auth_orig 파일로 백업 하였습니다. "
  cat /dev/null > /etc/pam.d/password-auth
cat <<EOF > /etc/pam.d/password-auth
#%PAM-1.0
# This file is auto-generated.
# User changes will be destroyed the next time authconfig is run.
auth        required      pam_env.so
auth        sufficient    pam_unix.so nullok try_first_pass
auth        requisite     pam_succeed_if.so uid >= 1000 quiet_success
auth        required      pam_deny.so
auth        required      pam_tally2.so deny=3 unlock_time=120 no_magic_root

account     required      pam_unix.so
account     sufficient    pam_localuser.so
account     sufficient    pam_succeed_if.so uid < 1000 quiet
account     required      pam_permit.so
account     required      pam_tally2.so reset

password    requisite     pam_pwquality.so try_first_pass local_users_only retry=3 authtok_type=
password    sufficient    pam_unix.so sha512 shadow nullok try_first_pass use_authtok
password    required      pam_deny.so

session     optional      pam_keyinit.so revoke
session     required      pam_limits.so
-session     optional      pam_systemd.so
session     [success=1 default=ignore] pam_succeed_if.so service in crond quiet use_uid
session     required      pam_unix.so
EOF
sleep 2
else
  echo "해당 경로에 파일이 존재 하지 않습니다. 추가적인 확인이 필요 합니다."
  echo " OS 및 version을 확인하여 스크립트를 수정 해주시기 바랍니다."
fi
sleep 2
echo "####################################################"
echo "####                rlogin Disable             #####"
echo "####################################################"
RLOGIN=/etc/host.equiv
if [ -e ${RLOGIN} ];
then
  echo "/etc/hosts.equiv 파일이 존재 합니다. 권한만 변경합니다."
  chmod 000 /etc/hosts.equiv
else
  echo "/etc/hosts.equiv 파일이 없어 파일을 생성 및 권한 000 으로 변경합니다"
touch /etc/hosts.equiv
chmod 000 /etc/hosts.equiv
fi
sleep 2

echo "####################################################"
echo "####             ssh root login 변경            #####"
echo "####################################################"
echo " "
ROOTLOGIN() {
LINE=`cat /etc/ssh/sshd_config |grep -v "^#" |grep -n PermitRootLogin |awk -F : '{print $1}'`
result2=${LINE1}
}

PERMITVALU() {
VALU1=`cat /etc/ssh/sshd_config |grep -v "^#" |grep "PermitRootLogin" |awk '{print $2}'`
result3=${VALU1}
}

ASVALU1() {
        cat /etc/ssh/sshd_config |grep -v "^#" |grep "PermitRootLogin"
}

CHANG_PERMIT() {
        sed -i ""$result2" s/"$result3"/no/" /etc/ssh/sshd_config
}

echo "etc/ssh/sshd_config PermitRootLogin 주석 해제합니다."
sed -ri 's/^#(.*PermitRootLogin\s+.*no)/\1/' /etc/ssh/sshd_config
echo " "
echo "원격 root 로그인을 안되도록 Config 값을 NO로 변경합니다."

  if [ "${result3}" = "no" ] ;
  then
         echo "이미 PermitRootLogin = no 로 설정되어 있습니다."
          break
else
        echo "설정된 값은`ASVALU1`입니다."
ROOTLOGIN
PERMITVALU
        echo "PermitRootLogin 설정 값을 no로 변경합니다."
        CHANG_PERMIT
  fi
  sleep 2

echo " Cipher config 설정을 추가 합니다."
cat <<EOF >>/etc/ssh/sshd_config
# Cipher config
Ciphers aes128-ctr,aes192-ctr,aes256-ctr
EOF

echo "ssh 데몬을 재시작 합니다. 잠시만 기다려주세요 ....."
systemctl restart sshd
sleep 2
echo "####################################################"
echo "#      Profile 설정 진행(histsize,umask,TMOUT)     ###"
echo "####################################################"
echo " "
echo "HISTSIZE 값을 1000으로 변경합니다."
HIST=`cat /etc/profile |grep -i histsize= |awk -F = '{print $2}'`
cat /etc/profile |grep -i histsize= |sed -i "s/"$HIST"/1000/" /etc/profile
echo " "
echo "### /etc/profile의 마지막 라인에 UMASK=022 , TMOUT=600 초 설정을 합니다.########"
cat <<EOF >> /etc/profile
umask 022
export TMOUT=600
EOF
sleep 2
echo "####################################################"
echo "###            Login banner 설정을 합니다.           ###"
echo "####################################################"
echo " "
cat <<EOF > /etc/motd
######################### Warning ##########################
#                                                          #
# This system is restricted to authorized users only.      #
# All activities on this system are logged.                #
# Unauthorized access will be fully investigated           #
# and reported to the appropriate law enforcement agencies.#
#                                                          #
############################################################
EOF
sleep 2

echo "####################################################"
echo "###            setuid를 제거 합니다.                ###"
echo "####################################################"
echo " "

LIST="/sbin/dump /sbin/restore /usr/bin/lpq-lpd /usr/bin/newgrp /usr/bin/lpr /usr/bin/lpr-lpd /usr/bin/at /usr/bin/lprm /usr/bin/lpq /usr/bin/lprm-lpd /usr/sbin/lpc /usr/sbin/lpc-lpd /usr/sbin/traceroute /sbin/unix_chkpwd"
for SETID in `PERM`
  do
  if [ "4000" -le "${SETID}" ] ;
  then
echo "$SETID setuid 권한을 제거 합니다."
WARN
  fi
done
sleep 2
echo "####################################################"
echo "###            파일 소유자 권한을 변경합니다.             ###"
echo "####################################################"
unset LIST
LIST="/var/log/wtmp var/run/utmp /var/log/btmp /var/log/messages /var/log/pacct /var/log/lastlog /var/log/secure /var/log/audit/audit.log"
for LOGPERM in `PERM`
  do
  if [ "660" -le "${LOGPERM}" ] ;
  then
echo -e '\033[31m'"$LOGPERM $*"'\033[0m Other user의 read 권한을 삭제 합다'
WARN
  fi
done
sleep 2

echo "####################################################"
echo "###   /etc/hosts 파일의 권한을 644로 변경 합니다.      ###"
echo "####################################################"
HOSTS=$(stat -c %a /etc/host |awk '{print $1}')
if [ 644 -eq $HOSTS ];
then
  echo -e '\033[31m'"hosts 파일의 권한이 이미 644 입니다. $*"'\033[0m'
else
   chmod 644 /etc/hosts
     echo -e '\033[31m'"hosts 파일의 권한이 644로 변경했습니다. $*"'\033[0m'
fi
sleep 2

echo "##########################################################################"
echo "###   /etc/audit/pluins.d/syslog.conf의 active 값을 yes로 변경 합니다.      ###"
echo "##########################################################################"

sed -i -e "s/active = no/active = yes/g" /etc/audisp/plugins.d/syslog.conf
  echo -e '\033[31m'"active 값을 yes로 변경하였습니다. $*"'\033[0m'
sleep 2

echo "##########################################################################"
echo "###              syslog의 보관주기를 30으로 변경합니다.                       ###"
echo "##########################################################################"
ROTATE=`cat /etc/logrotate.conf |grep "^rotate"`
sed -i -e "s/$ROTATE/rotate 30/g" /etc/logrotate.conf
  echo -e '\033[31m'"rotate 값을 30으로 변경 하였습니다. $*"'\033[0m'
  systemctl restart logrotate
sleep 2

echo "####################################################"
echo "###   mount 명령어 권한을 750으로 변경합니다.           ###"
echo "####################################################"
HOSTS=$(stat -c %a /bin/mount |awk '{print $1}')
if [ 750 -eq $HOSTS ];
then
  echo -e '\033[31m'"mount 파일의 권한이 이미 750 입니다. $*"'\033[0m'
else
   chmod 750 /bin/mount
   echo -e '\033[31m'"mount 파일의 권한을 750으로 변경했습니다. $*"'\033[0m'
fi
sleep 2

echo "####################################################"
echo "###   mDNS Detection (Remote Network) 서비스 중지    ###"
echo "####################################################"
systemctl disable avahi-daemon.service
systemctl stop avahi-daemon.service
   echo -e '\033[31m'"mDNS Detection데몬을 중지 하였습니다. $*"'\033[0m'


E_Banner
  ;;

  2)
  echo "#######1)RHEL Linux 7 점검을 시작 합니다.  ############"
   echo " test 진행 중입니다."
   ;;

   *)
      echo " ###### Invalid Number  ######i"
   esac

   exit
   done
