module Main exposing (Model, Msg(..), init, main, subs, update, view)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)
import Task
import Time


main =
    Browser.element { init = init, update = update, subscriptions = subs, view = view }


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    , run : Bool
    }


type Msg
    = Tick Time.Posix
    | AdjustTimeZone Time.Zone
    | Pause


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc (Time.millisToPosix 0) True
    , Task.perform AdjustTimeZone Time.here
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | time = newTime }
            , Cmd.none
            )

        AdjustTimeZone newZone ->
            ( { model | zone = newZone }
            , Cmd.none
            )

        Pause ->
            ( { model | run = False }
            , Cmd.none
            )


subs : Model -> Sub Msg
subs model =
    if model.run then
        Time.every 1000 Tick

    else
        Sub.none


view : Model -> Html Msg
view model =
    let
        hour =
            String.fromInt (Time.toHour model.zone model.time)

        minute =
            String.fromInt (Time.toMinute model.zone model.time)

        second =
            String.fromInt (Time.toSecond model.zone model.time)
    in
    div []
        [ h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
        , br [] []
        , button [ onClick Pause ] [ text "Pause" ]
        ]
