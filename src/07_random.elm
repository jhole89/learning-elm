module Main exposing (Model, Msg(..), init, main, subs, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random


main =
    Browser.element { init = init, update = update, subscriptions = subs, view = view }


type alias Model =
    { dieFace : Int }


type Msg
    = Roll
    | NewFace Int


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace (Random.int 1 6)
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )


subs : Model -> Sub Msg
subs _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (String.fromInt model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
