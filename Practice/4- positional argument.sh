#!/bin/bash

# position argument in bash

# $1 and $2 is our positional arguments and the value for those arguments will be passed while executing the bash file.
# run the file like this -> bash filename.sh Counter Strike 
# you can use any value instead of 'Counter Strike', just make sure it contains 2 words as we have declared 2 arguments
# here 'Counter' and 'Strike' is the value of the argument 1 and 2. Lastly we have thee cho statement to print this

echo This game is called $1 $2
