module Main exposing (Model, Msg(..), init, main, subs, update, view)

import Browser
import Html exposing (Html, br, button, div, img, text)
import Html.Events exposing (..)
import Random
import Svg exposing (Svg, circle, rect, svg)
import Svg.Attributes exposing (..)


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

        NewFace ( newFace1, newFace2 ) ->
            ( Model newFace1 newFace2
            , Cmd.none
            )


roll : Random.Generator ( Int, Int )
roll =
    Random.pair snakeEyes snakeEyes


snakeEyes : Random.Generator Int
snakeEyes =
    Random.weighted ( 50, 1 ) [ ( 10, 2 ), ( 10, 3 ), ( 10, 4 ), ( 10, 5 ), ( 10, 6 ) ]


subs : Model -> Sub Msg
subs _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ drawFace model.dieFace1
        , drawFace model.dieFace2
        , br [] []
        , button [ onClick Roll ] [ text "Roll" ]
        ]


drawFace : Int -> Svg Msg
drawFace dieValue =
    svg
        [ width "120", height "120", viewBox "0 0 120 120", fill "white", stroke "black", strokeWidth "3" ]
        (List.append
            [ rect [ x "1", y "1", width "100", height "100", rx "15", ry "15" ] [] ]
            (drawValue dieValue)
        )


drawValue : Int -> List (Svg Msg)
drawValue dieValue =
    case dieValue of
        1 ->
            [ circle [ cx "50", cy "50", r "10", fill "black" ] [] ]

        2 ->
            [ circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            ]

        3 ->
            [ circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            ]

        4 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        5 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "50", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        6 ->
            [ circle [ cx "25", cy "25", r "10", fill "black" ] []
            , circle [ cx "25", cy "50", r "10", fill "black" ] []
            , circle [ cx "25", cy "75", r "10", fill "black" ] []
            , circle [ cx "75", cy "25", r "10", fill "black" ] []
            , circle [ cx "75", cy "50", r "10", fill "black" ] []
            , circle [ cx "75", cy "75", r "10", fill "black" ] []
            ]

        _ ->
            [ Svg.clipPath [ id "clipView" ]
                [ rect [ x "5", y "5", width "90", height "90", rx "15", ry "15" ] [] ]
            , img
                [ width "100", height "100", xlinkHref "https://images-na.ssl-images-amazon.com/images/I/613bUK4cUKL._SY355_.jpg", clipPath "url(#clipView)" ]
                []
            ]
