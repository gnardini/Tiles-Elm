module StateUpdateManager exposing (updateState)

import GameState exposing (GameState, ScreenState(..), InGameState)
import Action exposing (Action (..), GameAction (..))
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
      GameAction gameAction -> handleGameAction gameAction gameState inGameState
      otherwise -> initialInGameState gameState -- Shouldn't happen


handleGameAction: GameAction -> GameState -> InGameState -> GameState
handleGameAction action gameState inGameState =
  case action of
    Choose x y -> { gameState | screenState = onTouchReceived inGameState x y }
    Hover x y -> { gameState | screenState = InGame { inGameState | mouseOver = Just { x = x, y = y } } }
    Unhover -> { gameState | screenState = InGame { inGameState | mouseOver = Nothing } }
