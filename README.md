# Tic-Tac-Toe API
API server back-end for Backbone.js Tic-Tac-Toe apps created as part of the [Ada Developers Academy](http://adadevelopersacademy.org/) curriculum.

## API Specification
The Tic-Tac-Toe API is responsible for tracking a history of played games. Each game is recorded on the server with its final game board (the location of each X or O on the board), the game outcome (win or draw), the date when the game was completed, and the names of the participants.

### Overview
The API communicates solely through JSON-encoded messages and provides four routes for working with `Game` data:

* `GET /api/v1/games/` - Retrieves an index of all recorded `Game`s. Each entry in the response array is a summary of the games (it does not include the final game board).
* `GET /api/v1/games/:id` - Retrieves the complete details of a single `Game`, including the final game board.
* `POST /api/v1/games/` - Records a new, completed `Game`. Details of the game (as specified below) must be sent as a JSON-encoded document.
* `DELETE /api/v1/games/:id` - Removes a previously recorded `Game` from the API.

### Data Model
This API only has a single model, `Game`, with the following fields:

* `id` - A positive integer that uniquely identifies the game within this API. **NOTE**: When `POST`ing a new game to the API this property is ignored if it was supplied.
* `board` - An array of strings, exactly 9 elements long. Each string within the array is either `"X"`, `"O"`, or `" "` (blank) and corresponds to the contents of a specific cell on the game board. The array is two dimensional in row-major order (see diagram below for clarification).
* `players` - An array of strings, exactly 2 elements long. Each string corresponds to the name of a single player for this game. The first element is always the player represented by X on the board, and the second element is always the player represented by O on the board. **NOTE**: The second player's name is strictly optional, and will default to `"Anonymous"` if unspecified when `POST`ing a new game to the API.
* `outcome` - A string representing the result of the game. The only valid values are `"X"` (for X winning), `"O"` (for O winning), and `"draw"` (for a tie).
* `played_at` - A date representing when the game was completed and recorded by the API. Because JSON does not have a built-in date datatype this property is encoded as a string using the [ISO 8601 format](https://en.wikipedia.org/wiki/ISO_8601). **NOTE**: This property is optional when `POST`ing a new game to the API, and the server will supply a date for the game if one is not provided.

An example of a complete `Game` model encoded in JSON:
```json
{
  "id": 1,
  "board": [
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
  "players": [
    "X Player",
    "O Player"
  ],
  "outcome": "X",
  "played_at": "2016-11-20T22:59:10Z"
}
```

This data corresponds to the following final game board between two players, `X Player` and `O Player`:

|   |   |   |
|:-:|:-:|:-:|
| X |   | O |
| X | O |   |
| X |   |   |


#### Game Board
The array of strings for `board` in the `Game` model is mapped to locations on the Tic-Tac-Toe game board thusly (using zero indexing):

|   |   |   |
|:-:|:-:|:-:|
| 0 | 1 | 2 |
| 3 | 4 | 5 |
| 6 | 7 | 8 |
