Hello all, welcome back to Bash!

The script that we are going to discuss today is a SSH login banner. The function of this script is to printout key System Information such as cpu usage, disk space usage, load average, uptime etc in the form of a login banner. The script is executed (actually sourced) when a user logs into a shell session via SSH. The goal of the script is to provide a glimpse of current System Resource usage and summary of server health. The bash file (.sh) is provided within this directory so that you can check the script yourself. Feel free to use this script or make any changes you deem necessary for your specific use case. Note that this script was written for use in systems running Linux OS only (CentOS, Ubuntu and others).

## The script was tested on CentOS 7 and Ubuntu 22.04 LTS servers and was found to work as expected.  and make changes you deem necessary for your own usage. 

How to use this script as login banner:

This script has been tested in **CentOS 7** and **Ubuntu 22.04 LTS** systems, so deploying this script in these systems will require no further modifications. However other distros such as Arch, Mint etc may require some additional changes as some command line tools may work/behave differently in those distros. Now back to the original question, to use this script as banner you simply need to store it in /etc/profile.d . When a user logs into a shell via SSH, all bash files within /etc/profile.d are sourced and run. So any script present in the /etc/profile.d directory will run in the current shell process. 

## Please note that sourcing a bash file and executing a bash file is similar but not exactly same.

Steps:

copy the bash (.sh) file to /etc/profile.d
or
directly download the file to /etc/profile.d directory

You don't need to provide any other permission or make the file executable. Just open another shell or relogin and the banner will run just fine.


How the script works:

