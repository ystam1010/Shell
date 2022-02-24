#!/sbin/ksh
set -x 
export today=`date`

export LANG=ko_KR.utf8
mkdir -p /tmp/ta-script/script_$today.log

  echo "##################################################"
  echo "#####     RHEL Linux 8 : 1 입력            ########"
  echo "#####     RHEL LINUX 7 : 2 입력            ########"
  echo "##################################################"
  echo " "
  echo " "
  echo " 서버 OS를 선택 하세요! : "

####### OSV = OS version 변수 #########
  read OSV
  do
  
  case $OSV in
  
  	1)
echo "#######1)SU 그룹 제안 (while group) 설정 ############"
echo " "
  WHEEL=`cat /etc/group |grep while |awk -F : '{print $1}'`
  
 if [ "$WHEEL" -eq "wheel" ];
 		then
 		echo " ######## wheel 그룹 등록 계정을 입력하세요 ######### "

########  WGROUP = wheel 그룹에 등록할 값의 변수 ########
    echo " ##### 예시 : apache,jboss ( ,로 구분하여 띄어 쓰기 없이 기입) ######## "
 		read WGROUP
 	 
 	  cat /etc/group |grep wheel |sed -e "s/\$/,$WGROUP/"
    echo "`cat /etc/group |grep while` 등록 완료 "

###### SU 명령어 그룹권한 설정 및 Permission 4750 변경 #############
   chgrp wheel /usr/bin/su && chmod 4750 /usr/bin/su && ll /usr/bin/su
       
  
  else
     echo "####### Wheel 그룹이 없어 그룹 생성 그룹 등록을 합니다. ##########"
  groupadd -g wheel
   echo " ##### 예시 : apache,jboss ( ,로 구분하여 띄어 쓰기 없이 기입) ######## "
 		read WGROUP
 	 
 	  cat /etc/group |grep wheel |sed -e "s/\$/,$WGROUP/"
    echo "`cat /etc/group |grep while` 등록 완료 "
 
  fi
  echo " "
  echo "#######  2)  ############"
   echo " "
  
