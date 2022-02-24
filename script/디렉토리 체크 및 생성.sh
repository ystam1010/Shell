#!/usr/bin/ksh

PWD=/share/ddmd_img/ddmdmodule

MK_DIR()
{
ssh -T -p 2200 ddmddevwas <<EOT
If [! -d ${CHK_DIR} ];
Then
   mkdir -p ${CHK_DIR}

fi
exit
EOT 
}

for I in ‘find /share/ddmd_img_data/ddmdmodule -mmin -5 -type d’
do
CHK_DIR=${I}
echo ${CHK_DIR}
MK_DIR > /dev/null
done

for I in ‘find /share/ddmd_img_data/ddmdmodule -mmin -5 -type f’
do
	scp -p -P 2200 ${I} ddmddevwas:${I}
done
