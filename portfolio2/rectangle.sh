#/bin/bash

####### MUHAMMAD FAIZAN AFZAL #########
######## 10480554 #########


INFILE="$1"

# Check if argument is passed
if [[ -z "$INFILE" ]];then
	# instructions to pass argument
	echo "USAGE : bash $0 [ File ]"
	echo "Example: bash $0 rectangle.txt"
	exit 1
fi

# generating output filename from input file [ rectangle.txt to rectangle_f.txt ]
OUTFILE=$(echo $INFILE|sed 's/\./_f./')

# Saving header line of file to array
HEADER=($(sed  -e 's/,/ /g' -e 1q "$INFILE"))

# removing header line and saving to new file
sed 1d "$INFILE" > /tmp/"$OUTFILE"

# using sed replacing ^ with first value of header line to first column
# then replacing columns of , with subsequent header values
# adjusting format with column and saving output to file
sed -e "s/^/${HEADER[0]}: /" -e "s/,/ ${HEADER[1]}: /" -e "s/,/ ${HEADER[2]}: /" -e "s/,/ ${HEADER[3]}: /" -e "s/,/ ${HEADER[4]}: /" /tmp/"$OUTFILE"|column -t -s' '> $OUTFILE
cat $OUTFILE
exit 0