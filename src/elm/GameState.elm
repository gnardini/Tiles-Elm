module GameState exposing (..)

import Board exposing (..)
import Tile exposing (..)
import Player exposing (..)

import List exposing (..)
import Random exposing (..)

type GameState = InGame InGameState | Menu MenuState

type alias InGameState = {
    board: Board,
    player1: Player,
    player2: Player,
    playerTurn: Int,
    seed: Seed
}

type alias MenuState = {
    text: String,
    winner: Maybe String
}

-- Initial state of the game.
initialMenuState : GameState
initialMenuState =
    Menu {
        text = "Play"
        , winner = Nothing
    }

initialInGameState : GameState
initialInGameState =
    let
        firstSeed = initialSeed 1234
        (firstBoard, afterInitSeed) = initialBoard firstSeed
    in InGame {
    board = firstBoard,
    player1 = createPlayer,
    player2 = createPlayer,
    playerTurn = 1,
    seed = afterInitSeed}

-- Called when there's a click on the UI over the board.
onTouchReceived: InGameState -> Int -> Int -> InGameState
onTouchReceived originalState x y =
    if (getTileAt originalState.board x y == Empty)
    then originalState
    else
        let
            (newBoard, points) = onBoardTouched originalState.board x y (turnPlayer originalState)
            newPlayer = updatedPlayer originalState points
        in {
        board = newBoard,
        player1 = if originalState.playerTurn == 1 then newPlayer else originalState.player1,
        player2 = if originalState.playerTurn == 2 then newPlayer else originalState.player2,
        playerTurn = if originalState.playerTurn == 1 then 2 else 1,
        seed = originalState.seed}

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

applyGravityToTiles: InGameState -> InGameState
applyGravityToTiles gameState =
    {gameState | board =
        gameState.board
            |> applyColumnGravity
            |> applyRowGravity}

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
