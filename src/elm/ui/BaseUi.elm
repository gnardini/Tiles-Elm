module BaseUi exposing (toRgbaString, centeredStyle, centeredStyleList, htmlFromAttributes)

import Color exposing (Color, toRgb)

import Html exposing (Html)
import Html.Attributes

import List exposing (..)

toRgbaString : Color -> String
toRgbaString color =
  let { red, green, blue, alpha } = Color.toRgb color
  in
      "rgba(" ++ toString red ++ ", " ++ toString green ++ ", " ++ toString blue ++ ", " ++ toString alpha ++ ")"

centeredStyle : Int -> Int -> Html.Attribute msg
centeredStyle width height = Html.Attributes.style (centeredStyleList width height)

centeredStyleList : Int -> Int -> List (String, String)
centeredStyleList width height =
    [("position", "fixed")
    , ("top", "50%")
    , ("left", "50%")
    , ("margin-top", toString (-height // 2) ++ "px")
    , ("margin-left", toString (-width // 2) ++ "px")
    ]

htmlFromAttributes: List (Html.Attribute msg) -> Html msg
htmlFromAttributes attributes =
        Html.div
            attributes
            [ ]
