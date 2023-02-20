
==================== 리스트 저장 후 변경 스크립트==================================
#!/bin/bash
set -x -e
USER() {
NUM=`grep -n -E "^$IN" /etc/passwd |sed -n "s/\$/\/sbin\/nologin/p" |awk -F ":" '{print $1}'`
}

while read IN
        do
        USER
      find /etc/passwd -exec sed -i "$NUM s/$/\/sbin\/nologin/" {} \; > /dev/null 2>&1
done < /tmp/nologin.list


==================== 직접 입력 스크립트 =============================

#!/bin/bash
set -x  -e
USER() {
NUM=`grep -n -E "^$IN" /etc/passwd |sed -n "s/\$/\/sbin\/nologin/p" |awk -F ":" '{print $1}'`
}

echo -e ">>>>>>> 계정을 입력하세요"
while IFS= read LIST
do
        array=($LIST)
        for IN in ${array[@]}
        do
USER
find /etc/passwd -exec sed -i "$NUM s/$/\/sbin\/nologin/" {} \; > /dev/null 2>&1
done
exit
done
