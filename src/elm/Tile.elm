module Tile exposing (..)

import Random exposing (..)

type Tile = Red | Blue | Green | Yellow | Empty

colorsCount: Int
colorsCount = 4

-- Creates a Tile of a random color. It uses at most |maxColors| colors. If |maxColors| is
-- larger than the amount of colors available, the number is calculated modulo the number
-- of colors available
intToTile: Int -> Tile
intToTile colorIndex =
    case (colorIndex % colorsCount) of
        0 -> Red
        1 -> Blue
        2 -> Green
        3 -> Yellow
        otherwise -> Red
