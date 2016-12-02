module BoardGravity exposing (applyGravityToTiles)

import Board exposing (Board, boardSize, boardTiles, getTileAt, unwrapTile)
import Tile exposing (Tile (..))
import Player exposing (Player)
import GameState exposing (ScreenState (..), InGameState)

import Array exposing (fromList)
import Matrix exposing (..)

-- These functions apply gravity. First they push all tiles to empty tiles below them, and after
-- that, if there's an empty column, they push the non-empty ones to the left (so that there are
-- no empty columns in between).

applyGravityToTiles: InGameState -> InGameState
applyGravityToTiles gameState =
    {gameState | board =
        gameState.board
            |> applyColumnGravity
            |> applyRowGravity}

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


-- Convinience function to use on Lists.

{-| The zip function takes in two lists and returns a combined
list. It combines the elements of each list pairwise until one
of the lists runs out of elements.

    zip [1,2,3] ['a','b','c'] == [(1,'a'), (2,'b'), (3,'c')]

-}
zip : List a -> List b -> List (a,b)
zip xs ys = List.map2 (,) xs ys
