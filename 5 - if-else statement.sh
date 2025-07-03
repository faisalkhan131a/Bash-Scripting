#!/bin/bash

#Here, we are exploring the if else loop in bash
#Run this file like-> bash filename.sh user
#You can give any other value than 'user' and check the ouput and modify the script accordingly.


#in the first if block, we have a condition and what will happen if the condition is true.
#What does ${1,,} do -> ${1} passes the value to the first argument to $1 and ${1,,} converts the value of $1 to small letters. Like USER to user. This is just to simplify reading user inputs.

if [ ${1,,} = user ]; then
echo "Correct! This TEST directory belongs to the USER."

#Then we have an else if statement, also stating a condition and what will happen if condition is true.
elif [ ${1,,} = help ]; then
echo "No idea what you are doing? Yep, we have all been there :) "

#Finally, we have an else statement which will execute if none of above conditions are met.
else 
echo "Looks like you are lost. Better look at the map then ;)"

#fi marks the end of the if else loop.
fi
