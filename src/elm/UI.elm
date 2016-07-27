module UI exposing (..)

import Board exposing (..)
import Tile exposing (..)

import Color exposing (..)

tileSizeInPx: Int
tileSizeInPx = 50

gridSizeInPx: Int
gridSizeInPx = boardSize * tileSizeInPx

tileColor: Tile -> Color
tileColor tile = 
    case tile of
        Red -> rgb 255 0 0
        Blue -> rgb 0 0 255
        Green -> rgb 0 255 0
        Yellow -> rgb 255 255 0
        Empty -> rgba 0 0 0 0.5

toRgbaString : Color -> String
toRgbaString color =
  let {red, green, blue, alpha} = Color.toRgb color
  in
      "rgba(" ++ toString red ++ ", " ++ toString green ++ ", " ++ toString blue ++ ", " ++ toString alpha ++ ")"
