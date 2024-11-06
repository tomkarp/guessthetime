module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Time


type alias Model =
    { sollZeit : Int
    , istZeit : Int
    , minZeit : Int
    , maxZeit : Int
    , running : Bool
    }


type Msg
    = Start
    | NeueMinZeit Int
    | NeueMaxZeit Int
    | Stop
    | SollZeit Int
    | Tick Time.Posix


punkte : Int -> Int -> Int
punkte sollZeit istZeit =
    -- alternativ z.B.:
    -- sollZeit - istZeit |> abs
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
      , istZeit = 0
      , running = False
      , minZeit = 10
      , maxZeit = 20
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Start ->
            ( { model | running = True, istZeit = 0 }
            , Random.generate SollZeit (Random.int model.minZeit model.maxZeit)
            )

        NeueMinZeit minZeit ->
            if minZeit < 0 then
                ( { model | minZeit = 0 }, Cmd.none )

            else if minZeit >= model.maxZeit then
                ( { model | minZeit = model.maxZeit - 1 }, Cmd.none )

            else
                ( { model | minZeit = minZeit }, Cmd.none )

        NeueMaxZeit maxZeit ->
            if maxZeit < (model.minZeit + 1) then
                ( { model | maxZeit = model.minZeit + 1 }, Cmd.none )

            else
                ( { model | maxZeit = maxZeit }, Cmd.none )

        Stop ->
            ( { model | running = False }, Cmd.none )

        SollZeit zeit ->
            ( { model | sollZeit = zeit }, Cmd.none )

        Tick _ ->
            ( { model | istZeit = model.istZeit + 1 }, Cmd.none )


viewStart : Model -> Html Msg
viewStart model =
    div []
        [ button [ onClick (NeueMinZeit (model.minZeit - 1)) ] [ text "-" ]
        , text (String.fromInt model.minZeit)
        , button [ onClick (NeueMinZeit (model.minZeit + 1)) ] [ text "+" ]
        , div [] [ text "bis" ]
        , button [ onClick (NeueMaxZeit (model.maxZeit - 1)) ] [ text "-" ]
        , text (String.fromInt model.maxZeit)
        , button [ onClick (NeueMaxZeit (model.maxZeit + 1)) ] [ text "+" ]
        , div [] [ text "Sekunden" ]
        , button [ onClick Start ] [ text "Start" ]
        ]


view : Model -> Html Msg
view model =
    div []
        [ if model.running then
            button [ onClick Stop ] [ text "Stop" ]

          else
            viewStart model
        , div []
            [ if model.running then
                text ("Stoppe nach " ++ String.fromInt model.sollZeit ++ " Sekunden")

              else
                "Du hast nach "
                    ++ String.fromInt model.istZeit
                    ++ " Sekunden gestoppt"
                    ++ " und hast "
                    ++ String.fromInt (punkte model.sollZeit model.istZeit)
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
