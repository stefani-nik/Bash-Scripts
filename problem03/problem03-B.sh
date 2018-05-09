#!/bin/bash

read -r MESSAGE < $(find -type f -name 'encrypted.txt')

for value in {1..25}
do

	I1_START=$((97+$value))
	I1_END=$((122-$value))
	I2_START=$((96+$value))
	I2_END=$((123-$value))

	I1_START_C=($(printf "\x$(printf %x $I1_START)"))
        I1_END_C=($(printf "\x$(printf %x $I1_END)"))
	I2_START_C=($(printf "\x$(printf %x $I2_START)"))
        I2_END_C=($(printf "\x$(printf %x $I2_END)"))

	MESSAGE=($(echo "$MESSAGE" | tr "a-$I1_END_C$I2_END_C-z" "$I1_START_C-za-$I2_START_C"))

	if [[ "$MESSAGE" = *"fuehrer"* ]]; then
		KEY=$((97+$value+1))
		KEY_C=($(printf "\x$(printf %x $KEY)"))
  		echo "THE KEY IS : $KEY_C"
		echo "$MESSAGE"
		break
	fi
done

