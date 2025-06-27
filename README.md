# Bash-Scripting
Entry to mid level Bash Scripting. Lets utilize the power of Bash and see how far we can get ;)

This repository contains entry to mid level Bash Scripting. I will share the script files (with .sh extension) here so that you can just run it in your system or server if you want to. We will start with basics and small chunks of code and gruadually move towards bigger tasks where we combine what we have seen before to achieve our desired goal. I have tried to include comments (starts with #) inside code blocks in the files so that you can understand what variable, function or method is used for what purpose. It is not all properly done, but I am working on it as we speak. 


**IMPORTANT: Note that most of these files do not contain rm commands (linux equivalent of shift + delete) inside them so you are good to run them at any given directory. However, it is still recommended that you oopen or read the file via cat or vi or any text editor before executing.


Thank you if you have taken your time to read this readme file. Happy Scripting!



--------------------------------------------------------------------------------------------------------------------------------------------------------------------

COMMON QUESTIONS and ANSWERS REGARDING BASH

--------------------------------------------------------------------------------------------------------------------------------------------------------------------


1. WHAT IS '#!/bin/bash' AT THE START OF EVERY FILE?-----------------------------------------------------------------------------------------------------------

You may have noticed, all or most the bash files start with this line in the start- '#!/bin/bash'. This line is known as 'Shebang' and it explicitly tells the system which shell to use to run this file, in our case that is the Bash shell located at /bin/bash direcotry in the linux system. If you don't use this line, then the file will still be executed but by the default interpreter set for the system, which can depend on your system/server configration.


2. HOW TO RUN OR EXECUTE A BASH SCRIPT FILE?-----------------------------------------------------------------------------------------------------------------

Another common query is how to run a bash file in a Linux system. There 3 commonly used ways to run a bash script file. They are as follows:

1. ./bash_file.sh -> For this you need to make your bash file executable first. Use the chmod u+x bash_file.sh command to make the bash file executable. In that case, make sure you are the file owner or at least you have root privilege. In this method, the system checks the Shebang line (#!/bin/bash) and executes the file accordingly. Example as follows:

vi filename.sh (write anything)
chmod u+x filename.sh 
./filename.sh


2. bash bash_file.sh -> Here, you are explicitly telling the system to run this file using Bash. It is simple and efficient for testing because you don't have to give execution permission every time you try to run a new file. In this case, even if you include Shebang, system will ignore that because you have already mentioned Bash in the command. Example:

vi filename.sh (write anything)
bash filename.sh


3. sh bash_file.sh : Here, you are telling the system to run this file using sh interpreter. This means this will also ignore the Shebang line and run the file using sh interpreter which is located at /bin/sh directory. Example:


vi filename.sh (write anything)
sh filename.sh




-----------------------------------------------------------The End, Updated on 27-06-2025 ---------------------------------------------------------------------
