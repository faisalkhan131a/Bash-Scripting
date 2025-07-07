#!/bin/bash

# here, we are exploring the if else loop in bash. run this file like-> bash filename.sh user
# you can give any other value than 'user' and check the ouput and modify the script accordingly.


# in the first if block, we have a condition and what will happen if the condition is true.
# what does ${1,,} do? => ${1} passes the user input to the first argument $1 and ${1,,} converts the value of $1 to small letters. Like USER to user. This is just to simplify reading user inputs.

if [ ${1,,} = user ]; then
echo "Correct! This TEST directory belongs to the USER."

# now we have an else-if statement, also stating a condition and what will happen if condition is true.
elif [ ${1,,} = help ]; then
echo "No idea what you are doing? Yep, we have all been there :) "

# finally, we have an else statement which will execute if none of above conditions are met.
else 
echo "Looks like you are lost. Better look at the map then ;)"

#fi marks the end of the if else loop. fi is if but backwards ;)
fi
