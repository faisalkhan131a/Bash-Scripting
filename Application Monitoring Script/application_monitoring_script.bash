#!/bin/bash


# ----------------------------------------------- BLOCK 1 - Extracting Application and Module Info -----------------------------------------------------------

# selecting the application_1 folder to extract necessary info

cd /usr/local
ls -d --color=auto */
read -p "Select Application_1 folder from above list and press enter: " application_1_folder

cd /usr/local/$application_1_folder

# searching for a specific string in a certain file (execute.sh). If found, then stores the numeric digit(s) and omits others.

run=$(grep -o -- '-Xmx[^ ]*' execute*.sh | tr -cd '0-9')

# this also searches for a specific string in a certain file (execute.sh). If such file is found then it prints the second and third non-empty line. 
# inside those lines, it looks for specific string patterns and stores upto 200 characters inside the variable with some further filtering in the end.

process_of_Application_1=$(
    awk 'NF {count++; if (count==2) {line=$0; getline nextline; print line nextline; exit}}' execute*.sh \
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


# if-else condition is implemented to decide which file the script will search based on the name of application_1 folder.

if [[ "$application_1_folder" == Application_1_5* ]]; then
    dbName=$(awk -F'[/?]' '/DATABASE_URL/ {print $(NF-1)}' ConnectionFile.xml)
elif [[ "$application_1_folder" == Application_1_6* ]]; then
    dbName=$(awk -F'[/?]' '/DATABASE_URL/ {print $(NF-1)}' ConnectionFile_Processed.xml.xml)
else
    echo -e "\e[31mERROR!!! Folder name does not start with 'Application_1_5' or 'Application_1_6'. Could not extract Database info.\e[0m"
	echo "Proceeding with the rest of the script."
	sleep 2
    exit 1
fi

# selecting the additional module_1 folder to extract info

cd ../

echo
echo
ls -d --color=auto */
read -p "Select Module_1 folder from above list and press enter: " module_1_folder

cd /usr/local/$module_1_folder

# searching for a specific string in a certain file (execute.sh). If found, then stores the numeric digit(s) and omits others.

run=$(grep -o -- '-Xmx[^ ]*' execute*.sh | tr -cd '0-9')

# this also searches for a specific string in a certain file (execute.sh). If such file is found then it prints the second and third non-empty line. 
# inside those lines, it looks for specific string patterns and stores upto 70 characters inside the variable with some further filtering in the end.

process_of_Module_1=$(
    awk 'NF {count++; if (count==2) {line=$0; getline nextline; print line nextline; exit}}' execute*.sh \
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
    output2=${run:0:2}
elif [ ${#run} -eq 6 ]; then
    output2=${run:0:3}
else
    output2="$run"
fi



# ----------------------------------------------- BLOCK 2- Defining date and running the MySQL query -------------------------------------------------

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

    # the mysql query that will run via loop. this query is written to retrieve the number of records stored in particular tables.
    count=$(mysql "$dbName" -N -s -e "SELECT COUNT(*) AS totalDataCount FROM Data_Set_${y}_${m}_${d} WHERE prReferenceID=-1;" 2>/dev/null | grep -E '^[0-9]+$' || echo 0)

    # dynamically creating count1,count2,count3 etc variables to store count data of last 7 days
    eval "count$i=$count"
done

# sum of last 7 days data
last_week_usage=$((count1 + count2 + count3 + count4 + count5 + count6 + count7))



# ----------------------------------------------- BLOCK 3- Extracting server resource utilization info -------------------------------------------------

# extracting  memory usage data for different modules using top command

application_1_virt_mem=$(top -bn1 -c | grep "$process_of_Application_1" | grep -v grep | awk '{print $5}')
application_1_res_mem=$(top -bn1 -c | grep "$process_of_Application_1" | grep -v grep | awk '{print $6}')

module_1_virt_mem=$(top -bn1 -c | grep "$process_of_Module_1" | grep -v grep | awk '{print $5}')
module_1_res_mem=$(top -bn1 -c | grep "$process_of_Module_1" | grep -v grep | awk '{print $6}')

tomcat_virt_mem=$(top -bn1 -c | grep "[apa]che-tomcat-7.0.59" | grep -v grep | awk '{print $5}')
tomcat_res_mem=$(top -bn1 -c | grep "[apa]che-tomcat-7.0.59" | grep -v grep | awk '{print $6}')


# extracting cpu/memory usage and other data

server_cpu_usage=$(top -bn1 -c | grep "Cpu(s)" | awk -F ',' '{print $2}' | awk '{print $1}')
mysql_cpu_usage=$(top -bn1 -c | grep "[my]sqld" | awk '{print $9}')

total_cpu_cores=$(lscpu | grep -m1 "CPU(s):" | awk -F ':' '{print $2}')
memory1=$(free | grep "[M]em:" | awk '{print $2}')
memory2=$(free | grep "[M]em:" | awk '{print $3}')


# extracting process uptime info

application_1_pid=$(ps -eo pid,cmd | grep "$process_of_Application_1" | grep -v grep | awk '{print $1}')
module_1_pid=$(pgrep -f "$process_of_Module_1")
tomcat_pid=$(ps aux | grep "[apa]che-tomcat-7.0.59" | awk '{print $2}' )


now_epoch=$(date +%s)
start_epoch1=$(date -d "$(ps -o lstart= -p "$application_1_pid")" +%s)
total_days1=$(((now_epoch - start_epoch1) / 86400))

start_epoch2=$(date -d "$(ps -o lstart= -p "$module_1_pid")" +%s)
total_days2=$(((now_epoch - start_epoch2) / 86400))

start_epoch3=$(date -d "$(ps -o lstart= -p "$tomcat_pid")" +%s)
total_days3=$(((now_epoch - start_epoch3) / 86400))



# extracting additional server side information

mysql_processlist=$(mysql -s -e "SELECT COUNT(*) AS active_processes FROM information_schema.PROCESSLIST WHERE COMMAND != 'Sleep';" 2>/dev/null | grep -E '^[0-9]+$' || echo 0)
hdd_root=$(df -h | grep /$ | awk '{print $5}') 
memory3=$(free | grep "[M]em:" | awk '{print $4}')
server_uptime=$(uptime | awk '{print $3,$4}' | tr -d ',')

# extracting database query related info

start_time=$(date +%s.%N)
mysql -s -e "SELECT COUNT(*) FROM information_schema.PROCESSLIST WHERE COMMAND != 'Sleep';" >/dev/null 2>&1
end_time=$(date +%s.%N)

processing_time=$(awk -v start="$start_time" -v end="$end_time" 'BEGIN {printf "%.2f", end - start}')


states=$(mysql -s -e "SHOW PROCESSLIST;" | awk '{print $7}')

process_list_status="Okay"

# using for loop to detect 'Table Lock' in processlist output.
for state in $states; do
    if [[ "$state" == *"Table lock"* ]]; then
        process_list_status="Table lock found"
        break
    fi
done
 


# ------------------------------------------------- BLOCK 4 - Printing the collected info into the terminal ------------------------------------------------

# printing all the info in terminal using echo.

echo
echo
echo "CPU usage:" $server_cpu_usage "%" "("$total_cpu_cores "Core)"
echo "HDD usage:" $hdd_root
echo "Memory free:" $memory3
echo "Memory usage(total/used):" $memory1 / $memory2
echo "Server uptime:" $server_uptime
echo "Application 1 memory (Assigned memory- $output G):" $application_1_virt_mem / $application_1_res_mem , "Process uptime: "$total_days1 days
echo "Module 1 memory (Assigned memory- $output2 G):" $module_1_virt_mem / $module_1_res_mem , "Process uptime: "$total_days2 days
echo "Tomcat memory:" $tomcat_virt_mem / $tomcat_res_mem , "Process uptime: "$total_days3 days
echo "Mysql process status:" $mysql_processlist "active process"
echo "Show processlist: "$process_list_status
echo "Query processing time: "$processing_time "seconds"
echo "Mysql CPU usage:" $mysql_cpu_usage %
echo "Last 7 days data count:" $last_week_usage
echo
echo



# script version 3
# last updated 14 Dec 2025
