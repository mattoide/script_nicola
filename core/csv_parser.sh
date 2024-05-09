#! /bin/bash

ARRAY=()

while IFS="," read -r a nome_file
do
  echo "Nome file: [$nome_file]  "

  ARRAY+=("$nome_file")

  echo ""
done < <(tail -n +2 ./source/sorgente.csv)

#echo ${ARRAY[*]}
iteration=0
file_=false
for file in "${ARRAY[@]}"
do

  file_=''
  echo "Cerco il file: $file"

  while IFS="," read -r a b datas_name d e f g h i j k l m n o store_fname q r s
  do
    ((iteration++))

#    echo "C: [$datas_name] - P: [$store_fname] "

    if [[ "$file.pdf" == "$datas_name" ]]; then
        echo "File: $file - Data name: $datas_name"
        echo "File trovato a iterazione: $iteration"
        echo "File: $file - Data name: $datas_name - Store name: $store_fname" >> trovati.txt
        file_=$file

        iteration=0
        break
    fi

  done < <(tail -n +2 ./dest/destinazioni.csv)

  if [[ "$file_" == "" ]]; then
          echo "$file" >> nontrovati.txt
  fi
done
#while IFS="," read -r a b datas_name d e f g h i j k l m n o store_fname q r s
#do
#  echo "C: [$datas_name] - P: [$store_fname] "
##  result=$(find "$c/$a")
##    if [[ $result == "" ]]
##    then
##      echo "File '$a' non trovato. Copio..."
###      cp "$b/$a" "$c/$a"
##    else
##        echo "File '$a' OK!"
##    fi
#
#  echo ""
#done < <(tail -n +2 ./dest/destinazioni.csv)