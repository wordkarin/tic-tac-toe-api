# Tic-Tac-Toe API
API server back-end for Backbone.js Tic-Tac-Toe apps created as part of the [Ada Developers Academy](http://adadevelopersacademy.org/) curriculum.

## API Specification
The Tic-Tac-Toe API is responsible for tracking a history of played games. Each game is recorded on the server with its final game board (the location of each X or O on the board), the game outcome (win or draw), the date when the game was completed, and the names of the participants.

### Overview
The API communicates solely through JSON-encoded messages and provides four routes for working with `Game` data:

* [List all games](#list-all-games) - Retrieves an index of all recorded `Game`s. Each entry in the response array is a summary of the games (it does not include the final game board).
* [Game details](#game-details) - Retrieves the complete details of a single `Game`, including the final game board.
* [Create a game](#create-a-game) - Records a new, completed `Game`. Details of the game ([as specified below](#game)) must be sent as a JSON-encoded document.
* [Delete a game](#delete-a-game) - Removes a previously recorded `Game` from the API.

### JSON Schema
#### Game
This API only has a single model, `Game`, with the following properties:

* `id` - A positive integer that uniquely identifies the game within this API. **NOTE**: When `POST`ing a new game to the API this property is ignored if it was supplied.
* `board` - An array of strings, exactly 9 elements long. Each string within the array is either `"X"`, `"O"`, or `" "` (blank) and corresponds to the contents of a specific cell on the game board. The array is two dimensional in row-major order ([see diagram below](#game-board) for clarification).
* `players` - An array of strings, exactly 2 elements long. Each string corresponds to the name of a single player for this game. The first element is always the player represented by X on the board, and the second element is always the player represented by O on the board. **NOTE**: The second player's name is strictly optional, and will default to `"Anonymous"` if unspecified when `POST`ing a new game to the API.
* `outcome` - A string representing the result of the game. The only valid values are `"X"` (for X winning), `"O"` (for O winning), and `"draw"` (for a tie).
* `played_at` - A date & time representing when the game was completed and recorded by the API. Because JSON does not have a built-in date datatype this property is encoded as a string using the [ISO 8601 format](https://en.wikipedia.org/wiki/ISO_8601). **NOTE**: This property is optional when `POST`ing a new game to the API. The server will use the current date & time if one is not provided.

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


##### Game Board
The array of strings for `board` in the `Game` model is mapped to locations on the Tic-Tac-Toe game board using zero indexing:

|   |   |   |
|:-:|:-:|:-:|
| 0 | 1 | 2 |
| 3 | 4 | 5 |
| 6 | 7 | 8 |

#### Error
When a request is made to the API that results in an error with user-meaningful details, those details will be communicated in the response data using the following form:
```json
{
  "errors": [
    "Error message 1",
    "Error message 2",
    ...
    "Error message N"
  ]
}
```

### API Reference
This is a complete reference to the Tic-Tac-Toe API version 1. All request and response data must be encoded in JSON.

#### List all games
`GET /api/v1/games`

##### Request
###### Parameters
None.

###### Data
None.

##### Response
###### Status code
The status code for a successful request will be `200`.

###### Data
A list of [`Game`](#game) objects. Each `Game` object will only have the "summary" information for that game, meaning it will not include the `board` property.

##### Errors
The following status codes may be returned in the event of an error:
* `500` in the event of an unexpected server error.


#### Game details
`GET /api/v1/games/{game_id}`

##### Request
###### Parameters
The ID of an existing game. This value must be acquired by first requesting a list of games and using one of the IDs from within that list.

###### Data
None.

##### Response
###### Status code
The status code for a successful request will be `200`.

###### Data
A single [`Game`](#game) object. This object has the complete details for the game, including the `board` property.

##### Errors
The following status codes may be returned in the event of an error:
* `404` when the requested `Game` is not found.
* `500` in the event of an unexpected server error.


#### Create a game
`POST /api/v1/games`

##### Request
###### Parameters
None.

###### Data
A single [`Game`](#game) object, without the `id` property.

##### Response
###### Status code
The status code for a successful request will be `201`.

###### Data
None.

##### Errors
The following status codes may be returned in the event of an error:
* `400` when the provided `Game` properties are invalid. The response data will be an [`Error`](#error) object with strings for each failed validation.
* `500` when the `Game` was not saved due to an unexpected server error.


#### Delete a game
`DELETE /api/v1/games/{game_id}`

##### Request
###### Parameters
The ID of an existing game. This value must be acquired by first requesting a list of games and using one of the IDs from within that list.

###### Data
None.

##### Response
###### Status code
The status code for a successful request will be `204`.

###### Data
None.

##### Errors
The following status codes may be returned in the event of an error:
* `404` when the requested `Game` is not found.
* `500` in the event of an unexpected server error.


## Development
### Setup
1. Fork and clone this repository to your own account
1. Run `bundle install` to download gem dependencies
  * If you do not have Postgres installed on your development machine, run `bundle install --without production` instead.
1. Run `rails server` to start the development server.
1. Run `rails console` to access a REPL running in the Rails context.

### Tests
Run `rails test` to run the full test suite.

### Deployment
This API can be deployed to [Heroku](https://heroku.com/) with the following commands (assuming you have the [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) installed):
```bash
$ heroku create
$ heroku run bundle exec rails db:schema:load
$ heroku open
```

The last command will open a browser window with your API endpoint as the URL. This API is not designed to be meaningful to people accessing it via the browser, but it does give you the correct hostname to use when integrating your deployed instance into other applications.
