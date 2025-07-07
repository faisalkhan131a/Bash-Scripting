#!/bin/bash

# if/else loop inside a function. 
# we need to pass an input while executing this file. The value will be stored in $1. 
#Execute the file like this- bash filename.sh user

Showname(){

# in this if/else loop, we compare the value of $1 with the value we are expecting.
# if the value of $1 is 'user' or 'USER', then we will print the echo statement and return 0 and end the loop.

if [ ${1,,} = user ]; then
echo Hello there $1
return 0

# if the value of $1 is something else other than 'user' or 'USER', then we will return 1 and end the loop.
else
return 1

fi
}

# calling the Showname() function and passing the user input to $1
Showname $1

# this is just another if/else loop added for fun. This will compare the exit status (return 1 or 0) of the previous if/else loop.
# '$?' this variable stores the exit code (1 or 0) of the last executed function. Basically this variable, we have the status of our previous if/else loop which we ran above.

if [ $? = 1  ]; then
echo "Somebody is lost eh?"

# fi is if in opposite. This means end of the loop. This loop does not have an else statement.
fi
