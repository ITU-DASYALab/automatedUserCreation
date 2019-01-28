#!/bin/sh
read -p "Enter just the number of the users separated by 'space': example: 1 5 9 13 " input
for i in ${input[@]}
do
   echo ""
   echo "Creating user:"$i    # or do whatever with individual element of the array
   echo ""
done
