#!/bin/bash
 
if [ $# -ne 1 -o ! -d $1 ]; then                    # Проверка дали е един параметър и той е директория
        echo "Invalid parameters"
        exit 1
fi
 
LOG_FILES=($(find $1 -type f -name '*.log'))		# Намираме всички лог файлове  и ги записваме в масив
 
for i in "${LOG_FILES[@]}"    				# Обхождаме всеки лог файл
do
		DIRNAME="$(echo $i | cut -d'.' -f1)"  # Намираме името на директорията ( изваждаме го от името на лог файла)
		
		if [ ! -d $DIRNAME ]; then        # Проверка дали съществува такава директория
				echo "There is no directory for log file: $i"
				continue;
		fi
		
 		declare -a INFO                # Декларираме масив, в който ще се запише информацията за всяка снимка
        POS=1    					   # Създаваме променлива, която ще пази позицията от масива
		SKIP=1						   # Създаваме променлива, която ще пази стойностите 0 или 1 
									   #(1 - когато реда е празен, 0 - когато на реда има символи)
 
        while read -r LINE    		   # Четем ред по ред от лог файла
        do
 
                [[ $LINE == "" ]] && ((POS++)) && SKIP=1 && continue   # Ако реда е празен, увеличаваме позицията с 1
																	   # Задаваме на SKIP стойност 1 и продължаваме към следващия ред
 
 
				# Ако SKIP е 0, това означава, че реда не е празен и вече сме записали първия ред от 
				# текущия запис. В такъв случай, долепяме реда към позиция POS от масива
				# Ако SKIP е 1, но реда не е празен ( от горното условие ), то това означава, че сме на първия ред 
				# от информацията за снимката. В такъв случай, записваме реда на позиция POS и задаваме на SKIP стойност 0
                [[ $SKIP == 0 ]] && INFO[$POS]="${INFO[$POS]}		  
                $LINE" ||
                {
                        INFO[$POS]="$LINE"
                        SKIP=0
                }
        done < "$i"
 
        IMGS=($(ls -ct $DIRNAME))  # Взимаме всички файлове от директория, подредени по creation time и ги записваме в масив
        FILE_CNT=0    # Създаваме брояч, който ще следи кой файл трябва да бъде преименуван
 
        for j in "${INFO[@]}"   # Обхождаме масива с информацията за всяка снимка
        do
 
        DATE_EPOCH=$( echo "$j" | head -1 | cut -d' ' -f1)       # Изваждаме датата 
        DATE_FORMATED=$(date -d @$DATE_EPOCH  +%Y-%m-%dT%H%M)    # Форматираме датата
        LOCATION=$(echo "$j" | head -1 | cut -d' ' -f2)          # Изваждаме местоположението 
        DESCR=$(echo "$j" | cut -d$'\n' -f2 | tr [:upper:] [:lower:])      # Изваждаме описанието и заменяме главните букви с малки
        NEW_NAME=$DIRNAME/$(echo $DATE_FORMATED $DESCR | tr ' ' '_').jpg   # Намираме какво ще е новото име на файла
        OLD_NAME=$DIRNAME/${IMGS[$FILE_CNT]}							   # Вземаме старото име ( конкатенираме името с директорията)
 
        mv $OLD_NAME $NEW_NAME				# Преименуваме
        echo "Old name: $OLD_NAME"
        echo "New name: $NEW_NAME"
 
		# С exiftool записваме местоположението с таг location в метадатата на снимката
        exiftool -q -overwrite_original -location=$LOCATION $NEW_NAME    
        echo "Location [$LOCATION] was added to the EFIX of the file"
        echo "====================="
        ((FILE_CNT++))      # Увеличаваме брояча на масива, който пази имената на снимките  ( вж. OLD_NAME )
 
        done
done
 
exit 0
