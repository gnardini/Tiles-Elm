module Player where

type PlayerType = Human | AI

type alias Player = {
    playerType: PlayerType,
    points: Int
}