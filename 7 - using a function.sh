#!/bin/bash

#using a function in bash. Execute the file using- bash filename.bash . No need to pass any value while executing.

#The function Showuptime() will show the uptime and time since last reboot in output. 
#We have used one variable to store the uptime value ($uptime) and another for last reboot time value ($since).

Showuptime(){
up=$(uptime -p | cut -c4- )
since=$(uptime -s)

#This is a EOF marker. EOF is used to print a number of lines instead of typing 'echo' for every line.
#There is a starting EOF and an ending EOF. Bash will print all the text in between.

cat << EOF

---------------------------------
This server has been up for ${up}

It has been running since ${since}
---------------------------------
EOF
}

#Here we have called the funtion.

Showuptime

