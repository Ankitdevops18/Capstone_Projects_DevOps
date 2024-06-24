#!/bin/bash

read number

result=$(($number%2))

if [ ${result} -eq 0 ]; then
  echo "The number is even"

else 
  echo "The number is odd"

fi
 
