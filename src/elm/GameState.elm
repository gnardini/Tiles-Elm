module GameState exposing (..)

import Board exposing (Board)
import Player exposing (Player)

import Random exposing (..)

type GameState = InGame InGameState | Menu MenuState

type alias InGameState = {
    board: Board,
    player1: Player,
    player2: Player,
    playerTurn: Int,
    seed: Seed
}

type alias MenuState = {
    text: String,
    winner: Maybe String
}
