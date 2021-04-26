#!/bin/bash
mkdir DBMS 2>> /dev/null

echo "HELLO , THIS IS MY DBMS"

function mainMenu
{
echo -e "\n+---Main Menu------+"
echo "    1. Create DB     "
echo "    2. List DB       "
echo "    3. Connect to DB "
echo "    4. Drop   DB     "
echo "    5. Exit DB       "
echo "+-----------------+"
echo -e "Enter your choice \n "
read num

case $num in 
	1) createDB ;;
	2) ls ./DBMS ; mainMenu  ;;
	3) connectDB ;;
	4) dropDB ;;
	5) exit ;;
	*) echo "wrong choice " ; mainMenu ;;
esac
}

function connectDB 
{
	echo -e "What DB you want to select ? \c "
	read db
	cd ./DBMS/$db 2>> /dev/null
	if [[ $? == 0 ]]; then 
		echo "you selected $db now"
	  tableMenu
	else
	
		echo "$db is not found"
	  mainMenu
	fi

}


function createDB
{
echo -e "Enter the name of the new database \c"
read db
mkdir ./DBMS/$db
    if [[ $? == 0 ]]; then
                 echo " $db database created "
         else
                 echo "$db database cannot be created"
         fi

	mainMenu

}

function dropDB 

{
echo -e "Enter the name of the database you want to delete \c"
read db
rm -r ./DBMS/$db 2>> /dev/null 
	
    if [[ $? == 0 ]]; then
                 echo " $db database dropped "
         else
                 echo "$db database cannot be dropped"
         fi

        mainMenu
}

function tableMenu 
{
echo -e "\n+-----Table Menu------+"
echo "    1. Create Table      "
echo "    2. List Tables       "
echo "    3. Drop Tables       "
echo "    4. Insert into table "
echo "    5. select from table "
echo "    6. delete from table "
echo "    7. exit              "
echo "+-----------------------+"
echo -e "Enter your choice \n "
read choice
case $choice in
        1) createTable ;;
        2) ls ; tableMenu ;;
	3) dropTable ;;
        4) insert ;;
        5) selectTable ;;
	6) deleteFromTable ;;
        7) exit ;;
        *) echo "wrong choice " ; tableMenu ;;	
esac
}

function createTable {
      echo -e "Enter table name \n "
      read tableName
      if [[ -f  tableName ]] ; then
	     echo "there is already one $tableName "
	     tableMenu
    #  else 
#	      mkdir $tableName 2>> /dev/null

#	      if [[ $? == 0 ]]; then
 #                echo " $tableName  created "
  #       else
   #              echo "$tableName cannot be created"
    #     fi
#
#	    cd $tableName
#	      touch data.csv
#	      touch metadata.csv
      fi

echo -e "Enter number of coloumns: \c "
read coloumnNum
echo -e "I will ask you about the name of coloumns but the 1st col is primary key, write from coloumn 2 "
	typeset -i counter
	counter=1 
	arrName[0]=primaryKey

while [[ $counter -lt $coloumnNum ]]
do	
   for value in "${arrName[@]}"
   do
	echo -e "Enter the name of the next  coloumn : \c "
        read value
	counter=$counter+1
	arrName[${#arrName[@]}]="$value"
   done
done


touch $tableName-data.csv
touch $tableName-metadata.csv

sep=","

#	meta="table Name"$sep"Number of coloumns"$sep"Name of coloumns "$rowSep
#	echo $meta  >>$tableName-metadata.csv
	meta1="$tableName"$sep"$coloumnNum"$sep"${arrName[@]}"
	echo $meta1 >>$tableName-metadata.csv

  if [[ $? == 0 ]]; then
                 echo " $tableName created "
         else
                 echo "$tableName cannot be created"
         fi

        tableMenu

}

function  dropTable {

echo -e "Enter the name of the table you want to delete : \c "
read tableName
rm $tableName-data.csv 2>> /dev/null
rm $tableName-metadata.csv 2>> /dev/null

	 if [[ $? == 0 ]]; then
        	         echo " $tableName table dropped "
      	 	  else
        	         echo " $tableName table cannot be dropped"
  	 fi
  tableMenu
}


function insert {
echo "enter the table you want to insert data to"
read tabName
meta=-metadata.csv
data=-data.csv
fileMeta=$tabName$meta
fileData=$tabName$data
#pwd
#echo $fileMeta $fileData

	if ! [[ -f $fileMeta  ]]; then
                        echo " $tabName table is not existed "
                  tableMenu
        fi

#coloumn=`head -2 $file | tail -1`
#echo $coloumn 
colNum=`cut -d "," -f 2 $fileMeta`
echo $colNum
colName=`cut -d "," -f 3 $fileMeta`
echo $colName 

echo -e " the selected table has $colNum coloumns,the 1st is primary key \n "
echo -e " please enter the data of $colName   \n "
#echo -e " please confirm your number of coloumns "
#read num 
typeset -i count
        count=1
        sep=","
	echo -e " please enter your special primary key   \n "
        read pk
	arrName[0]=$pk$sep
        

while [[ $count -lt $colNum ]]
do
   for value in "${arrName[@]}"
   do
        echo -e "Enter the value of the next  coloumn : \c "
        read value
        count=$count+1
        arrName[${#arrName[@]}]="$value$sep"
   done
done



        row="${arrName[@]}"
        echo $row >>$fileData

	echo -e "Now you added a row , do you want write another one answer y or n \n "

echo -e "y for yes and n for no "
read ans

if [[ $ans == y ]]; then
                echo "you will insert a new row now"
          insert
        else

                echo " insert is done "
          tableMenu
        fi

}

 




function selectTable {

echo -e "Enter Table name you want to select from \n "
read tNamee
data=-data.csv
fileDataaa=$tNamee$data

if ! [[ -f $fileDataaa  ]]; then
                        echo " $tNamee table is not existed "
                  tableMenu
        fi

echo -e "Enter primary key of row you want to select"
read primkey

linee=`awk -F, '{if($1=='$primkey'){print $0}}' $fileDataaa` 2>> /dev/null
echo $linee
        if [[ $linee == "" ]]; then
                        echo " $primkey is not existed "
                  tableMenu
        fi


echo -e "Now you seleted a row , do you want select another one answer y or n \n "

echo -e "y for yes and n for no "
read ansr

if [[ $ansr == y ]]; then
                echo "you will select a new row now"
          selectTable
        else
                 echo " delete row is done "
          tableMenu
        fi

}



function  deleteFromTable {
echo -e "Enter Table name you want to delete from \n "
read tName
data=-data.csv
fileDataa=$tName$data

if ! [[ -f $fileDataa  ]]; then
                        echo " $tName table is not existed "
                  tableMenu
        fi


echo -e "Enter primary key of row you want to delete"
read primk

rowline=`awk -F, '{if($1=='$primk'){print NR}}' $fileDataa` 2>> /dev/null
	if [[ $rowline == "" ]]; then
                        echo " $primk is not existed "
                  tableMenu
        fi

sed -i ''$rowline'd' $fileDataa 2>> /dev/null

        echo -e "Now you deleted a row , do you want delete another one answer y or n \n "

echo -e "y for yes and n for no "
read answer

if [[ $answer == y ]]; then
                echo "you will delete a new row now"
          deleteFromTable
        else

                echo " delete row is done "
          tableMenu
        fi


}


mainMenu ;



