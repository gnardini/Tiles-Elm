module GameState exposing (..)

import Board exposing (Board)
import Player exposing (Player)

import Random exposing (..)

type ScreenState = InGame InGameState | Menu MenuState

type alias GameState =
  { screenState: ScreenState
  , seed: Seed
  }

type alias InGameState =
  { board: Board
  , player1: Player
  , player2: Player
  , playerTurn: Int
  }

type alias MenuState =
  { text: String
  , winner: Maybe String
  }
