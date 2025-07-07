#!/bin/bash

# function in bash. 
# execute the file using- bash filename.bash . No need to pass any value while executing for this file.

# function Showuptime() will show the uptime and time since last reboot in output. 
# we are storing the uptime value in $uptime and value of last reboot time in $since.

Showuptime(){
up=$(uptime -p | cut -c4- )
since=$(uptime -s)

# this is called an EOF marker. EOF is used to print  multiple lines instead of typing 'echo' for every line.
# there is a starting EOF and an ending EOF. Bash will print all the text in between.

cat << EOF

---------------------------------
This server has been up for ${up}

It has been running since ${since}
---------------------------------
EOF
}

# In the end, we have called the funtion for execution.

Showuptime

