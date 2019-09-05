import Browser
import Html exposing (Html, Attribute, span, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
  Browser.sandbox { init = init, update = update, view = view }

type alias Model =
  { input : String
  }


init : Model
init =
  { input = "" }

type Msg
  = Change String


update : Msg -> Model -> Model
update msg model =
  case msg of
    Change newInput ->
      { model | input = newInput }

view : Model -> Html Msg
view model =
  case String.toFloat model.input of
    Just celsius ->
      viewConverter model.input "black" "blue" (String.fromFloat (celsius * 1.8 + 32))

    Nothing ->
      viewConverter model.input "red" "red" "???"


viewConverter : String -> String -> String -> String -> Html Msg
viewConverter userInput outlineColor highlightColor equivalentTemp =
  span []
    [ input [ value userInput, onInput Change, style "width" "40px", style "border-color" outlineColor ] []
    , text "°C = "
    , span [ style "color" highlightColor ] [ text equivalentTemp ]
    , text "°F"
    ]
