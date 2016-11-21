FactoryGirl.define do
  factory :game do
    constructs_with_attrs

    board [
      "X", " ", "O",
      "X", "O", " ",
      "X", " ", " ",
    ]
    players [
      "Player 1",
      "Player 2"
    ]
    outcome "X"
    played_at DateTime.now.utc
  end

  trait :constructs_with_attrs do
    initialize_with do
      Game.new(data: attributes)
    end
  end
end
