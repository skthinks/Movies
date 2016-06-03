#!bin/bash

function getrating()
{
#Fetch tuple from the Omdb API
curl -s  "http://www.omdbapi.com/?t=$1&y=&plot=short&r=xml" > mov.txt
#Getting the Line with the information
grep -o imdbRating=".*" mov.txt > submov.txt
input="submov.txt"
echo ""
ctr=0
rating=""
#Extracting the rating. Since the format is XYZ= "x"
#Track the opening and closing quotes to get x which is rating
#ctr tracks number of " encountered
while IFS= read -r -n1 var
do
  if [ $ctr -eq 2 ]
  then
        break
  elif [ $var == '"' ]
  then
        ctr=$(( $ctr + 1 ))
  elif [ $ctr -eq 1 ]
  then
        rating="$rating$var"
  else
        continue
  fi
done < "$input"
rm mov.txt
rm submov.txt
#Convert String to Float
rate=$(printf %.1f $rating)
echo $rate
}

rm out.txt
#Fetching Movies and removing _
ls movies > movlist.txt
sed 's/_/./g' movlist.txt > mov2.txt
input2="mov2.txt"
echo Rating '     '  Novie >> out.txt
while IFS= read -r var2
do
  #echo $var2
  rating=$( getrating $var2 )
  #echo $rating
  echo $rating '      '  $var2 >> out.txt
done < "$input2"
#Above, a file is created with 2 coloumns of Movie and rating
#Then it is sorted
sort -k 1 -r out.txt
exit 1

