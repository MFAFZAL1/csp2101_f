#!/bin/bash
var1=$((RANDOM % 70))   #generating random values 
while :
do
echo " Enter age: "       #printing guess age
read var2                    #read input value by the user
if ((var2==var1))         #condition if user and random values are same
then 
echo " congrats you guess it right "   #on same value printing congrats
break
fi

if ((var2>var1))     #if user value higher then random
then
echo "guess little lower "   #on higher value printing
fi
if ((var2<var1))           #if user guess low value
then
echo "guess little higher "   #printing on guess low age
fi 
done

