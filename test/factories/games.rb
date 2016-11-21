complete_data = {
  board: [
    "X",
    " ",
    "O",
    "X",
    "O",
    " ",
    "X",
    " ",
    " "
  ],
  players: [
    "Player 1",
    "Player 2"
  ],
  outcome: "X"
}

FactoryGirl.define do
  factory :game, aliases: [:game_complete] do
    data complete_data
  end
end
