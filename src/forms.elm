module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Char exposing (isDigit, isLower, isUpper)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import String


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Valid =
    Maybe Bool


type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , valid : Valid
    }


init : Model
init =
    Model "" "" "" "" Nothing


type Msg
    = Name String
    | Age String
    | Password String
    | PasswordAgain String
    | Validate


update : Msg -> Model -> Model
update msg model =
    case msg of
        Name name ->
            { model | name = name }

        Age age ->
            { model | age = age }

        Password password ->
            { model | password = password }

        PasswordAgain passwordAgain ->
            { model | passwordAgain = passwordAgain }

        Validate ->
            { model | valid = validate model }


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "text" "Age" model.age Age
        , viewInput "text" "Password" model.password Password
        , viewInput "text" "Re-enter Password" model.passwordAgain PasswordAgain
        , button [ onClick Validate ] [ text "Submit" ]
        , viewValidation model.valid
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


validate : Model -> Valid
validate model =
    if String.length model.password < 9 then
        Just False

    else if not (String.any isDigit model.password) then
        Just False

    else if not (String.any isLower model.password) then
        Just False

    else if not (String.any isUpper model.password) then
        Just False

    else if not (String.all isDigit model.age) then
        Just False

    else if model.password /= model.passwordAgain then
        Just False

    else
        Just True


viewValidation : Valid -> Html msg
viewValidation valid =
    case valid of
        Nothing ->
            div [ style "color" "black" ] [ text "Enter details" ]

        Just True ->
            div [ style "color" "green" ] [ text "OK" ]

        Just False ->
            div [ style "color" "red" ] [ text "Error" ]
