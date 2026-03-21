#!/bin/bash


CLK_TCK=$(getconf CLK_TCK)


echo -e  "PID\tTTY\tSTAT\tTIME\tCOMMAND"


for i in $(ls /proc/ | sort -n)

do

    if [[ $i =~ ^[0-9]+$ ]]; then

        if [ -f /proc/$i/status ]; then

            PID=$i
            STAT_F=$(cat /proc/$i/stat)
            TTY_NR=$( echo $STAT_F | awk '{print $7}')

            if [[ $TTY_NR == 0 ]]; then
                TTY="?"
            else

            	MAJOR=$((TTY_NR >> 8))
            	MINOR=$((TTY_NR & 255 ))
            	sys_file="/sys/dev/char/$MAJOR:$MINOR/uevent"

            	if (( MAJOR >= 136 && MAJOR <= 143 )); then

            		TTY="pts/$MINOR"
            	elif [ -f "$sys_file" ]; then 

            		TTY=$(grep "DEVNAME=" $sys_file | cut -d'=' -f2)
            	else

            		TTY="?"
            	fi
	    fi

            STAT=$(cat /proc/$i/status | grep State | awk '{print $2}')    
            UPTIME=$(echo $STAT_F | awk '{print $14}')
            STIME=$(echo $STAT_F | awk '{print $15}')

            TOTAL_TICKS=$(( UTIME + STIME ))
            TOTAL_SEC=$(( TOTAL_TICKS / CLK_TCK ))

            SEC=$(( TOTAL_SEC % 60 ))
            MIN=$(( (TOTAL_SEC / 60) % 60 ))
            HOUR=$(( TOTAL_SEC / 3600 ))

            if (( HOUR > 0 )); then

            	TIME=$(printf "%02d:%02d:%02d" $HOUR $MIN $SEC)
            else

            	TIME=$(printf "%02d:%02d" $MIN $SEC)
            fi

            CMD=$(cat /proc/$i/cmdline | sed 's/\x00/ /g')

            if [[ $CMD == "" ]]; then

                COMMAND=$(cat /proc/$i/comm)
            else

                COMMAND=$CMD
            fi

            echo -e  "$PID\t$TTY\t$STAT\t$TIME\t$COMMAND"
        fi
    fi
done 
