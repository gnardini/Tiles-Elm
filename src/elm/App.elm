module App exposing (..)

import MenuUi exposing (menuHtml)
import BoardUi exposing (boardHtml)

import GameState exposing (..)
import Action exposing (Action (..))

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
update action gameState =
    case gameState of
        InGame inGameState -> updateInGameBoard action inGameState
        Menu menuState -> updateMenu action menuState

updateInGameBoard : Action -> InGameState -> (GameState, Cmd Action)
updateInGameBoard action inGameState =
    case action of
        Choose x y -> (onTouchReceived inGameState x y
            |> applyGravityToTiles
            |> checkGameOver
            , Cmd.none)
        StartGame -> (initialInGameState, Cmd.none)

updateMenu : Action -> MenuState -> (GameState, Cmd Action)
updateMenu action menu =
    case action of
        Choose _ _ -> (initialMenuState, Cmd.none)
        StartGame -> (initialInGameState, Cmd.none)

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
