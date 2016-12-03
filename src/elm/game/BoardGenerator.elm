module BoardGenerator exposing (initialInGameState)

import GameState exposing (GameState, ScreenState (..))
import Board exposing (Board, boardSize)
import Tile exposing (Tile(..), colorsCount, intToTile)
import Player exposing (createPlayer)

import Random exposing (..)
import Matrix exposing (fromList)

initialInGameState : GameState -> GameState
initialInGameState gameState =
    let
        (firstBoard, afterInitSeed) = initialBoard gameState.seed
    in
        { screenState = InGame
            { board = firstBoard
            , player1 = createPlayer
            , player2 = createPlayer
            , playerTurn = 1
            , mouseOver = Nothing
            }
        , seed = afterInitSeed
        }

initialBoard: Seed -> (Board, Seed)
initialBoard seed =
    let
        (updatedSeed, board) = randomBoard seed boardSize
    in
        (board, updatedSeed)

randomBoard : Seed -> Int -> (Seed, Board)
randomBoard seed size =
  let
    (tileMatrix, newSeed) = Random.step (tileMatrixGenerator size (tileGenerator (int 0 colorsCount))) seed
  in
    (newSeed, tileMatrix)

tileGenerator: Generator Int -> Generator Tile
tileGenerator intGenerator =
    Random.map intToTile intGenerator

tileMatrixGenerator: Int -> Generator Tile -> Generator (Board)
tileMatrixGenerator matrixSize tileGenerator =
    Random.map Matrix.fromList (Random.list matrixSize (Random.list matrixSize tileGenerator))
