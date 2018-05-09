# Bash Scripts

### This repository has some bash scripts for solving different problems.

**!! The comments in the scripts are in Bulgarian**

**!! The problem description is in Bulgarian ( When I have time, I will translate them :))**

## Задача 01:

В архива http://ftp.uni-sofia.bg/misc/uniq_files.tar.xz има две директории на първо ниво - one и two, съдържащи файлове. За два файла казваме, че са "еднакви" ако имат еднакво съдържание. Напишете скрипт(-ове) или серия от команди, които за всяка от директориите да:
- извеждат броя на уникалните (по съдържание) файлове
- изтриват всички копия на "еднакви" файлове, т.е., ако файлове f1, f2 и f3 са "еднакви", то трябва да се изтрият и трите файла.

## Задача 02:

Напишете скрипт, който приема параметър - име на директория (foo), в която може да има няколко двойки:
- директория с някакво име (asdf);
- файл със същото име като директорията, с добавено .log накрая (asdf.log).

Примерна структура:

/foo/dir1/
/foo/dir1.log
/foo/dir89/
/foo/dir89.log

В всяка една директория (asdf, dir1, dir89, ...) има .jpg файлове, а .log файловете имат следния формат:
```
1493647008 42.1234,-23.456
some description
foo
barbaz

1494882000 42.1234,-23.456
other description
```

В този файл е записана допълнителна информация за снимките от съответната директория. Първото число е дата в Unix time (POSIX time/epoch time); следващите две числа, отделени със запетайка, указват географското местоположение; останалите редове са описание. Разделителят между два такива записа е празен ред.

Всеки запис отговаря на един .jpg файл в съответната директория, като редът на записите в .log-файла съответства на реда на файловете, подредени по ctime (беше creation time).

За улеснение приемаме, че в имената на всички файлове и директории няма специални символи.

Скриптът да преименува всеки .jpg файл на базата на съответстващия му запис в .log към следния формат:

YYYY-MM-DDTHHMM_описание.jpg

където:
    - "YYYY-MM-DDTHHMM" е дата, 4 цифри за година, 2 за месец, 2 за дата, буквата T, 2 цифри за час в 24-часов формат, 2 цифри за минута -- например 2017-05-01T1656
    - "описание" e първият ред от описанието в за съответния файл в .log-файла, като думите са разделени с долни черти и са с малки букви.

Примерни нови имена:

2017-05-01T1656_some_description.jpg
2017-05-16T0000_other_description.jpg

Забележка: За конвертиране на датата може да ползвате date(1).

За незадължителен бонус: Вкарайте географското местоположение в EXIF-а на .jpg файла.

## Задача 03:

Годината е 1978.

Вие се намирате на американски самолетоносач. Току що е открита потънала
нацистка подводница, чийто екипаж е загинал преди повече от 30 години.
На нея е открито тайно кодирано съобщение, изпратено точно в края на войната.
В тази вселена обаче науката се развива бавно - най-напредналият шифър, който
е съществувал по това време е изместващият шифър.

Вашата задача е да декодирате съобщението.

Как работи шифърът:

Ключът представлява една буква. Азбуката се измества циклично наляво така,
че ключът да е първата буква.

Например, ако ключът е `g`, то за да криптираме използваме:

```
g h i j k l m n o p q r s t u v w x y z a b c d e f
↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
a b c d e f g h i j k l m n o p q r s t u v w x y z

А за да декриптираме:

a b c d e f g h i j k l m n o p q r s t u v w x y z
↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓ ↓
g h i j k l m n o p q r s t u v w x y z a b c d e f
```

Задачата:

Архивът съдържа файл `morse`, който е речник на морзовата азбука и файл
`secret_message`.

    a) Напишете редица от команди, която заменя морзовият код с малки
       латински букви и извежда резултата във файл `encrypted`. Изходът
       трябва да е на един ред, без интервали, с един знак за нов ред на
       края на реда.

    б) Напишете редица от команди, която намира правилният ключ и изписва
       съдържанието на разкодираното тайно съобщение. Използвайте, че е силно
       вероятно съобщението да съдържа низа "fuehrer".

За всяка от под-точките, изходът трябва да е на един ред, без интервали, с
един знак за нов ред на края на реда.




