module BoardUi exposing (boardHtml)

import BaseUi exposing (toRgbaString, centeredStyle, htmlFromAttributes)
import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes
import Color exposing (Color, rgb, rgba)

import GameState exposing (InGameState)
import Board exposing (boardSize)
import Tile exposing (Tile (..))
import Action exposing (Action (..))

import List exposing (..)
import Matrix exposing (..)

boardHtml : InGameState -> Html Action
boardHtml inGameState =
  div
    [boardStyle]
    [ div [playerTurnStyle] [text ("Player " ++ toString inGameState.playerTurn ++ "'s turn")]
    , div [scoreStyle] [text (playersText inGameState)]
    , div [] (List.map htmlFromAttributes (stylesFromTiles inGameState.board))]

stylesFromTiles : Matrix Tile -> List (List (Html.Attribute Action))
stylesFromTiles tiles =
    flatten (mapWithLocation getTileAttributes tiles)

getTileAttributes: Location -> Tile -> List (Html.Attribute Action)
getTileAttributes location tile =
    [Html.Attributes.style (tileStyle tile (row location) (col location)),
    Html.Events.onClick (Choose (row location) (col location))]

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
        Tile.Empty -> rgba 0 0 0 0.5

boardStyle : Html.Attribute msg
boardStyle = centeredStyle gridSizeInPx gridSizeInPx

scoreStyle : Html.Attribute msg
scoreStyle = Html.Attributes.style (scoreStyleList 350)

scoreStyleList : Int -> List (String, String)
scoreStyleList width =
  [("position", "relative")
  , ("margin-left", toString (width // 2) ++ "px")
  ]

tileStyle: Tile -> Int -> Int -> List (String, String)
tileStyle tile x y =
  tileStyleList tileSizeInPx (tileSizeInPx * y) (tileSizeInPx * x) (tileColor tile)

tileStyleList : Int -> Int -> Int -> Color -> List (String, String)
tileStyleList size marginTop marginLeft color =
  [("position", "absolute")
  , ("width", toString size ++ "px")
  , ("height", toString size ++ "px")
  , ("marginTop", toString marginTop ++ "px")
  , ("marginLeft", toString marginLeft ++ "px")
  , ("backgroundColor", toRgbaString color)
  ]

playerTurnStyle : Html.Attribute msg
playerTurnStyle = Html.Attributes.style (playerTurnStyleList 400)

playerTurnStyleList : Int -> List (String, String)
playerTurnStyleList width =
  [("position", "relative")
  , ("margin-left", toString (width // 2) ++ "px")
  ]

playersText: InGameState -> String
playersText gameState =
    "Player 1: " ++ toString gameState.player1.points ++ " - Player2: " ++ toString gameState.player2.points
