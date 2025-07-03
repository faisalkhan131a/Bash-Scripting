
--------------------------------------------------------------------------------------------------------------------------------------------------------------------

FREQUENTLY ASKED BEGINNER QUESTIONS and ANSWERS regarding Bash

--------------------------------------------------------------------------------------------------------------------------------------------------------------------




1. WHAT IS '#!/bin/bash' AT THE START OF EVERY FILE?-----------------------------------------------------------------------------------------------------------




>> You may have noticed, all or most the bash files start with this line in the start- '#!/bin/bash'. This line is known as 'Shebang' and it explicitly tells the system which shell to use to run this file, in our case that is the Bash shell located at /bin/bash direcotry in the linux system. If you don't use this line, then the file will still be executed but by the default interpreter set for the system, which can depend on your system/server configration.








2. HOW TO RUN OR EXECUTE A BASH SCRIPT FILE?-----------------------------------------------------------------------------------------------------------------





>> Another common query is how to run a bash file in a Linux system. There 3 commonly used ways to run a bash script file. They are as follows:





(i) ./bash_file.sh -> For this you need to make your bash file executable first. Use the chmod u+x bash_file.sh command to make the bash file executable. In that case, make sure you are the file owner or at least you have root privilege. In this method, the system checks the Shebang line (#!/bin/bash) and executes the file accordingly. Example as follows:





vi filename.sh (write anything)


chmod u+x filename.sh 


./filename.sh








(ii) bash bash_file.sh -> Here, you are explicitly telling the system to run this file using Bash. It is simple and efficient for testing because you don't have to give execution permission every time you try to run a new file. In this case, even if you include Shebang, system will ignore that because you have already mentioned Bash in the command. Example:





vi filename.sh (write anything)


bash filename.sh








(iii) sh bash_file.sh : Here, you are telling the system to run this file using sh interpreter. This means this will also ignore the Shebang line and run the file using sh interpreter which is located at /bin/sh directory. Example:








vi filename.sh (write anything)


sh filename.sh














----------------------------------------------------------- The End, Updated on 03-07-2025 ---------------------------------------------------------------------