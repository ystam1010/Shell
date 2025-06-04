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
  echo "#####     ����/���� ����  : ICOM011          ########"
  echo "#####     ���� ����      : IMDM012          ########"
  echo "#####     ���޸�/���հ��� : ISCM013           ########"
  echo "#####     â�� ����      : IWMS014          ########"
  echo "#####     ���� ����      : ITMS015          ########"
  echo "#####     ������ ��      : IRPT016          ########"
  echo "##################################################"
 echo " "
 echo " "
  echo " ������ ������ ���� �Է� �ϼ��� : "

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
#####  JBOSS  ȯ�� ���� ���Ͽ��� PORT_OFSET ���ڿ� ���ڿ� ���� ���� ����
OFFSET=`sed -n -e '/PORT_OFFSET/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
IOFFSET=`expr $OFFSET + 8081`
echo $IOFFSET
SPORT=`netstat -lnt |grep $IOFFSET |wc -l`

##### contaniner ������###########
CTN=`sed -n -e '/SERVER_NAME/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
PROC=`ps -ef |grep $CTN |grep -v grep |wc -l`

########## Function Call
       START_PROC

        ;;


        2)
######### Function Call
  SERVICE_SELECT

        cd $JPATH/$SERVICE/bin
        sh $STOP

#####  JBOSS  ȯ�� ���� ���Ͽ��� PORT_OFSET ���ڿ� ���ڿ� ���� ���� ����
OFFSET=`sed -n -e '/PORT_OFFSET/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`

##### contaniner PORT_OFFSET + Default Service PORT ����  ����
IOFFSET=`expr $OFFSET + 8081`

### Service Port Count
SPORT=`netstat -lnt |grep $IOFFSET |wc -l`

##### contaniner Nanme Search ����
CTN=`sed -n -e '/SERVER_NAME/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
PROC=`ps -ef |grep $CTN |grep -v grep |wc -l`

#### Function Call
       STOP_PROC

        ;;


*)
   echo " ###### Invalid Number  ######i"
esac

exit
done
