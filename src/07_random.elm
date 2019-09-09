module Main exposing (Model, Msg(..), init, main, subs, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random


main =
    Browser.element { init = init, update = update, subscriptions = subs, view = view }


type alias Model =
    { dieFace1 : Int
    , dieFace2 : Int
    }


type Msg
    = Roll
    | NewFace ( Int, Int )


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model 1 1, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace roll
            )

        NewFace (newFace1, newFace2) ->
            ( Model newFace1 newFace2
            , Cmd.none
            )

roll : Random.Generator (Int, Int)
roll =
    Random.pair snakeEyes snakeEyes


snakeEyes : Random.Generator Int
snakeEyes =
  Random.weighted (50, 1) [ (10, 2), (10, 3), (10, 4), (10, 5), (10, 6) ]

subs : Model -> Sub Msg
subs _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text ((String.fromInt model.dieFace1) ++ " " ++  (String.fromInt model.dieFace2)) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]
