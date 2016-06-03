#!bin/bash
function getrating()
{
curl -s  "http://www.omdbapi.com/?t=$1&y=&plot=short&r=xml" > mov.txt
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
rate=$(printf %.1f $rating)
echo $rate
}

rm out.txt
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
sort -k 1 -r out.txt
exit 1

