module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Time


type alias Model =
    { sollZeit : Int
    , istZeit : Maybe Int
    , running : Bool
    }


type Msg
    = Start
    | Stop
    | SollZeit Int
    | Tick Time.Posix


punkte : Int -> Int -> Int
punkte sollZeit istZeit =
    if istZeit > sollZeit then
        0

    else
        let
            diff =
                sollZeit - istZeit |> toFloat |> abs

            prozent =
                100 - 100 * diff / toFloat sollZeit
        in
        prozent |> round


init : () -> ( Model, Cmd Msg )
init _ =
    ( { sollZeit = 15
      , istZeit = Nothing
      , running = False
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | running = True, istZeit = Just 0 }
            , Random.generate SollZeit (Random.int 10 20)
            )

        Stop ->
            ( { model | running = False }, Cmd.none )

        SollZeit zeit ->
            ( { model | sollZeit = zeit }, Cmd.none )

        Tick _ ->
            case model.istZeit of
                Nothing ->
                    ( model, Cmd.none )

                Just zeit ->
                    ( { model | istZeit = Just (zeit + 1) }, Cmd.none )


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
                case model.istZeit of
                    Nothing ->
                        text "Drücke den Start-Button"

                    Just zeit ->
                        "Du hast nach "
                            ++ String.fromInt zeit
                            ++ " Sekunden gestoppt"
                            ++ " und hast "
                            ++ String.fromInt (punkte model.sollZeit zeit)
                            ++ " Punkte erreicht"
                            |> text
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
