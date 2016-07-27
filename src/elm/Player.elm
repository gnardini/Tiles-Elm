module Player exposing (..)

type PlayerType = Human | AI

type alias Player = {
    playerType: PlayerType,
    points: Int
}

createPlayer: Player
createPlayer = {
    playerType = Human,
    points = 0 }

addPoints: Player -> Int -> Player
addPoints player movementPoints = 
    {player | points = player.points + movementPoints}
