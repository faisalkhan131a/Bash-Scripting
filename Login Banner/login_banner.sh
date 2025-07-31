#!/bin/bash


# color codes

bright_red="\e[1;31m"
bright_yellow="\e[1;33m"
bright_blue="\e[1;34m"
bright_green="\e[1;32m"
blue="\e[34m"
reset="\e[0m"


# function for colorizing data in output

color(){

# $clean_value  removes the '%' from HDD usage and stores the value. If we used an HDD usage value with '%' sign then we would get an error because 'bc' is used for purely arithmatic operations and does not recognize special characters like '%'

local value=$1
local clean_value=$(echo "$value" | tr -d '%')
local yellow_thresh=$2
local red_thresh=$3

# here the comparison happens. If the value is within a certain thresshold, the output is printed in a certain color. Thresholds for each color is given in the later part of the code.

if (($(echo "$clean_value >= $red_thresh" | bc -l) ));then
echo -e "${bright_red}${value}${reset}"

elif (($(echo "$clean_value >= $yellow_thresh" | bc -l) ));then
echo -e "${bright_yellow}${value}${reset}"

else
echo -e "${bright_green}${value}${reset}"

fi

}

# extracting the values from the system via command substitution. FYI, command substitution runs a command and stores its output in a variable.

cpu_stat=$(top -bn1 | grep "Cpu(s)")          # extracting the line we need from a 'static' top command output.
cpu_usage=$(echo "$cpu_stat" | awk -F ',' '{print $1}' | awk '{print $2}')            # extracting cpu usage from the line
wa_value=$(echo "$cpu_stat" | awk -F ',' '{print $5}' | awk '{print $1}')             # extracting wa value in the same process


uptime=$(uptime -p | awk '{print $2,$3,$4,$5,$6,$7,$8,$9}')       # extracting system uptime data 
hostname=$(hostname -I)      # extracting system ip
date=$(date | awk '{print $2,$3,$4,$5,$6}')       # extracting date
hdd=$(df -h | grep /$ | awk '{print $5}')      # extracting cpu usage for root as majority of the disk space is assigned to root (in this case).


read l1 l2 l3 <<< $(uptime | awk -F 'load average:' '{print $2}' | tr ',' ' ')       # extracting all 3 load average values and assigning them to 3 separate variables.


# here we are defining the red and yellow thresholds for the variables. The thresholds are specified in integers. The first value is for yellow threshold and the later one for red.

cpu_usage_1=$(color "$cpu_usage" 10 20)
wa_value_1=$(color "$wa_value" 4 8)
hdd_1=$(color "$hdd" 80 95)

l1_color=$(color "$l1" 3 6)
l2_color=$(color "$l2" 3 6)
l3_color=$(color "$l3" 3 6)


# login banner design for output

echo -e "${blue}########################################################### ${reset}"
echo -e "${blue}#  SYSTEM STATS OF $hostname $date ${reset}"     
echo -e "${blue}# ${reset}"           
echo -e "${blue}#  HDD USAGE OF ROOT: $hdd_1 ${reset}"                                           
echo -e "${blue}#  CPU USAGE: $cpu_usage_1 ${reset}"                          
echo -e "${blue}#  WA VALUE: $wa_value_1 ${reset}"                         
echo -e "${blue}#  LOAD AVG: ${l1_color}, ${l2_color}, ${l3_color} ${reset}"                            
echo -e "${blue}#  UPTIME: ${bright_blue}${uptime} ${reset}"
echo -e "${blue}# ${reset}"  
echo -e "${blue}########################################################### ${reset}"
