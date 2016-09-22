module Board exposing (Board, boardSize, boardTiles, getTileAt, unwrapTile)

import Tile exposing (Tile (..))

import Matrix exposing (..)

-- Location (Column, Row) -> 0 indexed, (0, 0) on top left
type alias Board = Matrix Tile

boardSize: Int
boardSize = 10

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
