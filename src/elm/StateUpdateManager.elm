module StateUpdateManager exposing (updateState)

import GameState exposing (GameState, ScreenState(..), InGameState)
import Action exposing (Action (..))
import MenuManager exposing (updateMenu)
import TouchManager exposing (onTouchReceived)
import BoardGenerator exposing (initialInGameState)

updateState : Action -> GameState -> GameState
updateState action gameState =
  case gameState.screenState of
        InGame inGameState -> updateInGameState action gameState inGameState
        Menu menuState -> updateMenu action gameState

updateInGameState : Action -> GameState -> InGameState -> GameState
updateInGameState action gameState inGameState =
    case action of
        Choose x y -> { gameState | screenState = onTouchReceived inGameState x y }
        StartGame -> initialInGameState gameState -- Shouldn't happen
