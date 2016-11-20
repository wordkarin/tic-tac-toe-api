class Game < ApplicationRecord

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

  private

  # Make the `json_data` field (mostly) inaccessible
  def json_data; end
  def json_data=; end
end
