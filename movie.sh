#!bin/bash

#readonly TEMP_PATH="/var/folders/3c/gjd471t51px36pjlbr7zggmh0000gn/T/imdb"
readonly TEMP_PATH="$TMPDIR/imdb"
mkdir $TEMP_PATH      # Making a Folder to Dump Files
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
    local rating_in_float=$(printf %.1f $rating_in_string)     # Convert Rating String to Float
    echo $rating_in_float
}


function main(){
   
    # There should be exactly one argument i.e the address path
    if [ $NUM_ARGUMENTS != 1 ]
    then
	    add_style "This application takes one argument : Movie Directory" 1
	exit 4
    fi
    # Fetching Movies and removing 
    ls $DIRECTORY_NAME > "$TEMP_PATH/movlist.txt"
    local movie_count=$( cat "$TEMP_PATH/movlist.txt" | \
                     wc -l )
    if [ $movie_count == 0 ]
    then
        add_style "Directory is either Invalid or Empty" 1 
        exit 4
    fi
    sed 's/_/./g' "$TEMP_PATH/movlist.txt" > "$TEMP_PATH/temp_clean_mov.txt"
    sed 's/ /./g' "$TEMP_PATH/temp_clean_mov.txt" > "$TEMP_PATH/clean_mov.txt"
    echo Rating '     '  Novie >> "$TEMP_PATH/out.txt"  
    while IFS= read -r movie_name
    do
        rating=$( get_rating $movie_name )
        if [ $rating == 0.0 ]
        then
	        rating="N/A"
        fi
        echo $rating '      '  $movie_name >> "$TEMP_PATH/out.txt"
    done < "$TEMP_PATH/clean_mov.txt"
    clear
    # Above, a file is created with 2 coloumns of Movie and rating
    # Then it is sorted
    sort -k 1 -r "$TEMP_PATH/out.txt"
    tput setaf 1
    tput bold
    printf  "\n\nN/A: The application was unable to fetch your movie. We regret this deeply\n"
    tput sgr 0
    rm -rf $TEMP_PATH
    exit 0
}

main
