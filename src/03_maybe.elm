module Main exposing (Model, Msg(..), init, main, update, view, viewConverter)

import Browser
import Html exposing (Attribute, Html, br, div, input, span, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Input =
    String


type alias Model =
    { input : String
    }


init : Model
init =
    Model ""


type Msg
    = Change String


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newInput ->
            { model | input = newInput }


view : Model -> Html Msg
view model =
    div []
        [ converter model.input celsiusToFahrenheit "°C" "°F"
        , br [] []
        , converter model.input fahrenheitToCelsius "°F" "°C"
        , br [] []
        , converter model.input inchesToMetres "\"" "m"
        , br [] []
        ]


converter : String -> (Float -> Float) -> String -> String -> Html Msg
converter reading calculation inputMeasure outputMeasure =
    case String.toFloat reading of
        Just float ->
            viewConverter reading "black" inputMeasure "blue" (String.fromFloat (calculation float)) outputMeasure

        Nothing ->
            viewConverter reading "red" inputMeasure "red" "???" outputMeasure


viewConverter : String -> String -> String -> String -> String -> String -> Html Msg
viewConverter userInput outlineColor inputMeasure highlightColor equivalentMeasure outputMeasure =
    span []
        [ input [ value userInput, onInput Change, style "width" "40px", style "border-color" outlineColor ] []
        , text (inputMeasure ++ " = ")
        , span [ style "color" highlightColor ] [ text equivalentMeasure ]
        , text outputMeasure
        ]


celsiusToFahrenheit : Float -> Float
celsiusToFahrenheit celsius =
    (celsius * 1.8) + 32


fahrenheitToCelsius : Float -> Float
fahrenheitToCelsius fahrenheit =
    (fahrenheit - 32) * 5 / 9


inchesToMetres : Float -> Float
inchesToMetres inch =
    inch / 39.37
