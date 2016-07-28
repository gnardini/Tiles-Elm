module Board exposing (..)

import Tile exposing (..)
import Player exposing (..)

import Array exposing (fromList)
import Matrix exposing (..)
import Random exposing (..)

-- Location (Column, Row) -> 0 indexed, (0, 0) on top left
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

applyColumnGravity: Board -> Board
applyColumnGravity tiles = 
    List.foldr applyGravityToColumnAtIndex tiles [0..boardSize - 1]

applyGravityToColumnAtIndex: Int -> Board -> Board
applyGravityToColumnAtIndex column tiles = 
    let filledPositions = filledPositionsAtColumn tiles column 
    in
        zip filledPositions (List.reverse [0..boardSize - 1])
            |> updateColumnPositions tiles column
            |> addEmptyTiles [0..boardSize - 1 - (List.length filledPositions)] column

filledPositionsAtColumn: Board -> Int -> List Int
filledPositionsAtColumn tiles column =
    List.reverse (List.filter (\index -> (getTileAt tiles column index) /= Empty) [0..boardSize - 1])

updateColumnPositions: Board -> Int -> List (Int, Int) -> Board
updateColumnPositions tiles column positionPairs =
    List.foldl (updateTilePosition column) tiles positionPairs

updateTilePosition: Int -> (Int, Int) -> Board -> Board
updateTilePosition column positionUpdate tiles =
    set (loc column (snd positionUpdate)) (getTileAt tiles column (fst positionUpdate)) tiles

addEmptyTiles: List Int -> Int -> Board -> Board
addEmptyTiles rows column tiles =
    List.foldl (\index board -> set (loc column index) Empty board) tiles rows

applyRowGravity: Board -> Board
applyRowGravity tiles = 
    let filledPositions = nonEmptyRows tiles
    in
        zip filledPositions [0..boardSize - 1]
            |> updateRows tiles
            |> addEmptyColumns [(List.length filledPositions)..boardSize - 1]

updateRows: Board -> List (Int, Int) -> Board
updateRows board positionPairs =
    List.foldl updateRowPosition board positionPairs

updateRowPosition: (Int, Int) -> Board -> Board
updateRowPosition positionUpdate board =
    List.foldr (copyPosition positionUpdate) board [0..boardSize - 1]

copyPosition: (Int, Int) -> Int -> Board -> Board
copyPosition positionUpdate row board =
    set (loc (snd positionUpdate) row) (getTileAt board (fst positionUpdate) row) board

nonEmptyRows: Board -> List Int
nonEmptyRows tiles =
    List.filter (\index -> (getTileAt tiles index (boardSize - 1)) /= Empty) [0..boardSize - 1]

addEmptyColumns: List Int -> Board -> Board
addEmptyColumns columns board =
    List.foldl setEmptyColumn board columns

setEmptyColumn: Int -> Board -> Board
setEmptyColumn column board =
    List.foldr (\index newBoard -> set (loc column index) Empty newBoard) board [0..boardSize - 1]

{-| The zip function takes in two lists and returns a combined
list. It combines the elements of each list pairwise until one
of the lists runs out of elements.

    zip [1,2,3] ['a','b','c'] == [(1,'a'), (2,'b'), (3,'c')]

-}   
zip : List a -> List b -> List (a,b)
zip xs ys = List.map2 (,) xs ys



