#!/bin/bash

# selecting the main application folder to extract necessary info

cd /usr/local
ls -d --color=auto */
read -p "Select Switch folder: " switch_folder

cd /usr/local/$switch_folder

# searching for a specific string in a certain file. If found, then stores the numeric digit(s) and omits others.

run=$(grep -o -- '-Xmx[^ ]*' run*.sh | tr -cd '0-9')

# this also searches for a specific string in a certain file. If such file is found then it prints the second and third non-empty line. 
# inside those lines, it looks for specific string patterns and stores upto 70 characters inside the variable.

process_SMS_Server=$(
    awk 'NF {count++; if (count==2) {line=$0; getline nextline; print line nextline; exit}}' run*.sh \
    | sed -n 's|.*\(/usr.*\)|\1|p' \
    | head -c200 \
    | tr -d '\\' \
    | awk 'NF' \
    | tr '\t' ' ' \
    | tr -s ' ' \
    | sed 's/[[:space:]]*$//' 
)



# if/else loop is being used to determine how the value will be stored inside the output variable.

if [ ${#run} -eq 3 ]; then
	output=$(awk "BEGIN {printf \"%.1f\", $run/1000}")
elif [ ${#run} -eq 4 ]; then
    output=${run:0:1}
elif [ ${#run} -eq 5 ]; then
    output=${run:0:2}
elif [ ${#run} -eq 6 ]; then
    output=${run:0:3}
else
    output="$run"
fi


# if-else condition is implemented to decide which file the script will search based on the value of switch_folder variable.

if [[ "$switch_folder" == WholeSale* ]]; then
    dbName=$(awk -F'[/?]' '/DATABASE_URL/ {print $(NF-1)}' DatabaseConnection.xml)
elif [[ "$switch_folder" == SMS* ]]; then
    dbName=$(awk -F'[/?]' '/DATABASE_URL/ {print $(NF-1)}' DatabaseConnection_Successful.xml)
else
    echo "Folder name does not start with 'WholeSale' or 'SMS'. Could not extract Dataabase name."
    exit 1
fi

# selecting the additional module folder to extract info

cd ../

echo
echo
ls -d --color=auto */
read -p "Select App Server folder: " appServer_folder

cd /usr/local/$appServer_folder

# searching for a specific string in a certain file. If found, then stores the numeric digit(s) and omits others.

run=$(grep -o -- '-Xmx[^ ]*' run*.sh | tr -cd '0-9')

# this also searches for a specific string in a certain file. If such file is found then it prints the second and third non-empty line. 
# inside those lines, it looks for specific string patterns and stores upto 70 characters inside the variable.

process_Appserver=$(
    awk 'NF {count++; if (count==2) {line=$0; getline nextline; print line nextline; exit}}' run*.sh \
    | sed -n 's|.*\(/usr.*\)|\1|p' \
    | head -c70 \
    | tr -d '\\' \
    | awk 'NF'     
)


# if/else loop is being used to determine how the value will be stored inside the output variable.

if [ ${#run} -eq 3 ]; then
	output2=$(awk "BEGIN {printf \"%.1f\", $run/1000}")
elif [ ${#run} -eq 4 ]; then
    output2=${run:0:1}
elif [ ${#run} -eq 5 ]; then
    output=${run:0:2}
elif [ ${#run} -eq 6 ]; then
    output2=${run:0:3}
else
    output2="$run"
fi



# defining necessary variables for date info

year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)


# extracting the data of last 7 days from today using a for loop
for i in {1..7}; do
    # starting calculation from i days ago where i++
    date_str=$(date -d "$year-$month-$day -$i day" +%Y_%m_%d)

    # year, month and day info
    y=$(echo "$date_str" | cut -d_ -f1)
    m=$(echo "$date_str" | cut -d_ -f2)
    d=$(echo "$date_str" | cut -d_ -f3)

    # the mysql query that will run via loop
    count=$(mysql "$dbName" -N -s -e "SELECT COUNT(*) AS totalSMSCount FROM vbSMSHistory_${y}_${m}_${d} WHERE shParentReferenceID=-1;" 2>/dev/null | grep -E '^[0-9]+$' || echo 0)

    # dynamically creating count1,count2,count3 etc variables to store data of last 7 days
    eval "count$i=$count"
done

# sum of last 7 days data
last_week_usage=$((count1 + count2 + count3 + count4 + count5 + count6 + count7))



# extracting  memory data for different modules using top command

sms_server1=$(top -bn1 -c | grep "$process_SMS_Server" | grep -v grep | awk '{print $5}')
sms_server2=$(top -bn1 -c | grep "$process_SMS_Server" | grep -v grep | awk '{print $6}')

app_server1=$(top -bn1 -c | grep "$process_Appserver" | grep -v grep | awk '{print $5}')
app_server2=$(top -bn1 -c | grep "$process_Appserver" | grep -v grep | awk '{print $6}')

tomcat_7_1=$(top -bn1 -c | grep "[apa]che-tomcat-7.0.59" | grep -v grep | awk '{print $5}')
tomcat_7_2=$(top -bn1 -c | grep "[apa]che-tomcat-7.0.59" | grep -v grep | awk '{print $6}')


# extracting cpu/memory usage and other data

cpu_usage=$(top -bn1 -c | grep "Cpu(s)" | awk -F ',' '{print $2}' | awk '{print $1}')
mysql_cpu=$(top -bn1 -c | grep "[my]sqld" | awk '{print $9}')

cpu_cores=$(lscpu | grep -m1 "CPU(s):" | awk -F ':' '{print $2}')
memory1=$(free | grep "[M]em:" | awk '{print $2}')
memory2=$(free | grep "[M]em:" | awk '{print $3}')
uptime=$(uptime | awk '{print $3, $4}' | tr -d ',')


# extracting process uptime

sms_server_pid=$(ps -eo pid,cmd | grep "$process_SMS_Server" | grep -v grep | awk '{print $1}')
app_server_pid=$(pgrep -f "$process_Appserver")
tomcat7_pid=$(ps aux | grep "[apa]che-tomcat-7.0.59" | awk '{print $2}' )


now_epoch=$(date +%s)
start_epoch1=$(date -d "$(ps -o lstart= -p "$sms_server_pid")" +%s)
total_days1=$(((now_epoch - start_epoch1) / 86400))

start_epoch2=$(date -d "$(ps -o lstart= -p "$app_server_pid")" +%s)
total_days2=$(((now_epoch - start_epoch2) / 86400))

start_epoch3=$(date -d "$(ps -o lstart= -p "$tomcat7_pid")" +%s)
total_days3=$(((now_epoch - start_epoch3) / 86400))



# extracting additional server side information

mysql_processlist=$(mysql -s -e "SELECT COUNT(*) AS active_processes FROM information_schema.PROCESSLIST WHERE COMMAND != 'Sleep';" 2>/dev/null | grep -E '^[0-9]+$' || echo 0)
hdd_root=$(df -h | grep /$ | awk '{print $5}') 
memory3=$(free | grep "[M]em:" | awk '{print $4}')
uptime=$(uptime | awk '{print $3,$4}' | tr -d ',')

# extracting database query related info

start_time=$(date +%s.%N)
mysql -s -e "SELECT COUNT(*) FROM information_schema.PROCESSLIST WHERE COMMAND != 'Sleep';" >/dev/null 2>&1
end_time=$(date +%s.%N)

processing_time=$(awk -v start="$start_time" -v end="$end_time" 'BEGIN {printf "%.2f", end - start}')


states=$(mysql -s -e "SHOW PROCESSLIST;" | awk '{print $7}')

process_list_status="Okay"

# for loop to detect 'Table Lock' in processlist output.
for state in $states; do
    if [[ "$state" == *"Table lock"* ]]; then
        process_list_status="Table lock found"
        break
    fi
done
 

# finally printing data in a copyable format in terminal.

echo
echo
echo "CPU usage:" $cpu_usage "%" "("$cpu_cores "Core)"
echo "HDD usage:" $hdd_root
echo "Memory free:" $memory3
echo "Memory usage(total/used):" $memory1 / $memory2
echo "Server uptime:" $uptime
echo "SMS server memory ($output G):" $sms_server1 / $sms_server2 , "Uptime: "$total_days1 days
echo "App server memory ($output2 G):" $app_server1 / $app_server2 , "Uptime: "$total_days2 days
echo "Tomcat memory:" $tomcat_7_1 / $tomcat_7_2 , "Uptime: "$total_days3 days
echo "Mysql process status:" $mysql_processlist "active process"
echo "Show processlist: "$process_list_status
echo "Query processing time: "$processing_time "secs"
echo "Mysql CPU usage:" $mysql_cpu %
echo "Last 7 days SMS count:" $last_week_usage
echo
echo



# script version 3
# last updated 30 Nov 2025
