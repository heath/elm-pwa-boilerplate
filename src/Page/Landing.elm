module Page.Landing exposing (Model, Msg, init, update, view)

import Browser exposing (Document)
import Element as El exposing (..)
import Session exposing (Session(..))


init : Session -> ( Session, Model, Cmd Msg )
init session =
    ( session, True, Cmd.none )


type alias Model =
    Bool


type Msg
    = NoOp


colors =
    { white = rgb255 255 255 255
    , black = rgb255 0 0 0
    }


edges =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


view : Session -> Model -> Document Msg
view session model =
    { title = "ChangeMe"
    , body =
        [ layout []
            (El.el [] (El.text "ChangeMe"))
        ]
    }


update : Msg -> Session -> Model -> ( Session, Model, Cmd Msg )
update msg session model =
    case msg of
        _ ->
            ( session, model, Cmd.none )
