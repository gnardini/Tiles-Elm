module TouchManager exposing (onTouchReceived)

import BoardGravity exposing (applyGravityToTiles)
import GameStateManager exposing (checkGameOver, updatedPlayer, turnPlayer)

import GameState exposing (GameState (..), InGameState)
import Board exposing (Board, getTileAt)
import Tile exposing (Tile (..))
import Player exposing (Player)

import Matrix exposing (..)

-- When there's a click on the UI over the board, update the state accordingly.
onTouchReceived : InGameState -> Int -> Int -> GameState
onTouchReceived inGameState x y =
  applyTouch inGameState x y
    |> applyGravityToTiles
    |> checkGameOver

-- Called when there's a click on the UI over the board.
applyTouch : InGameState -> Int -> Int -> InGameState
applyTouch originalState x y =
    if (getTileAt originalState.board x y == Empty)
    then originalState
    else
        let
            (newBoard, points) = onBoardTouched originalState.board x y (turnPlayer originalState)
            newPlayer = updatedPlayer originalState points
        in
        { board = newBoard
        , player1 = if originalState.playerTurn == 1 then newPlayer else originalState.player1
        , player2 = if originalState.playerTurn == 2 then newPlayer else originalState.player2
        , playerTurn = if originalState.playerTurn == 1 then 2 else 1
        , seed = originalState.seed
        }


onBoardTouched : Board -> Int -> Int -> Player -> (Board, Int)
onBoardTouched board x y player =
    expandTouch board (getTileAt board x y) x y 0

expandTouch : Board -> Tile -> Int -> Int -> Int -> (Board, Int)
expandTouch board touchedTile x y explotedTiles =
    if ((getTileAt board x y) == touchedTile)
    then expandNeighbours board touchedTile x y (explotedTiles + 1)
    else (board, explotedTiles)

expandNeighbours : Board -> Tile -> Int -> Int -> Int -> (Board, Int)
expandNeighbours board touchedTile x y explotedTiles =
    let
        newBoard = set (loc x y) Empty board
        (upBoard, upTiles) = expandTouch newBoard touchedTile x (y - 1) explotedTiles
        (downBoard, downTiles) = expandTouch upBoard touchedTile x (y + 1) upTiles
        (leftBoard, leftTiles) = expandTouch downBoard touchedTile (x - 1) y downTiles
        (rightBoard, rightTiles) = expandTouch leftBoard touchedTile (x + 1) y leftTiles
    in (rightBoard, rightTiles)
