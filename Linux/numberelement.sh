#!/bin/bash

sum=0
num_items=0

read -a arr

for elem in ${arr[@]}
do 
  echo $elem
  if  [[ $elem == *[[:digit:]]* ]] 
  then
       sum=expr '$sum + $elem'
       num_items=expr '$num_items + 1'
       echo "The element is a digit : $elem" 
       
  else 
    echo "The element is an alphabet :  $elem" 

  fi

done

if [$num_items>10];
then
	echo "The number of valid items are greater than 10 so their sum is equal to  $sum"
else
	echo "The number of valid items are less than 10"
fi
