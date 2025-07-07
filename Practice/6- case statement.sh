#!/bin/bash

#Here, we will explore how case statement works
#Case is same as if else, but more suitable for multiple choice/input based scenarios



#What does ${1,,} do -> ${1} passes the value to the first argument to $1 and ${1,,} converts the value of $1 to small letters. Like USER to user. This is just to simplify reading user inputs.
#First case condition. As we can see multiple strings and then the executable code block if condition matches. Multiple strings are separated by pipe ( | ).

case ${1,,} in
user | admin | root)
echo "Sup! This directory belongs to Faisal Khan aka Icehawk."
;;

#Second condition. Same as the first one.
help | what)
echo "Looks like you need a hand."
;;

#Third condition. But this time only one string.
lost)
echo "Come on, don't give up easily."
;;

#This block will be executed if value of the argument does not match any of the above conditions.
*)
echo "Looks like you gave up afterall. What a..."

#This defines the end of the case statement. esac is case written in backwards ;)
esac
