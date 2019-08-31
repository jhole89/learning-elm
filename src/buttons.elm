module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- Model


type alias Model =
    Int


init : Model
init =
    0



-- Update


type Msg
    = Increment
    | Decrement
    | Reset


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1

        Reset ->
            0



-- View


view : Model -> Html Msg
view model =
    div []
        [ div [] [ text (String.fromInt model) ]
        , button [ onClick Decrement ] [ text "-" ]
        , button [ onClick Reset ] [ text "Reset" ]
        , button [ onClick Increment ] [ text "+" ]
        ]
