#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c" 

FETCH(){
  COLUMN_NAME=""
  QUOTES="'"
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # column name is atomic_number
    COLUMN_NAME="atomic_number"
    # numbers don't need quotes
    QUOTES=""
  # if argument is a symbol
  elif [[ $1 =~ ^[A-Z][A-Za-z]?$ ]]
  then
    # column name is symbol
    COLUMN_NAME="symbol"
  else
    # else column name is name
    COLUMN_NAME="name"
  fi
  # fetch row
  RESULT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements inner join properties using(atomic_number) left join types using(type_id) where $COLUMN_NAME=$QUOTES$1$QUOTES")
  # split string
  echo $RESULT | while IFS='|' read ATOMIC_NUMBER NAME SYMBOL TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS 
  do
    # if element exists
    if [[ $ATOMIC_NUMBER ]]
    then 
      # print info
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    else
      echo "I could not find that element in the database."
    fi
  done
}

# if script runs with an argument
if [[ $1 ]] 
then
  # search db entry
  FETCH $1
else   
  echo "Please provide an element as an argument."
fi
