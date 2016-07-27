module GameState exposing (..)

import Board exposing (..)
import Player exposing (..)

import List exposing (..)
import Random exposing (..)

type alias GameState = {
    board: Board,
    player1: Player,
    player2: Player,
    playerTurn: Int,
    seed: Seed
}

-- Initial state of the game.
initialState: GameState
initialState = 
    let 
        firstSeed = initialSeed 1234
        (firstBoard, afterInitSeed) = initialBoard firstSeed
    in {
    board = firstBoard,
    player1 = createPlayer,
    player2 = createPlayer,
    playerTurn = 1,
    seed = afterInitSeed}

-- Called when there's a click on the UI over the board.
onTouchReceived: GameState -> Int -> Int -> GameState
onTouchReceived originalState x y = 
    let
        (newBoard, points) = onBoardTouched originalState.board x y (turnPlayer originalState)
        newPlayer = updatedPlayer originalState points
    in {
    board = newBoard,
    player1 = if originalState.playerTurn == 1 then newPlayer else originalState.player1,
    player2 = if originalState.playerTurn == 2 then newPlayer else originalState.player2,
    playerTurn = if originalState.playerTurn == 1 then 2 else 1,
    seed = originalState.seed}

updatedPlayer: GameState -> Int -> Player
updatedPlayer gameState points =
    if gameState.playerTurn == 1
    then addPoints gameState.player1 points
    else addPoints gameState.player2 points

-- Returns the player that owns the turn on |gameState|.
turnPlayer: GameState -> Player
turnPlayer gameState = 
    if gameState.playerTurn == 1 
    then gameState.player1
    else gameState.player2
