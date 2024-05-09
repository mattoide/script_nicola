#! /bin/bash

echo "Inserisci il path assoluto della CARTELLA SORGENTE:"
read sorgente

echo "Inserisci il path assoluto della CARTELLA DESTINAZIONE:"
read destinazione

echo "Inserisci il path assoluto del file CSV SORGENTE:"
read file_csv_sorgente

echo "Inserisci il path assoluto del file CSV DESTINAZIONE (con colonne store_fname ecc):"
read file_csv_destinazione

#
#sorgente="/home/matto/Scaricati/File inviato compresso/Nuova cartella/25-01-2024"
#destinazione="/home/matto/Scrivania/script_nicola/novakb_develop"
#file_csv_sorgente="/home/matto/Scrivania/script_nicola/core/source/sorgente.csv"
#file_csv_destinazione="/home/matto/Scrivania/script_nicola/core/dest/destinazioni.csv"

file_extension="pdf"

result=$(test -d "$sorgente")
resu=$?
if [[ $resu == 1 ]]
      then
        echo "$sorgente non esiste"
        exit

fi

result=$(test -d "$destinazione")
resu=$?
if [[ $resu == 1 ]]
      then
        echo "$destinazione non esiste"
        exit

fi

result=$(test -f "$file_csv_sorgente")
resu=$?
if [[ $resu == 1 ]]
      then
        echo "$file_csv_sorgente non esiste"
        exit

fi

result=$(test -f "$file_csv_destinazione")
resu=$?
if [[ $resu == 1 ]]
      then
        echo "$file_csv_destinazione non esiste"
        exit

fi



echo "SORGENTE: $sorgente"
echo "DESTINAZIONE: $destinazione"
echo "CSV (sorgente): $file_csv_sorgente"
echo "CSV (destinazione): $file_csv_destinazione"


result=$(test -f founds.txt)
resu_f=$?

result=$(test -f not_founds.txt)
resu_nf=$?

echo $resu_f

if [[ $resu_f == 0 ]] &&  [[ $resu_nf == 0 ]];
      then
        echo "File founds.txt e not_founds.txt già presenti. Vuoi rilanciare la verifica? (richiede tempo) [y/n]"
        read delete_files
fi


if [[ $delete_files == "y" ]];
then
rm founds.txt not_founds.txt
ARRAY_files_names=()

echo "Salvo i nomi dei file da cercare..."

while IFS="," read -r a nome_file
  do
  #  echo "Nome file: [$nome_file]  "
    ARRAY_files_names+=("$nome_file")
  #  echo ""
  done < <(tail -n +2 $file_csv_sorgente)


ARRAY_files_names_datas_name=()
ARRAY_files_names_store_name=()

echo "Salvo i valori delle colonne datas_name e store_fname..."

while IFS="," read -r a b datas_name d e f g h i j k l m n o store_fname q r s t u v w x y z
  do
  #  echo "C: [$datas_name] - P: [$store_fname] "
    ARRAY_files_names_datas_name+=("$datas_name")
    ARRAY_files_names_store_name+=("$store_fname")
  #  echo ""
  done < <(tail -n +2 $file_csv_destinazione)

#TODO: check numero corretto di righe
#echo "store di:  ${ARRAY_files_names_datas_name[25149]}"

echo "${#ARRAY_files_names[@]} files da cercare in ${#ARRAY_files_names_datas_name[@]} record"

#ARRAY_files_names=('nome1' 'nome2' 'nome3')
#ARRAY_files_names_datas_name=('"nome4.pdf"' 'nome10.pdf' 'nome3.pdf' 'nome11.pdf' 'nome1.pdf')
#ARRAY_files_names_store_name=('str4' 'str10' 'str3' 'str11' 'str1')


echo "Inizio ricerca nomi dei file..."

for file in "${ARRAY_files_names[@]}"
  do
      file_=''

      for ((i=0; i<${#ARRAY_files_names_datas_name[@]}; i++)); do

      filaname=${ARRAY_files_names_datas_name[$i]}
      newfilename="${filaname//"\""/}"


      echo "Indice: $i"


    if  [[ ${ARRAY_files_names_datas_name[$i]} != "" ]]; then
        if [[ $newfilename == "$file.pdf" ]]
        then
          echo "File $file trovato in posizione: $i"
          echo "$file,$i,${ARRAY_files_names_store_name[$i]}" >> founds.txt
          file_=$file
          break

        #TODO: LEGGO FNAME
        fi
    fi

      done

        if [[ "$file_" == "" ]]; then
                echo "File $file non trovato"
                echo "$file" >> not_founds.txt
        fi
  done
echo "Risultati salvati in founds/not_founds"
fi



#  LEGGO DA FILE FOUNDS.TXT
while IFS="," read -r name index store
  do
    filaname=$store
    newfilename="${filaname//"\""/}"
    folder_file=(${newfilename//// })

#    echo "Nome file: [$name] - Folder: [${folder_file[0]}]  - File:  [${folder_file[1]}]"

    result=$(find "$destinazione/$newfilename")
        if [[ $result == "" ]]
        then
          echo "File '$newfilename' non trovato. Copio..."
          result=$(test -d "${folder_file[0]}")
          resu=$?
          if [[ $resu == 1 ]]
                then
                  echo "${folder_file[0]} non esiste. Creo cartella..."
                  mkdir "$destinazione/${folder_file[0]}"
          fi

          cp "$sorgente/$name.$file_extension" "$destinazione/$newfilename"
          echo "copio da [$sorgente/$name]  a  [$destinazione/$newfilename]"
        else
            echo "File '$newfilename' OK!"
        fi

        echo ""
  done < <(tail -n +1 ./founds.txt)


