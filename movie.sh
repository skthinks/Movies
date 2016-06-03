#!bin/bash
function getrating()
{
curl "http://www.omdbapi.com/?t=$1&y=&plot=short&r=xml" > mov.txt
grep -o imdbRating=".*" mov.txt > submov.txt
input="submov.txt"
echo ""
ctr=0
rating=""
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
rate=$(printf %.2f $rating)
echo $rate
}


ls movies > movlist.txt
sed 's/_/./g' movlist.txt > mov2.txt
input2="mov2.txt"
while IFS= read -r var2
do
  echo $var2
  rating=$( getrating $var2 )
  echo $rating
done < "$input2"
exit 1

function getratingi()
{
curl "http://www.omdbapi.com/?t=$1r&y=&plot=short&r=xml" > mov.txt
grep -o imdbRating=".*" mov.txt > submov.txt
input="submov.txt" 
echo ""
ctr=0
rating=""
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
echo $rating
return 0
}
