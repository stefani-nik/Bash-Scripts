#!/bin/bash

declare -a codearray
CODE_FILE=($(find -type f -name 'morse'))

read -r MESSAGE < $(find -type f -name 'secret_message')
readarray -t codearray < "$CODE_FILE"

MESSAGE=" $(echo "$MESSAGE" | sed "s/ /  /g") "

for code in "${codearray[@]}"
do

	CODE_LINE=($(echo "$code" | tr ' ' '\n'))
	CURRENT_LETTER=($(echo "${CODE_LINE[0]}" | tr '[:upper:]' '[:lower:]'))
	CODE=($(echo "${CODE_LINE[1]}" | sed "s/\./\\\./g"))
        MESSAGE=$(echo "$MESSAGE" | sed "s/ $CODE / $CURRENT_LETTER /g")
done

MESSAGE=($(echo "$MESSAGE" | sed "s/ *//g"))
echo -e "${MESSAGE}\n" > 'encrypted.txt'
echo "The encrypted message was written in the file encrypted.txt"
