module Main exposing (Model, Msg(..), init, main, update, view, viewInput, viewValidation)

import Browser
import Char exposing (isDigit, isLower, isUpper)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import List exposing (filterMap, isEmpty)
import String


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias ValidationError =
    String


type alias ValidationErrors =
    List ValidationError


type alias Model =
    { name : String
    , age : String
    , password : String
    , passwordAgain : String
    , errors : Maybe ValidationErrors
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
            { model | errors = Just (validate model) }


validate : Model -> ValidationErrors
validate model =
    filterMap (\n -> n model)
        [ validateAge
        , validatePasswordLength
        , validatePasswordContainsUpper
        , validatePasswordContainsLower
        , validatePasswordContainsDigit
        , validatePasswordMatch
        ]


validateAge : Model -> Maybe ValidationError
validateAge model =
    case String.toInt model.age of
        Just int ->
            if int > 0 then
                Nothing

            else
                Just "Age must be greater than zero"

        Nothing ->
            Just "Age must be a number"


validatePasswordLength : Model -> Maybe ValidationError
validatePasswordLength model =
    if String.length model.password < 9 then
        Just "Password must contain more than 8 characters"

    else
        Nothing


validatePasswordContainsDigit : Model -> Maybe ValidationError
validatePasswordContainsDigit model =
    if String.any isDigit model.password then
        Nothing

    else
        Just "Password must contain at least one number"


validatePasswordContainsLower : Model -> Maybe ValidationError
validatePasswordContainsLower model =
    if String.any isLower model.password then
        Nothing

    else
        Just "Password must contain at least one lowercase character"


validatePasswordContainsUpper : Model -> Maybe ValidationError
validatePasswordContainsUpper model =
    if String.any isUpper model.password then
        Nothing

    else
        Just "Password must contain at least one uppercase character"


validatePasswordMatch : Model -> Maybe ValidationError
validatePasswordMatch model =
    if model.password == model.passwordAgain then
        Nothing

    else
        Just "Passwords do not match"


view : Model -> Html Msg
view model =
    div []
        [ viewInput "text" "Name" model.name Name
        , viewInput "text" "Age" model.age Age
        , viewInput "text" "Password" model.password Password
        , viewInput "text" "Re-enter Password" model.passwordAgain PasswordAgain
        , button [ onClick Validate ] [ text "Submit" ]
        , viewValidation model.errors
        ]


viewInput : String -> String -> String -> (String -> msg) -> Html msg
viewInput t p v toMsg =
    input [ type_ t, placeholder p, value v, onInput toMsg ] []


viewValidation : Maybe ValidationErrors -> Html a
viewValidation someErrors =
    case someErrors of
        Nothing ->
            viewEmpty

        Just errors ->
            if isEmpty errors then
                viewSuccess

            else
                viewErrors errors


viewEmpty : Html a
viewEmpty =
    div [ style "color" "black" ] [ text "Enter details" ]


viewSuccess : Html a
viewSuccess =
    div [ style "color" "green" ] [ text "OK" ]


viewErrors : ValidationErrors -> Html a
viewErrors errors =
    ul [ class "errors" ] (List.map viewError errors)


viewError : ValidationError -> Html a
viewError error =
    li [ style "color" "red" ] [ text error ]
