module MenuUi exposing(menuHtml)

import BaseUi exposing (toRgbaString, centeredStyle)
import Action exposing (Action (..), MenuAction (..))
import GameState exposing (MenuState)

import Color exposing (rgb)

import Html exposing (Html, div, text)
import Html.Events exposing (onClick)
import Html.Attributes

import List exposing (..)

menuButtonWidth = 300
menuButtonHeight = 100

menuHtml : MenuState -> Html Action
menuHtml menuState =
    Html.div
    [menuStyle, Html.Events.onClick (MenuAction StartGame)]
    [div [winnerTextStyle] [text (winnerText menuState.winner)]
    , div [playButtonStyle] [text menuState.text]]

winnerText : Maybe String -> String
winnerText maybeWinner =
  case maybeWinner of
    Nothing -> ""
    Just winner -> winner

menuStyle : Html.Attribute msg
menuStyle = centeredStyle menuButtonWidth menuButtonHeight

playButtonStyle : Html.Attribute msg
playButtonStyle = Html.Attributes.style menuButtonStyle

menuButtonStyle : List (String, String)
menuButtonStyle =
  [("position", "relative")
  , ("width", toString menuButtonWidth ++ "px")
  , ("height", toString menuButtonHeight ++ "px")
  , ("text-transform", "uppercase")
  , ("font-size", "30px")
  , ("color", toRgbaString (rgb 255 255 255))
  , ("backgroundColor", toRgbaString (rgb 0 255 0))
  , ("display", "flex")
  , ("align-items", "center")
  , ("justify-content", "center")
  ]

winnerTextStyle : Html.Attribute msg
winnerTextStyle =
  Html.Attributes.style
    [("position", "relative")
    , ("font-size", "25px")
    , ("margin-bottom", "15px")
    , ("display", "flex")
    , ("align-items", "center")
    , ("justify-content", "center")
    ]
