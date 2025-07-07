#!/bin/bash
# taking user input
# 'game' and 'time' are variables. read is used to take input from user and store the input into the 'game' and 'time' variables.

echo What game are you playing?
read game
echo Nice! We can play together, when do you usually play?
read time

# when using variables in echo or any kind of print type statement, give a '$' before variable name.
echo So you play $game huh. I will knock you around $time and we can play together then!
