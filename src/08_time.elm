import Browser
import Html exposing (..)
import Time
import Task


main = Browser.element { init = init, update = update, subscriptions = subs, view = view }


type alias Model =
    { zone : Time.Zone
    , time : Time.Posix
    }

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone

init : () -> ( Model, Cmd Msg )
init _ =
    ( Model Time.utc ( Time.millisToPosix 0 )
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

subs : Model -> Sub Msg
subs _ =
    Time.every 1000 Tick

view: Model -> Html Msg
view model =
    let
        hour = String.fromInt (Time.toHour model.zone model.time)
        minute = String.fromInt (Time.toMinute model.zone model.time)
        second = String.fromInt (Time.toSecond model.zone model.time)
    in
    h1 [] [ text (hour ++ ":" ++ minute ++ ":" ++ second) ]
