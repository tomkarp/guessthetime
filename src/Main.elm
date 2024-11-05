module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Flags =
    { myFlag : String
    }


type alias Model =
    { txt : String
    }


type Msg
    = ButtonClick


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { txt = flags.myFlag 
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ButtonClick ->
            ( { model | txt = "Button clicked" }
            , Cmd.none
            )


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick ButtonClick ] [ text "Click me" ]
        , div [] [ text model.txt ]
        ]


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
