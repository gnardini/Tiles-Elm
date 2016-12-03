module Action exposing (..)

type MenuAction = StartGame
type GameAction = Choose Int Int | Hover Int Int | Unhover

type Action = GameAction GameAction | MenuAction MenuAction
