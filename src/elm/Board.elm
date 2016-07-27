module Board exposing (..)

import Tile exposing (..)
import Player exposing (..)

import Array exposing (fromList)
import Matrix exposing (..)
import Random exposing (..)

type alias Board = Matrix Tile

boardSize: Int
boardSize = 10

initialBoard: Seed -> (Board, Seed)
initialBoard seed = 
    let
        (updatedSeed, board) = randomBoard seed boardSize
    in
        (board, updatedSeed)

onBoardTouched: Board -> Int -> Int -> Player -> (Board, Int)
onBoardTouched board x y player = 
    expandTouch board (getTileAt board x y) x y 0

expandTouch: Board -> Tile -> Int -> Int -> Int -> (Board, Int)
expandTouch board touchedTile x y explotedTiles =
    if ((getTileAt board x y) == touchedTile)
    then expandNeighbours board touchedTile x y (explotedTiles + 1)
    else (board, explotedTiles)

expandNeighbours: Board -> Tile -> Int -> Int -> Int -> (Board, Int)
expandNeighbours board touchedTile x y explotedTiles =
    let
        newBoard = set (loc x y) Empty board
        (upBoard, upTiles) = expandTouch newBoard touchedTile x (y - 1) explotedTiles
        (downBoard, downTiles) = expandTouch upBoard touchedTile x (y + 1) upTiles
        (leftBoard, leftTiles) = expandTouch downBoard touchedTile (x - 1) y downTiles
        (rightBoard, rightTiles) = expandTouch leftBoard touchedTile (x + 1) y leftTiles
    in (rightBoard, rightTiles)

boardTiles: Board -> List Tile
boardTiles board = flatten board

getTileAt: Board -> Int -> Int -> Tile
getTileAt board x y = 
    unwrapTile (get (loc x y) board)

unwrapTile: Maybe Tile -> Tile
unwrapTile maybeTile = 
    case maybeTile of
        Nothing -> Empty
        Just tile -> tile

randomBoard : Seed -> Int -> (Seed, Matrix Tile)
randomBoard seed size = 
  let
    (tileMatrix, newSeed) = Random.step (tileMatrixGenerator size (tileGenerator (int 0 colorsCount))) seed
  in
    (newSeed, tileMatrix)

tileGenerator: Generator Int -> Generator Tile
tileGenerator intGenerator = 
    Random.map intToTile intGenerator

tileMatrixGenerator: Int -> Generator Tile -> Generator (Matrix Tile)
tileMatrixGenerator matrixSize tileGenerator =
    Random.map Matrix.fromList (Random.list matrixSize (Random.list matrixSize tileGenerator))







