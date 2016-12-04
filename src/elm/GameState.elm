module GameState exposing (..)

import Board exposing (Board)
import Player exposing (Player)

import Random exposing (..)

type ScreenState = InGame InGameState | Menu MenuState

type alias GameState =
  { screenState: ScreenState
  , seed: Seed
  }

type alias Coordinate =
  { x: Int
  , y: Int
  }

type alias InGameState =
  { board: Board
  , player1: Player
  , player2: Player
  , playerTurn: Int
  , mouseOver: Maybe Coordinate
  }

type alias MenuState =
  { text: String
  , winner: Maybe String
  }
