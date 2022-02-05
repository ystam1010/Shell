#!/bin/ksh
JPATH=/GCLOUD/JBOSS/domains
START=./start.sh
STOP=./stop.sh

  START_PROC()
{
   if [ "$SPORT" -ge "1" ] && [ "${PROC}" -ge "2" ];
        then
                echo ""
                echo ""
                echo ""
                echo "##################################################"
                echo "####        $CNT Service START Complat!!!    #####"
                echo "####     Process &  PORT= $IOFFSET LISTEN    #####"
                echo "##################################################"
                echo "`netstat -lnt |grep $IOFFSET`"
                echo "`ps -ef |grep $CTN |grep -v grep`"
                cd /GCLOUD/JBOSS
        else
                echo ""
                echo ""
                echo ""
                echo "##################################################"
                echo "######       $CNT Demon Start Faile        #######"
                echo "##################################################"
                cd /GCLOUD/JBOSS
   fi
}

  STOP_PROC()
{
       if [ "${SPORT}" -eq "0" ] && [ "${PROC}" -eq "0" ];
        then
                echo ""
                echo ""
                echo ""
                echo "##################################################"
                echo "####     $CTN Service STOP Complate!!!       #####"
                echo "####     Process &  PORT= $IOFFSET DWWN      #####"
                echo "##################################################"
                echo "`netstat -lnt |grep $IOFFSET`"
                echo "`ps -ef |grep $CTN |grep -v grep`"
                cd /GCLOUD/JBOSS
        else
                echo ""
                echo ""
                echo ""
                echo "##################################################"
                echo "######       $CNT Demon Start Faile        #######"
                echo "##################################################"
                cd /GCLOUD/JBOSS
   fi
}

SERVICE_SELECT()
{
  echo "##################################################"
  echo "#####     공통/동원 명령  : ICOM011          ########"
  echo "#####     기준 정보      : IMDM012          ########"
  echo "#####     공급망/통합관제 : ISCM013\          ########"
  echo "#####     창고 관리      : IWMS014          ########"
  echo "#####     운송 관리      : ITMS015          ########"
  echo "#####     리포팅 툴      : IRPT016          ########"
  echo "##################################################"
 echo " "
 echo " "
  echo " 시작할 서비스 명을 입력 하세요 : "

  while read SERVICE
  do
}

echo "##################################################"
echo "#####      START select number : 1        ########"
echo "#####      STOP select number : 2         ########"
echo "##################################################"


echo " START & STOP NUM select? : "

while read NUM
do

case $NUM in
        1)
#### Function Call
SERVICE_SELECT
                cd $JPATH/$SERVICE/bin
                sh $START
        sleep  2
##### contaniner 명출력###########
OFFSET=`sed -n -e '/PORT_OFFSET/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
IOFFSET=`expr $OFFSET + 8081`
echo $IOFFSET
SPORT=`netstat -lnt |grep $IOFFSET |wc -l`

##### contaniner 명출력###########
CTN=`sed -n -e '/SERVER_NAME/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
PROC=`ps -ef |grep $CTN |grep -v grep |wc -l`

       START_PROC

        ;;


        2)
#### Function Call
  SERVICE_SELECT
        cd $JPATH/$SERVICE/bin
        sh $STOP

##### contaniner PORT_OFFSET ###########
OFFSET=`sed -n -e '/PORT_OFFSET/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`

##### contaniner PORT_OFFSET + Default Service PORT 변수
IOFFSET=`expr $OFFSET + 8081`

### Service Port Count
SPORT=`netstat -lnt |grep $IOFFSET |wc -l`

##### contaniner Nanme Search 변수
CTN=`sed -n -e '/SERVER_NAME/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
PROC=`ps -ef |grep $CTN |grep -v grep |wc -l`

       STOP_PROC

        ;;


*)
   echo " ###### Invalid Number  ######i"
esac

exit
done
