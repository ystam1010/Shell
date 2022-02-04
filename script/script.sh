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

echo "##################################################"
echo "#####      START select number : 1        ########"
echo "#####      STOP select number : 2         ########"
echo "##################################################"


echo " START & STOP NUM select? : "

while read NUM
do

case $NUM in
        1)
                cd $JPATH/ISCM013/bin
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
        cd $JPATH/ISCM013/bin
        sh $STOP

##### contaniner 명출력###########
OFFSET=`sed -n -e '/PORT_OFFSET/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
IOFFSET=`expr $OFFSET + 8081`
#echo $IOFFSET
SPORT=`netstat -lnt |grep $IOFFSET |wc -l`

##### contaniner 명출력###########
CTN=`sed -n -e '/SERVER_NAME/p'  ./env.sh | head -1 |awk -F "=" '{print $2}'`
PROC=`ps -ef |grep $CTN |grep -v grep |wc -l`

       STOP_PROC

        ;;


*)
   echo " ###### Invalid Number  ######i"
esac

exit
done
