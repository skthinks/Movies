#!bin/bash

readonly NUM_ARGUMENTS=$#
readonly DIRECTORY_NAME=$1

function add_style(){
    tput bold
    tput setaf $2
    echo -e $1
    tput sgr 0
    return 0
}


function get_rating(){
    local movie_name=$1
    local rating_in_string=$(curl -s  "http://www.omdbapi.com/?t=$movie_name&y=&plot=short&r=xml" \
       | grep -o imdbRating=".*" \
       | cut -c 13,14,15)
    local rating_in_float=$(printf %.1f $rating_in_string)     # Convert Rating String to Float
    echo $rating_in_float
}


function main(){
   
    # There should be exactly one argument i.e the address path
    if [ $NUM_ARGUMENTS != 1 ]; then
        add_style "This application takes one argument : Movie Directory" 1
        exit 4
    fi
    # Fetching Movies and removing 
    local movie_list=$( ls $DIRECTORY_NAME \
        | grep "" \
        | sed 's/ /./g; s/_/./g')
    local movie_count=$(echo $movie_list \
        | wc -l)
    if [ $movie_count == 0 ]; then
        add_style "Directory is either Invalid or Empty" 1 
        exit 4
    fi
    local output="Rating      Movie\n"
    for movie_name in $movie_list; do
        local rating=$( get_rating $movie_name )
        if [ $rating == 0.0 ]; then
            rating="N/A"
        fi
        output="$output $rating       $movie_name\n"
    done
    # Above, a file is created with 2 coloumns of Movie and rating
    # Then it is sorted
    echo -e $output | sort -k 1 -r
    add_style  "\n\nN/A: The application was unable to fetch your movie. We regret this deeply\n" 1
    exit 0
}

main
