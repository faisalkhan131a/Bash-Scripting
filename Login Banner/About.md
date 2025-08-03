Hello all, welcome back to Bash!

The script that we are going to discuss today is a SSH login banner. The function of this script is to printout key System Information such as cpu usage, disk space usage, load average, uptime etc in the form of a login banner. The script is executed (actually sourced) when a user logs into a shell session via SSH. The goal of the script is to provide a glimpse of current System Resource usage and summary of server health. The bash file (.sh) is provided within this directory so that you can check the script yourself. Feel free to use this script or make any changes you deem necessary for your specific use case. Note that this script was written for use in systems running Linux OS only (CentOS, Ubuntu and others).


## How to use this script as login banner:

This script has been tested in **CentOS 7** and **Ubuntu 22.04 LTS** systems, so deploying this script in these systems will require no further modifications. However other distros such as Arch, Mint etc may require some additional changes as some command line tools may work/behave differently in those distros. Now back to the original question, to use this script as banner you simply need to save it in /etc/profile.d . When a user logs into a shell via SSH, all bash files within /etc/profile.d directory are sourced and run. So any script present in the /etc/profile.d directory will run in the current shell process. 

Steps:

copy the bash (.sh) file to /etc/profile.d
or
directly download the file to /etc/profile.d directory

You don't need to provide any other permission or make the file executable. Just open another shell or relogin and the banner will run just fine.


## How the script works:

This script is designed to extract certain command outputs and then display them in login banner. Before displaying, the command outputs are evaluated via an if-else loop and based on the margin, assigned one of the three colors- green, yellow and red. Red indicates that a certain module has crossed the critical margin, yellow indicating that module is close to a critical point and green indicating module stability for the time being. Summary explanation of the code structure is given below:


1. shebang -> #!bin/bash - tells OS to run this script using Bash.

2. Color codes -> These are ANSI color codes to colorize command ouputs. reset is used to restore terminal color to default.

3. color function -> The color() function is used to compare command ouputs. The if-else loop compares the output and colorizes it according to the threshold it falls under. Threshold for each variable/command output is mentioned in the later part of the code.

4. command substitution -> Command substitution is used to extract values from other command outputs. All of the system data is extracted using command substitution.

5. defining thresholds -> Then thresholds for the red and yellow were declared for all variables using command substitution.

6. banner output -> In the end, a display banner was designed using echo command to display the data in a predefined format.


This is pretty much how the script works. Although I had to make minor changes to make the script cleaner and more readable, this is still a entry level banner. I have added comments in the bash file itself so that it is easier to understand. The script itself is stable but it can be optimized fruther. So any opinions or suggestion regarding optimization or enhancement is welcome. Don't hesitate to reach out to me if you feel so (linkedin would be recommended).

*My LinkedIn profile: linkedin.com/in/faisalkhan131*


**Note to reader :** This script only prints Disk Usage, CPU Usage, WA value, Load Average and System Uptime. You can modify this script according to your need and add or replace the parameters that you need.



