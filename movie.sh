#!bin/bash

mkdir tmp #Making a folder to dump files
readonly NUM_ARGUMENTS=$#
readonly DIRECTORY_NAME=$1

function add_style(){
        tput bold
        tput setaf $2
        echo $1
        tput sgr 0
        return 0
}


function get_rating(){
    local movie_name=$1
    local rating_in_string=$( curl -s  "http://www.omdbapi.com/?t=$movie_name&y=&plot=short&r=xml" | \
                      grep -o imdbRating=".*" | \
                      cut -c 13,14,15)
    #Convert String to Float
    local rating_in_float=$(printf %.1f $rating_in_string)
    echo $rating_in_float
}


function main(){
   
    #There should be exactly one argument i.e the address path
    if [ $NUM_ARGUMENTS != 1 ]
    then
	    add_style "This application takes one argument : Movie Directory" 1
	exit 4
    fi
    #Fetching Movies and removing 
    ls $DIRECTORY_NAME > tmp/movlist.txt
    local movie_count=$( cat tmp/movlist.txt | \
                     wc -l )
    if [ $movie_count == 0 ]
    then
        add_style "Directory is either Invalid or Empty" 1 
        exit 4
    fi
    sed 's/_/./g' tmp/movlist.txt > tmp/temp_clean_mov.txt
    sed 's/ /./g' tmp/temp_clean_mov.txt > tmp/clean_mov.txt
    echo Rating '     '  Novie >> tmp/out.txt  
    while IFS= read -r movie_name
    do
        rating=$( get_rating $movie_name )
        if [ $rating == 0.0 ]
        then
	        rating="N/A"
        fi
        echo $rating '      '  $movie_name >> tmp/out.txt
    done < "tmp/clean_mov.txt"
    clear
    #Above, a file is created with 2 coloumns of Movie and rating
    #Then it is sorted
    sort -k 1 -r tmp/out.txt
    tput setaf 1
    tput bold
    printf  "\n\nN/A: The application was unable to fetch your movie. We regret this deeply\n"
    tput sgr 0
    rm -rf tmp
    exit 0
}

main
