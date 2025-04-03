#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"

  if [[ -z $1 ]]
  then
    echo "Please provide an element as an argument."
  elif [[ $1 =~ ^[0-9]+$ ]]
  then
    ARGUMENT_RESULT_ATOMIC_NUMBER=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE atomic_number=$1")
    if [[ $ARGUMENT_RESULT_ATOMIC_NUMBER ]]
    then 
      echo "$ARGUMENT_RESULT_ATOMIC_NUMBER" | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_POINT BAR BOIL_POINT
      do
        echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
      done
    else
      echo "I could not find that element in the database." 
    fi

  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    ARGUMENT_RESULT_SYMBOL=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE symbol='$1'")
    if [[ $ARGUMENT_RESULT_SYMBOL ]]
    then 
      echo "$ARGUMENT_RESULT_SYMBOL" | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_POINT BAR BOIL_POINT
      do
        echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
      done
    else
      echo "I could not find that element in the database."
    fi

  elif [[ $1 =~ ^[A-Z][a-z]*$ ]]
  then
    ARGUMENT_RESULT_NAME=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements LEFT JOIN properties USING(atomic_number) LEFT JOIN types USING(type_id) WHERE name='$1'")
    if [[ $ARGUMENT_RESULT_NAME ]]
    then 
      echo "$ARGUMENT_RESULT_NAME" | while read AT_NUM BAR NAME BAR SYMBOL BAR TYPE BAR AT_MASS BAR MELT_POINT BAR BOIL_POINT
      do
        echo "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
      done
    else
      echo "I could not find that element in the database."
    fi
  
  else 
    echo "I could not find that element in the database."
  fi
