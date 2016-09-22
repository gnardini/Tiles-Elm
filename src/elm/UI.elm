module UI exposing (..)

import Board exposing (..)
import Tile exposing (..)

import Color exposing (..)

import Html exposing (Html)
import Html.Attributes

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

boardAttributes : Html.Attribute msg
boardAttributes = centeredAttributes gridSizeInPx gridSizeInPx

centeredAttributes : Int -> Int -> Html.Attribute msg
centeredAttributes width height = Html.Attributes.style (centeredAttributesList width height)

centeredAttributesList : Int -> Int -> List (String, String)
centeredAttributesList width height =
    [("position", "fixed")
    , ("top", "50%")
    , ("left", "50%")
    , ("margin-top", toString (-height // 2) ++ "px")
    , ("margin-left", toString (-width // 2) ++ "px")
    ]

scoreAttributes : Html.Attribute msg
scoreAttributes = Html.Attributes.style (scoreAttributesList 350)

scoreAttributesList : Int -> List (String, String)
scoreAttributesList width =
  [("position", "relative")
  , ("margin-left", toString (width // 2) ++ "px")
  ]
