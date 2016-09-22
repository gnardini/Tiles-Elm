module App exposing (..)

import GameState exposing (..)
import Tile exposing (..)
import UI exposing (..)
import Player exposing (..)
import Action exposing (..)

import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes
import Html.App

import Matrix exposing (..)
import List exposing (..)

init : (GameState, Cmd Action)
init = (initialState, Cmd.none)

-- VIEW


view : GameState -> Html Action
view gameState =
    Html.div
        [boardAttributes]
        [ div [scoreAttributes] [text (playersText gameState)],
        div [] (List.map htmlFromAttributes (stylesFromTiles gameState.board))]

htmlFromAttributes: List (Html.Attribute Action) -> Html Action
htmlFromAttributes attributes =
        Html.div
            attributes
            [ ]

playersText: GameState -> String
playersText gameState =
    "Player 1: " ++ toString gameState.player1.points ++ " - Player2: " ++ toString gameState.player2.points

tileView: Tile -> Int -> Int -> List (String, String)
tileView tile x y =
    let
        left = tileSizeInPx * x
        top = tileSizeInPx * y
    in
        [("position", "absolute"),
        ("width", toString tileSizeInPx ++ "px"),
        ("height", toString tileSizeInPx ++ "px"),
        ("marginTop", toString top ++ "px"),
        ("marginLeft", toString left ++ "px"),
        ("backgroundColor", toRgbaString (tileColor tile))]

stylesFromTiles : Matrix Tile -> List (List (Html.Attribute Action))
stylesFromTiles tiles =
    flatten (mapWithLocation getTileAttributes tiles)


getTileAttributes: Location -> Tile -> List (Html.Attribute Action)
getTileAttributes location tile =
    [Html.Attributes.style (tileView tile (row location) (col location)),
    Html.Events.onClick (Choose (row location) (col location))]

-- UPDATE


update : Action -> GameState -> (GameState, Cmd Action)
update action gameState =
    case action of
        Choose x y -> (onTouchReceived gameState x y |> applyGravityToTiles, Cmd.none)



-- SUBSCRIPTIONS

subscriptions : GameState -> Sub Action
subscriptions model =
    Sub.none

-- MAIN


main : Program Never
main =
    Html.App.program {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }

