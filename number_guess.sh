#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo -e "\n~~ Number Guessing Game ~~\n"

SECRET_NUMBER=$((RANDOM%1000 + 1))
NUMBER_OF_GUESSES=1

echo -e "\nEnter your username:"
read USERNAME

RESULT_CHECK_USERNAME=$($PSQL "SELECT games_played, best_game FROM users WHERE username='$USERNAME'")


if [[ $RESULT_CHECK_USERNAME ]]
then
  echo "$RESULT_CHECK_USERNAME" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do
    echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  done
else
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

while [[ $GUESS -ne $SECRET_NUMBER ]]
do
  if ! [[ $GUESS =~ ^[0-9]+$ ]]  #or?: if [[ -z $GUESS =~ ^[0-9]+$ ]]
  then
    echo -e "\nThat is not an integer, guess again:"
  elif [[ $GUESS -gt $SECRET_NUMBER ]]
  then
    echo -e "\nIt's lower than that, guess again:"
  else
    echo -e "\nIt's higher than that, guess again:"
  fi

  NUMBER_OF_GUESSES=$((NUMBER_OF_GUESSES + 1))
  read GUESS
done

echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"

if [[ -z $RESULT_CHECK_USERNAME ]]
then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users(username, games_played, best_game) VALUES('$USERNAME', 1, $NUMBER_OF_GUESSES)")
else 
  echo "$RESULT_CHECK_USERNAME" | while IFS="|" read GAMES_PLAYED BEST_GAME
  do 
    GAMES_PLAYED=$((GAMES_PLAYED + 1))
    CHANGE_GAMES_PLAYED_RESULT=$($PSQL "UPDATE users SET games_played=$GAMES_PLAYED WHERE username='$USERNAME'")
    if [[ $NUMBER_OF_GUESSES -lt $BEST_GAME ]]
    then
      CHANGE_BEST_GAME_RESULT=$($PSQL "UPDATE users SET best_game=$NUMBER_OF_GUESSES WHERE username='$USERNAME'")
    fi
  done
fi
