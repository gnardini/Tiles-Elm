module MenuManager exposing (initialMenuState, updateMenu)

import GameState exposing (GameState, ScreenState (..), MenuState)
import Action exposing (Action (..))
import BoardGenerator exposing (initialInGameState)

initialMenuState : ScreenState
initialMenuState =
    Menu
    { text = "Play"
    , winner = Nothing
    }

updateMenu : Action -> GameState -> GameState
updateMenu action gameState =
    case action of
        Choose _ _ -> { gameState | screenState = initialMenuState } -- Shouldn't happen
        StartGame -> initialInGameState gameState
