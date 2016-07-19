module GameState where

import Board exposing (..)

import List exposing (..)

type alias GameState = {
    board: Board,
    player1: Player,
    player2: Player,
    playerTurn: Int
}