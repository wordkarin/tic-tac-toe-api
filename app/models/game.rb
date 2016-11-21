class Game < ApplicationRecord

  validate :data_must_match_schema

  # Almost all of the data for a game is stored in a
  # JSON-encoded string field called `json_data`.

  # We interact with that field through the attribute
  # `data`.
  def data
    JSON.parse(read_attribute(:json_data) || "{}")
  end

  def data=(data)
    write_attribute(:json_data, (data || {}).to_json)
  end


  # Check out https://spacetelescope.github.io/understanding-json-schema/
  # for schema definition details.
  DATA_SCHEMA = {
    definitions: {
      board_cell: {
        type: :string,
        enum: ["X", "O", " "]
      },
      player_name: {
        type: :string,
        minLength: 1
      },
      outcome: {
        type: :string,
        enum: ["X", "O", "draw"]
      },
      played_date: {
        type: :string,
        format: "date-time"
      }
    },


    type: :object,
    additionalProperties: false,
    title: "Game",
    properties: {
      board: {
        type: :list,
        items: { "$ref": "#/definitions/board_cell" },
        minItems: 9,
        maxItems: 9
      },
      players: {
        type: :list,
        items: { "$ref": "#/definitions/player_name" },
        minItems: 1,
        maxItems: 2
      },
      outcome: {
        "$ref": "#/definitions/outcome"
      },
      played_at: {
        "$ref": "#/definitions/played_date"
      }
    },
    required: [:board, :players, :outcome]
  }

  def data_must_match_schema
    if !JSON::Validator.validate(DATA_SCHEMA, self.data)
      errors.add(:data, "has incorrect schema")
    end
  end

  private

  # Make the `json_data` field (mostly) inaccessible
  def json_data; end
  def json_data=; end
end
