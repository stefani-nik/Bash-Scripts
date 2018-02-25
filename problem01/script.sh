#!/bin/bash
 
CNT_TOTAL=0    # Брояч за обща брой на файловете 
CNT_UNIQ=0     # Брояч за уникалните файлове
CNT_DELETED=0  # Брояч за изтритите файлове 
while IFS= read -r -d '' FILE;    # Цикъл, който минава през всички файлове
								  # в директорията, които се подават ч/з find командата
do     # Докато има файлове в директорията
((CNT_TOTAL++))  # Увеличаваме брояча за общия брой на файловете
FOUND=false    #  Булева променлива, която отговаря 
			   #  за проверка дали е намерен поне един файл,
			   #  идентичен на текущия
if [ -f "${FILE}" ]; then  # Проверка дали файла същестува (т.е. не е премахнат)
((CNT_UNIQ++))  # Увеличаваме брояча за уникалните файлове, тъй като 
				# всички дубликати на текущия файл ще бъдат премахнати
FILE_DATA=`md5sum "${FILE}"| cut -d' ' -f1`	 # Намираме уникалния за текущия файл хеш с md5sum 
        while IFS= read -r -d '' CHECK_FILE; # Пак цикъл, който минава през файловете
        do
            CHECK_FILE_DATA=`md5sum "${CHECK_FILE}"| cut -d' ' -f1`  # Намираме уникалния хеш за файла, който проверяваме
 
 
				# Ако двата хеш-а съпадат и файловете не са едни и същи (т.е. файла не е себе си -_-) 
                if [ "${FILE_DATA}" = "${CHECK_FILE_DATA}" ] && [ "${FILE}" != "${CHECK_FILE}" ] ; then  
                        rm -f "${CHECK_FILE}"  # Изтриваме файла, който проверяваме
                        FOUND=true             # Индикация, че сме намерили поне един дубликат
                        ((CNT_DELETED++))      # Увеличаваме брояча за изтритите файлове
                fi	
			
        done < <(find /home/stefani/uniq_files/ -type f -print0)
		
		# Ако сме намерили поне един дубликат, то трием и текущия файл
   if [ "${FOUND}" = true ]; then
        rm  -f "${FILE}"
        ((CNT_DELETED++))  # Пак увеличаваме брояча за изтритите файлове
   fi
fi

# Продължаваме напред
done < <(find /home/stefani/uniq_files/ -type f -print0)


echo "All files: $CNT_TOTAL"             # 280
echo "Unique files count: $CNT_UNIQ"     # 186
echo "Deleted files: $CNT_DELETED" 		 # 99



Алтернативно решение:
echo "Unique files count: $(($(find ./uniq_files -type f | wc -l) - $(fdupes  -rf ./uniq_files/ | grep -v ^$ | wc -l)))" 
&& fdupes -rdIN ./uniq_files/

Това обаче не трие всички файлове, а оставя един от дубликатите
