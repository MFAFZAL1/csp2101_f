#!/bin/bash
####### MUHAMMAD FAIZAN AFZAL #########
######## 10480554 #########


# web to download images
# https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152

#Wget command is a Linux command line utility that helps us to download the files from the web


#wget -O [file-name] [URL]

mainurl="https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152"
# run wget, download the source code, and hide the output
echo "Starting the script"
echo "Download the web source code"
echo "Please wait...."
wget -O web.txt $mainurl >/dev/null 2>/dev/null

#  using grep to find the lines that have
# "https://secure.ecu.edu.au/service-centres/MACSC/gallery/152"
# in it
# i search the source code inside web.txt and see that the images i need, all
# shares the same url and are exclusive to the rest of the source code of thw url

#The grep command is used to search text or searches the given file for lines containing a match to the given strings or words
#cat command allows us to create single or multiple files, view contain of file, concatenate files and redirect output in terminal or files
# cat the web part and redirect the output to a new file newweb.txt
cat web.txt | grep "https://secure.ecu.edu.au/service-centres/MACSC/gallery/152" > newweb.txt

#now newweb.txt have a list of only the photos i need to use in this proyect
# example of newweb.txt
#   <img src="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01533.jpg" alt="DSC01533">
#   <img src="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01536.jpg" alt="DSC01536">
#   <img src="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01543.jpg" alt="DSC01543">
#   <img src="https://secure.ecu.edu.au/service-centres/MACSC/gallery/152/DSC01558.jpg" alt="DSC01558">

# now remove not usefull characters from newweb.txt like >img src=" and the alt part
# only store the word that start with https:// and redirect that to newweb1.txt
grep -oP 'https://\S+' newweb.txt >> newweb1.txt

# move newweb1 to newweb to not generate a lot of files in the same folder
mv newweb1.txt newweb.txt
# remove web.txt
rm web.txt

# copy the values from newweb.txt to a my_array, easy to search images
my_array=()
while IFS= read -r line; do
  # if found that the url, have " in the last character, so i remove it before put in the new array
  
  value=$(echo ${line:0:-1})
  # add value to my new array
  my_array+=( "$value" )
done < <( cat newweb.txt )
# now, i have all images ulrs in my_array

main () {
  clear # clear the screen
  while : # main menu
  do
    echo "Welcome to my script"
    echo "What do you want to do today:"
    echo
    echo
    echo "1) Download a specific thumbnail"
    echo "2) Download ALL thumbnails"
    echo "3) Download images in a range"
    echo "4) Download a random images"
    echo
    echo "0) Quit"
    echo
    read -p "Select a number : " choice

    case $choice in
         1) specific_thumb
             ;;
         2) all_thumb
             ;;
         3) if range_thumb; then  # if range_thumb function return 1
              echo "Please try again"
              range_thumb
            fi
             ;;
         4) random_thumb
              ;;
         0)echo "Thanks for using my script"
           echo "Goodbye"
           exit
             ;;
         *) echo "Try again please"
   esac
  done


}

