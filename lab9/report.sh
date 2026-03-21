#!/bin/bash

LOCK_LOG_FILE= #Пусть до lock файла
LOG_FILE= #Путь до файла с логами
LAST_TIME=0
TOP_SIZE= 
SEND= #адрес почты куда отправлять отчет


#export $(cat /opt/report.conf)

exec 200> $LOCK_LOG_FILE

flock -n 200 || { echo "Скрипт уже запущен другим процессом. Завершение."; exit 1; }


rm /tmp/mail-report.txt

touch /tmp/mail-report.txt
N=$(wc $LOG_FILE | awk '{print $1}')

if [ $LAST_TIME -eq 0 ]; then
	echo "Top ip:" >> /tmp/mail-report.txt
	cat $LOG_FILE | awk '{print $1}' | sort | uniq -c | sort -nr | head -n $TOP_SIZE >> /tmp/mail-report.txt
	echo "Top url:" >> /tmp/mail-report.txt
	cat $LOG_FILE | awk '{print $7}' | grep / |sort | uniq -c | sort -nr | head -n $TOP_SIZE >> /tmp/mail-report.txt
	echo "Top error:" >> /tmp/mail-report.txt
	cat $LOG_FILE | grep error | sort | uniq -c | sort -r | head -n $TOP_SIZE >> /tmp/mail-report.txt
	echo "Top http code:" >> /tmp/mail-report.txt
	cat $LOG_FILE | awk '{print $9}' | grep -E '^[0-5]{3}$'| sort | uniq -c | sort -r | head -n $TOP_SIZE >> /tmp/mail-report.txt
else
	TAIL=$(( $N - $LAST_TIME))
	echo "Top ip:" >> /tmp/mail-report.txt
	tail -n $TAIL $LOG_FILE | awk '{print $1}'| sort | uniq -c | sort -r | head -n $TOP_SIZE >> /tmp/mail-report.txt
	echo "Top url:" >> /tmp/mail-report.txt
	tail -n $TAIL $LOG_FILE | awk '{print $7}' | grep / |sort | uniq -c | sort -nr | head -n $TOP_SIZE >> /tmp/mail-report.txt 
	echo "Top error :" >> /tmp/mail-report.txt
	tail -n $TAIL $LOG_FILE | grep error | sort | uniq -c | sort -r | head -n $TOP_SIZE >> /tmp/mail-report.txt 
	echo "Top http code:" >> /tmp/mail-report.txt
	tail -n $TAIL $LOG_FILE | awk '{print $9}' | grep -E '^[0-5]{3}$'| sort | uniq -c | sort -r | head -n $TOP_SIZE >> /tmp/mail-report.txt

	
fi


N1=$(cat ./report.sh | grep LAST_TIME | head -n 1 )


sed -i -e "s/$N1/LAST_TIME=$N/" "./report.sh"

cat /tmp/mail-report.txt | mail -s "Report from site" $SEND

