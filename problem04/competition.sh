#!/bin/bash

if [[ $# -ne 2 ]]; then
	echo "Invalid number of parameters"
	exit 1
fi

if [[ ! -d $1 ]]; then
	echo "The given directory does not exist"
	exit 1
fi

DIR=$1

LENGTH=${#DIR}
LAST_CHAR=${DIR:length-1:1}

[[ $LAST_CHAR != "/" ]] && DIR="$DIR/";


participants() {

	find "$DIR" -type f ! -empty -printf "%f\n"
}

outliers() {

	FILES=$(find "$DIR" -type f)

	for f in  $FILES
	do
		PARTICIPANTS=$(awk '/^QSO:/' $f | awk '{if(system( "[ ! -e '$DIR'" $9 " ]" ) == 0) {print $9}}')
		echo "$PARTICIPANTS" | tr ' ' '\n'
	done
}

unique() {

	FILES=$(find "$DIR" -type f)
	for f in $FILES
	do
		FILENAME=$(basename $f)
		COUNT=$(grep -r -l "$DIR" -e  "$FILENAME" | wc -l)

		if [ "$COUNT" -lt 4 ]; then
			echo $FILENAME
		fi
	done
}

cross_check() {

	FILES=$(find "$DIR" -type f)

	for f in $FILES
	do
		CURRENT=$(basename $f)
		while read -r line ; do

			PARTICIPANT=$(echo $line | awk '{print $9}')

			if [[ -e "$DIR$PARTICIPANT" ]]; then
				grep -q "$CURRENT" "$DIR$PARTICIPANT"; [ $? -eq 1 ] && echo "$line"
			fi

		done < <(grep 'QSO:' $f)
	done
}

bonus() {

	FILES=$(find "$DIR" -type f)

        for f in $FILES
        do
                CURRENT=$(basename $f)
                while read -r line ; do

			FIRST_HOUR=$(echo $line | awk '{print substr($5,0,2)}')
			FIRST_MINUTES=$(echo $line | awk '{print substr($5,3,2)}')

                        PARTICIPANT=$(echo $line | awk '{print $9}')
			FOUND=$(grep  "$CURRENT" "$DIR$PARTICIPANT" 2> /dev/null)

                        if [[ -e "$DIR$PARTICIPANT" ]] && [[ ! -z "$FOUND" ]]; then

				 SECOND_HOUR=$(echo $FOUND | awk '{print substr($5,0,2)}')
                       		 SECOND_MINUTES=$(echo $FOUND | awk '{print substr($5,3,2)}')

				 TOTAL_FIRST=$((10#$FIRST_HOUR*60 + 10#$FIRST_MINUTES))
				 TOTAL_SECOND=$((10#$SECOND_HOUR*60 + 10#$SECOND_MINUTES))

				 DIFF=$(($TOTAL_FIRST - $TOTAL_SECOND))

				if [[ $DIFF -lt -3 ]] || [[ $DIFF -gt 3 ]]; then
					echo $line
				fi
                        fi
                done < <(grep 'QSO:' $f)
        done

}

if [  "$(type -t $2)" != 'function' ]; then
        echo "The given function does not exist"
        exit 1
fi

$2
