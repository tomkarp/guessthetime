module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Time


type alias Model =
    { sollZeit : Int
    , istZeit : Int
    , running : Bool
    }


type Msg
    = Start
    | Stop
    | SollZeit Int
    | Tick Time.Posix


init : () -> ( Model, Cmd Msg )
init _ =
    ( { sollZeit = 15
      , istZeit = 0
      , running = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | running = True, istZeit = 0 }
            , Random.generate SollZeit (Random.int 10 20)
            )

        Stop ->
            ( { model | running = False }, Cmd.none )

        SollZeit zeit ->
            ( { model | sollZeit = zeit }, Cmd.none )

        Tick _ ->
            ( { model | istZeit = model.istZeit + 1 }, Cmd.none )


view : Model -> Html Msg
view model =
    div []
        [ if model.running then
            button [ onClick Stop ] [ text "Stop" ]

          else
            button [ onClick Start ] [ text "Start" ]
        , div []
            [ if model.running then
                text ("Stoppe nach " ++ String.fromInt model.sollZeit ++ " Sekunden")

              else
                text (String.fromInt model.istZeit)
            ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    if model.running then
        Time.every 1000 Tick

    else
        Sub.none


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
