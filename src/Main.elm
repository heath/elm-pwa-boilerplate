module Main exposing (main)

import Browser exposing (Document, UrlRequest(..))
import Browser.Events exposing (onResize)
import Browser.Navigation as Navigation
import Debug
import Descriptors exposing (landingDescriptor)
import Element exposing (classifyDevice)
import Html
import Json.Decode as Decode
import Model exposing (Model)
import Msg exposing (..)
import Page as Page
import Page.Landing as Landing
import Route exposing (Destination(..))
import Router
import Session exposing (Session)
import Task exposing (succeed)
import Url exposing (Url)


main : Program Decode.Value Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = onUrlRequest
        , onUrlChange = onUrlChange
        }


type alias Flags =
    { width : Int
    , height : Int
    }


flagDecoder =
    Decode.map2 Flags
        (Decode.field "width" Decode.int)
        (Decode.field "height" Decode.int)


init : Decode.Value -> Url -> Navigation.Key -> ( Model, Cmd Msg )
init jsonFlags url key =
    let
        flags : Result Decode.Error Flags
        flags =
            jsonFlags
                |> Decode.decodeValue flagDecoder
    in
    case flags of
        Err error ->
            let
                ohnoes =
                    Debug.log "ohnoes: " error

                originalUrl =
                    { url
                        | path = "/flag-failure"
                        , query = Just ("url=" ++ url.path)
                    }
            in
            Session.init key originalUrl Nothing { width = 0, height = 0 }
                |> Router.route originalUrl
                |> Model.wrapPage
                |> (\( m, c ) -> ( m, c, Nothing ))
                |> runSessionCommands

        Ok screenSize ->
            Session.init key url Nothing screenSize
                |> Router.route url
                |> Model.wrapPage
                |> (\( m, c ) -> ( m, c, Nothing ))
                |> runSessionCommands


view : Model -> Browser.Document Msg
view { session, page } =
    let
        { title, body } =
            Page.view session page
    in
    { title = title, body = body |> List.map (Html.map Page) }


mainUpdate : Msg -> Model -> ( Model, Cmd Msg, Maybe Session.Event )
mainUpdate msg ({ session, page } as model) =
    case msg of
        NoEvent ->
            ( model, Cmd.none, Nothing )

        UrlRequested (Internal url) ->
            ( { model
                | session =
                    model.session
                        |> Session.navPushUrl (Url.toString url)
              }
            , Cmd.none
            , Nothing
            )

        UrlRequested (External urlString) ->
            ( model, Navigation.load urlString, Nothing )

        UrlChanged url ->
            session |> Router.route url |> Model.wrapPage |> (\( m, c ) -> ( m, c, Nothing ))

        Page pageMsg ->
            Page.update pageMsg session page |> Model.wrapPage |> (\( m, c ) -> ( m, c, Nothing ))

        Session sessionMsg ->
            let
                ( newSession, sessionEvent ) =
                    Session.update sessionMsg model.session
            in
            ( { model | session = newSession }, Cmd.none, sessionEvent )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    mainUpdate msg model
        |> runSessionCommands


runSessionCommands ( model, cmds, sessionEvent ) =
    let
        ( cleanSession, sessionCmds ) =
            Session.popCmd model.session

        newModel =
            { model | session = cleanSession }

        newCmds =
            Cmd.batch [ cmds, Cmd.map Msg.Session sessionCmds ]
    in
    sessionEvent
        |> Maybe.andThen (\event -> Page.wrapSessionEvent event model.page)
        |> Maybe.map
            (\m ->
                let
                    ( recModel, recCmds ) =
                        update (Msg.Page m) newModel
                in
                ( recModel, Cmd.batch [ newCmds, recCmds ] )
            )
        |> Maybe.withDefault ( newModel, newCmds )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Page.subscriptions model.session model.page
            |> Sub.map Msg.Page
        , Session.subscriptions model.session
            |> Sub.map Msg.Session
        ]


onUrlRequest : Browser.UrlRequest -> Msg
onUrlRequest request =
    UrlRequested request


onUrlChange : Url.Url -> Msg
onUrlChange url =
    UrlChanged url
