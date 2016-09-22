module App exposing (..)

import MenuUi exposing (menuHtml)
import BoardUi exposing (boardHtml)

import GameState exposing (..)
import Action exposing (Action (..))
import BoardGenerator exposing (initialInGameState)
import MenuManager exposing (initialMenuState, updateMenu)
import StateUpdateManager exposing (updateState)

import Html exposing (Html)
import Html.App

init : (GameState, Cmd Action)
init = (initialMenuState, Cmd.none)

view : GameState -> Html Action
view gameState =
    case gameState of
        InGame inGameState -> BoardUi.boardHtml inGameState
        Menu menuState -> MenuUi.menuHtml menuState

update : Action -> GameState -> (GameState, Cmd Action)
update action gameState = (updateState action gameState, Cmd.none)

subscriptions : GameState -> Sub Action
subscriptions model =
    Sub.none

main : Program Never
main =
    Html.App.program {
        init = init,
        view = view,
        update = update,
        subscriptions = subscriptions
    }
