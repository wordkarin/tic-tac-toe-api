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

    factory :game_without_board do
      data complete_data.reject { |k,_| k == :board }
    end
    factory :game_without_players do
      data complete_data.reject { |k,_| k == :players }
    end
    factory :game_without_outcome do
      data complete_data.reject { |k,_| k == :outcome }
    end
  end
end
