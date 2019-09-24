module Page.FlagFailure exposing (Model, Msg, init, update, view)

import Browser exposing (Document)
import Browser.Dom exposing (Viewport, getViewport)
import Element
    exposing
        ( column
        , layout
        , spacing
        , text
        )
import Json.Encode as Encode
import Ports exposing (reboot)
import Route
import Session exposing (Session)
import Task
import ViewHelpers exposing (dialogPage)


type alias Model =
    { originalUrl : Maybe String }


type Msg
    = Reboot Viewport


init : Maybe String -> Session -> ( Session, Model, Cmd Msg )
init originalUrl session =
    ( session
    , { originalUrl = originalUrl }
    , Task.perform Reboot getViewport
    )


view : Session -> Model -> Document Msg
view session model =
    { title = "Recovering from Initialization Failure"
    , body =
        [ dialogPage <|
            column [ spacing 10 ]
                [ text "The web app has failed to initialize correctly, hang tight!"
                , text " “Peace is its own reward.” — Mahatma Gandhi"
                ]
        ]
    }


update : Msg -> Session -> Model -> ( Session, Model, Cmd Msg )
update msg session model =
    case msg of
        Reboot viewport ->
            ( session
            , model
            , Ports.reboot (Encode.object [ ( "width", Encode.float viewport.scene.width ), ( "height", Encode.float viewport.scene.height ) ])
            )
