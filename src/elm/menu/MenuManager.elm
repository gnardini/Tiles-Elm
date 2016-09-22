module MenuManager exposing (initialMenuState, updateMenu)

import GameState exposing (GameState (..), MenuState)
import Action exposing (Action (..))
import BoardGenerator exposing (initialInGameState)

initialMenuState : GameState
initialMenuState =
    Menu {
        text = "Play"
        , winner = Nothing
    }

updateMenu : Action -> MenuState -> GameState
updateMenu action menu =
    case action of
        Choose _ _ -> initialMenuState -- Shouldn't happen
        StartGame -> initialInGameState
