class GameSerializer < ActiveModel::Serializer
  attribute :id

  Game::DATA_SCHEMA[:properties].keys.each do |attr|
    attribute attr, if: -> { object.data.has_key? attr.to_s } do
      object.data[attr.to_s]
    end
  end
end
