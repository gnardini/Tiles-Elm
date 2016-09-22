module StateUpdateManager exposing (updateState)

import GameState exposing (GameState(..), InGameState)
import Action exposing (Action (..))
import MenuManager exposing (updateMenu)
import TouchManager exposing (onTouchReceived)
import BoardGenerator exposing (initialInGameState)

updateState : Action -> GameState -> GameState
updateState action gameState =
  case gameState of
        InGame inGameState -> updateInGameState action inGameState
        Menu menuState -> updateMenu action menuState

updateInGameState : Action -> InGameState -> GameState
updateInGameState action inGameState =
    case action of
        Choose x y -> onTouchReceived inGameState x y
        StartGame -> initialInGameState -- Shouldn't happen
