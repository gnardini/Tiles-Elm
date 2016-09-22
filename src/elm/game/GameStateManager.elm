module GameStateManager exposing (checkGameOver, updatedPlayer, turnPlayer)

import Board exposing (Board, getTileAt, boardSize)
import GameState exposing (GameState (..), InGameState)
import Tile exposing (Tile (..))
import Player exposing (Player, addPoints)
import Action exposing (Action (..))

-- Updates the number of points of the player who just played.
updatedPlayer: InGameState -> Int -> Player
updatedPlayer gameState points =
    if gameState.playerTurn == 1
    then addPoints gameState.player1 points
    else addPoints gameState.player2 points

-- Returns the player that owns the turn on |gameState|.
turnPlayer: InGameState -> Player
turnPlayer gameState =
    if gameState.playerTurn == 1
    then gameState.player1
    else gameState.player2

checkGameOver : InGameState -> GameState
checkGameOver inGameState =
    if (getTileAt inGameState.board 0 (boardSize - 1) == Empty)
    then Menu { text = "Play Again", winner = Just(winnerText inGameState) }
    else InGame inGameState

winnerText : InGameState -> String
winnerText inGameState =
    if inGameState.player1.points > inGameState.player2.points then "Player 1 wins."
    else if inGameState.player1.points < inGameState.player2.points then "Player 2 wins"
    else "Tie"