specific_thumb () {
  read -p "Select the image to download: EX: DSC01533:  " choice
  # get only the numbers grom string
  choice=$(echo $choice | grep -o -E '[0-9]+' | sed -e 's/^0\+//')
  # need to check if the input have 4 characters
  
  
  # dont need to valid if are a correct input, because a wrong one wont find a
  # image, and cant broke the script
  lenght=${#choice}

  while [[ $lenght -ne 4 ]];do
    echo "Please try with a correct input"
    read -p "Select a number of image to download : " choice
    lenght=${#choice}
  done

  success=0
  # loop the array
  for i in "${my_array[@]}"
    do
      # $i is the current record in the array
      # if i$ have the string $choice in it, then we find the specific thumb to download
      if [[ $i == *"$choice.jpg" ]]; then
        read -p "Select folder name to store new images : " choicefolder
        # call function download_thumb and send $i as arg
        download_thumb $i $choicefolder
        echo "Program Finished"
        read -p "Press enter to continue"
        success=1
      fi

    done

    if [[ $success -eq "0" ]];then
      echo "Cant find your choice in our thumbnail collection"
      
      read -p "Press enter to continue"
    fi

}

all_thumb () {
  read -p "Select folder name to store new images : " choicefolder
  # loop the array
  for i in "${my_array[@]}"; do
    download_thumb $i $choicefolder
  done
  echo "Program Finished"
  read -p "Press enter to continue"

}
range_thumb () {
  firstarray=${my_array[0]}
  lastarray=${my_array[-1]}
  firstarray=$(basename "$firstarray")
  lastarray=$(basename "$lastarray")


  # loop the array and print filename to user
  # s you can chose from where start and end the range
  echo "All images aviable to download:"
  for i in "${my_array[@]}"
  do
    file=$(basename "$i")
    filename=$(echo $file | head -c -5)
    printf $filename", "
  done
  echo
  echo
  echo "The first element is $firstarray and the last is $lastarray"
  echo "Please select first and last record to print"
  read -p "Write first number to range : " firstnumber
  read -p "Write second number to range : " secondnumber

  # need to check if the input is a number
  re='^[0-9]+$'
  # check if variable is numeric
  
  while ! [[ $firstnumber =~ $re ]] ; do
    echo "Print insert a valid number"
    read -p "Write first number to range : " firstnumber
  done
  while ! [[ $secondnumber =~ $re ]] ; do
    echo "Print insert a valid number"
    read -p "Write second number to range : " secondnumber
  done

  if [[ $firstnumber -gt $secondnumber ]] ; then
      echo "Cant follow, the first number need to be lesser then the second"
      return 0
  else
    success=0
    # loop the array
    printon=0
    for i in "${my_array[@]}";do
        # $i is the current record in the array
        # if i$ have the string $choice in it, then we find the specific thumb to download
        if [[ $i == *"$firstnumber.jpg" ]]; then
            # we find the first record to print
            printon=1
            read -p "Select folder name to store new images : " choicefolder
            # call function download_thumb and send $i as arg
            download_thumb $i $choicefolder
            echo $i
            continue
        fi
        # after find the first number, we change printon to 1, so we
        # start to download every record of the array
        if [[ $printon = 1 ]]; then
          download_thumb $i $choicefolder
        fi
        # we already download the last image, so we can leave the loop
        if [[ $i == *"$secondnumber.jpg" ]]; then
          return 1
        fi


      done
      # just in case, the last image is the last of the array
      return 1
  fi





}
random_thumb () {
  read -p "Write the number of random thumbnails you want to download : " randomnumber

  # need to check if the input is a number
  re='^[0-9]+$'
  # check if variable is numeric
  
  while ! [[ $randomnumber =~ $re ]] ; do
    echo "Print insert a valid number"
    read -p "Write a number to download random thumbnails : " randomnumber
  done


  read -p "Select folder name to store new images : " choicefolder
  # select a random item from my_array
  
  # using RANDOM function of bash, select a random record of my array
  # do a while based on the input of the user
  for ((i=1;i<=$randomnumber;i++)); do
    rand=$[$RANDOM % ${#my_array[@]}]
    download_thumb ${my_array[$rand]} $choicefolder
  done
  read -p "Press enter to continue"
}

download_thumb () {
  url=$1
  choicefolder=$2
  

  file=$(basename "$url")
  # this file now have the name ex: DSC1566.jpg
  # remove last 5 character from string
  filename=$(echo $file | head -c -5)
  # filename now has DCS1566
  wget -P ./$choicefolder $url >/dev/null 2>/dev/null

  # using LS to show stats of the file in human readable data
  
  size=$(ls -lh ./$choicefolder/$file | awk '{print $5}')


  echo "Downloading $filename, with the file name $file, with a file size of $size….File Download Complete"

}

main
