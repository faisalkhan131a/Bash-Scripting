Hello all, welcome back once again to Bash!

The script I am sharing today is slightly different than the previous scripts. Unlike the previous ones, this script was designed to automate some tasks of my current employer. So it is not something that you can just deploy or use directly. However, this script was written utilizing a lot of command line tools. It performs various types of operations including extracting output from MySQL database. The goal behind sharing this script is to show you the command line utilities I have used and to demonstrate the versitility of Bash. And in order to do that, let me describe the Environment for which this script was designed for and the Tasks this script can perform. Details are shared below.

# Environment 

This script was designed for CentOS 7 servers where some specific services are running. Let's assume the key services are called Appilcation 1 and Module 1. We will also work with MySQL 8 DBMS and Apache Tomcat web container used for Java based web applications. So the environment has the following entities-

1. OS- Linux CentOS 7
2. DBMS- MySQL 8
3. Web- Apache Tomcat
4. Services- Application 1
5. Services- Module 1

Our goal in this script is to extract some service-related information from the Application 1 and Module 1 directories as well as gather information about the utilization of server side resources by said Application and Module. The Tasks that are performed by the script can be found below.


# Tasks

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

## BLOCK 1 - Extracting Application and Module Info

This block goes to the target directory where the application folder is stored which in our case is /usr/local. Then it asks the user to select the folder where Application 1 is located. After that, the script automatically searches for a specific set of string starting with '-Xmx' inside a file called execute.sh or execute*.sh, whichever is found (the chances of finding both are 0% in our case). Then it removes everything apart from numerics and stores the final value inside $run variable. The purpose of this part is to extract how much memory is allocated to Application 1 and the amount of memory allocated is extracted from execute.sh or execute*.sh file and stored within the $run variable.

Next, the script again looks inside execute.sh or execute*.sh file for another specific string '/usr.*' (* means whatever comnes after) and if a match is found, then extracts the second and third non-empty lines upto 200 characters in length. Then it further filters the extracted lines by removing double backslashes '\\' and removing double spaces in between along with some additional tuning. Then it stores the end result inside $process_of_Application_1 variable. The purpose of this part is to use the string stored inside $process_of_Application_1 variable to track the process and extract it's usage of server resource using top and ps aux commands.

After that an if/else loop is used to determine how the content of $run variable will be processed. Based on the numeric length (in terms of digits), the content of the $run variable is processed and stored within $output variable. This is done to dertermine whether the allocated memory is in megabytes or in gigabytes.

Then, another if/else condition is implemented to determine from which file the database information will be extracted. The condition is based on matching string of Application 1 folder name. The name of the Application 1 folder is stored inside $application_1_folder variable. This is done due to Application 1 having different names for different versions and each version has slightly different database connection file name. The script requires to pinpoint the exact database connection file name to extract database info.


Then the script repeats the same process to extract information of Module 1. 

First, the user is prompted to select the Module 1 folder within /usr/local directory. After that, the script extracts information about allocated memory to Module 1 and stores the information within $run variable. To avoid confusion, please note the memory information of Application 1 was already processed and stored within $ouput variable. So we can safely overwrite whatever value is stored inside $run and replace it with the memory information of Module 1.

Next, the script again looks inside execute.sh or execute*.sh to gather matching strings that start with '/usr.*' (* means whatever comnes after) and collects upto 70 characters from the start of the string. Then it again performs some further filtering such as removing double backslashes and stores the end result within $process_of_Module_1 varible.

The next part sends the $run variable to an ef/else loop to process the amount of memory allocated to Module 1. The end result is stored within $output2.

Since the script already has database information from Application 1, it will not repeat the same process for Module 1. 

This concludes Tasks of Block 1.


## BLOCK 2 - Defining date and running the MySQL query

The purpose of this block is to define the current date in terms of year, month and day. After that it will a sql query inside the database (MySQL) to extract required data of last 7 days from a specific table. Then we will add the collected data and store it into a variable for printing later.

At first, the script uses $year, $month and $day variable to define year, month and day of today's date (as per server date).

Then the script uses a for loop to run a query 7 times for each of the last 7 days to extract data from database tables. The loop is run exactly for 7 times.

The $date_str variable is used to deduce the previous dates (already passed dates) in date format.

The $y, $m and $d variables splits the date of the current running iteration and stores the year, month and day value within them. Then the script moves to next segment.

Then, the sql query is executed and the output is stored within $count variable. The query itself is a MySQL select query with count() which checks a particular table for number of records with a particular condition (the where condition). Rest assured, this is a read operation and nothing is changed inside the table.

*About the query*
The expected query output is numbers (normal for a count statement). So to optimize the output further, the query is run in silent mode (-s) and hides any warning/error (2>/dev/null), and ensures output is a numeric value (grep -E '^[0-9]+$') and if no numeric output is found, considers the output to be 0 (|| echo 0) and stores the result inside $count variable. The query is run 7 times for 7 iterations and each iteration's output is stored within $count1,$count2,$count3 etc.

The next line of code generates $count variable i times to store the output of each iteration (here number of ierations is i).


In the end, output of all 7 iterations (all 7 $count variables) is added via arithmatic operation and the result is stored within the $last_week_usage variable.

This concules the task of Block-2.


# NEED TO ADD A FEW LINES REGARDING THE USE OF AI IN THIS SCRIPT AND HOW THEY HELPED ME


This is pretty much how the script works. Although I had to make minor changes to make the script cleaner and more readable, this is still a entry level banner. I have added comments in the bash file itself so that it is easier to understand. The script itself is stable but it can be optimized fruther. So any opinions or suggestion regarding optimization or enhancement is welcome. Don't hesitate to reach out to me if you feel so (linkedin would be recommended).

*My LinkedIn profile: linkedin.com/in/faisalkhan131*


**Note to reader :** 




