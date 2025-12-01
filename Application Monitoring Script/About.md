Hello all, welcome back once again to Bash!

The script I am sharing today is slightly different than the previous scripts. Unlike the previous ones, this script was designed to automate some tasks of my current employer. So it is not something that you can just deploy or use directly. However, this script was written utilizing a lot of command line tools. It performs various types of operations including extracting output from MySQL database. The goal behind sharing this script is to show you the command line utilities I have used and to demonstrate the versitility of Bash. And in order to do that, let me describe the Environment for which this script was designed for and the Tasks this script can perform. Details are shared below.

## Environment 

This script was designed for CentOS 7 servers where some specific services are running. Let's assume the key services are called Appilcation 1 and Module 1. We will also work with MySQL 8 DBMS and Apache Tomcat web container used for Java based web applications. So the environment has the following entities-

1. OS- Linux CentOS 7
2. DBMS- MySQL 8
3. Web- Apache Tomcat
4. Services- Application 1
5. Services- Module 1

Our goal in this script is to extract some service-related information from the Application 1 and Module 1 directories as well as gather information about the utilization of server side resources by said Application and Module. The Tasks that are performed by the script can be found below.


## Tasks

As the name suggests this is a monitoring script which when executed, will print some necessary information about Application 1 and Module 1 and their usage of server side resources. It will also print some basic server side statistics which were captured at the moment of script execution. The tasks performed by the script is as follows-

1. Shows CPU usage at the moment of script execution
2. Shows Hrad Disk usage at the moment of script execution
3. Shows Free, Used and Total memory of the server.
4. Shows server uptime.
5. Shows Application 1 memory usage and process uptime (in days).
6. Shows Module 1 memory usage and process uptime (in days).
7. Shows Apache Tomcat web container memory usage and process uptime (in days).
8. Shows active MySQL processes and query processing time for our query.
9. Shows CPU usage of the MySQL process.
10. Runs MySQL queries and shows the result of the queries.


For the ease of understanding, I have divided the bash script into 4 Blocks and provided comments inside the script file to explain the purpose of the written code. Let me summarize the tasks of each Blocks down below.

# BLOCK 1 - Extracting Application and Module Info

This block goes to the target directory where the application folder is stored which in our case is /usr/local. Then it asks the user to select the folder for Application 1. After that, the script automatically searches for a specific set of string starting with '-Xmx' inside a file called execute.sh or execute*.sh, whichever is found (the chances of finding both are 0% in our case). Then it removes everything apart from numerics and then stores it inside $run variable.

Next, the script again looks inside execute.sh or execute*.sh file for another specific string '/usr.*' and if a match is found, then extracts the second and third non-empty lines upto 200 characters in length. Then it further filters the extracted lines by removing double backslashes '\\' and removing double spaces in between along with some additional tuning. Then it stores the end result iside $process_of_Application_1 variable.


This is pretty much how the script works. Although I had to make minor changes to make the script cleaner and more readable, this is still a entry level banner. I have added comments in the bash file itself so that it is easier to understand. The script itself is stable but it can be optimized fruther. So any opinions or suggestion regarding optimization or enhancement is welcome. Don't hesitate to reach out to me if you feel so (linkedin would be recommended).

*My LinkedIn profile: linkedin.com/in/faisalkhan131*


**Note to reader :** 




