module Main exposing (Model(..), Msg(..), getRandomDogGif, gifDecoder, init, main, subs, update, view, viewGif)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode exposing (Decoder, field, string)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subs }


type Model
    = Failure
    | Loading
    | Success String


type Msg
    = MorePlease
    | GotGif (Result Http.Error String)


init : () -> ( Model, Cmd Msg )
init _ =
    ( Loading, getRandomDogGif )


getRandomDogGif : Cmd Msg
getRandomDogGif =
    Http.get
        { url = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=dog"
        , expect = Http.expectJson GotGif gifDecoder
        }


gifDecoder : Decoder String
gifDecoder =
    field "data" (field "image_url" string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg _ =
    case msg of
        MorePlease ->
            ( Loading, getRandomDogGif )

        GotGif result ->
            case result of
                Ok url ->
                    ( Success url, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )


subs : Model -> Sub Msg
subs _ =
    Sub.none


view : Model -> Html Msg
view model =
    div []
        [ h2 [] [ text "Random Dogs" ]
        , viewGif model
        ]


viewGif : Model -> Html Msg
viewGif model =
    case model of
        Failure ->
            div []
                [ text "Unable to load random dog gif. "
                , button [ onClick MorePlease ] [ text "Get Doggo!" ]
                ]

        Loading ->
            text "Loading..."

        Success url ->
            div []
                [ button [ onClick MorePlease, style "display" "block" ] [ text "Next Doggo" ]
                , img [ src url ] []
                ]
