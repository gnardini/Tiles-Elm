port module App exposing (..)

import MenuUi exposing (menuHtml)
import BoardUi exposing (boardHtml)

import GameState exposing (..)
import Action exposing (Action (..))
import MenuManager exposing (initialMenuState, updateMenu)
import StateUpdateManager exposing (updateState)

import Html exposing (Html)
import Html.App
import Random exposing (initialSeed, minInt, maxInt)

type alias Flags =
    { startingSeed: Float
    }

init : (GameState, Cmd Action)
init = (
    { screenState = initialMenuState
    , seed = initialSeed (round 1234)
    }, Random.generate InitialSeed (Random.int minInt maxInt))

view : GameState -> Html Action
view gameState =
    case gameState.screenState of
        InGame inGameState -> BoardUi.boardHtml inGameState
        Menu menuState -> MenuUi.menuHtml menuState

update : Action -> GameState -> (GameState, Cmd Action)
update action gameState =
    case action of
        InitialSeed seed -> ({ gameState | seed = initialSeed seed }, Cmd.none)
        otherwise -> (updateState action gameState, Cmd.none)

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
