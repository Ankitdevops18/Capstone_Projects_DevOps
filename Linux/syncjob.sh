#!/bin/bash

find -L ./A > A_dir.txt
find -L ./B > B_dir.txt


#Comparing Directories 

#if [diff A_L1.txt == B_L1.txt]; then
#     echo "L1 level looks same for both directories"
#else
     



for files in awk '{print}' A_dir.txt
do
#   if ["d" in files]; then
   for file in awk '{print}' B_dir.txt
        do 
            if [$file == $files]; then
               echo "looks good"
   break      
            else
               l1=${cut -b 3 B_dir.txt}
               mkdir -p A/$l1
            fi
   done
 done

         
 
    
       
      

