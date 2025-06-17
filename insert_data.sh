#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams restart identity")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
# echo $WINNER
  if [[ $WINNER != 'winner' ]]
  then
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    if [[ -z $WINNER_ID ]]
    then 
      INSERT_RESULT=$($PSQL "insert into teams(name) values('$WINNER')")
      WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    fi

    OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
    if [[ -z $OPPONENT_ID ]]
    then 
      INSERT_OPP=$($PSQL "insert into teams(name) values('$OPPONENT')")
      OPPONENT_ID=$($PSQL "select team_id from teams where name ='$OPPONENT'")
    fi

    INSERT_GAME=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done