module Session exposing
    ( Event(..)
    , Msg
    , Rep
    , Session
    , addAuthToken
    , clearAuthToken
    , getAuthToken
    , getDevice
    , getScreenSize
    , init
    , navBack
    , navPush
    , navPushUrl
    , navReplace
    , popCmd
    , reset
    , setUrl
    , subscriptions
    , update
    )

import Browser.Events exposing (onResize)
import Browser.Navigation as Navigation
import Data exposing (ScreenSize, Token)
import Element exposing (Device)
import Json.Decode as Decode
import Route exposing (Destination, urlFor)
import Url exposing (Url)
import Url.Builder as Builder


type alias Rep =
    { navKey : Navigation.Key
    , url : Url
    , authToken : Maybe Token
    , cmdQueue : List (Cmd Msg)
    , screenSize : ScreenSize
    , device : Device
    }


type Session
    = Session Rep


type Msg
    = ScreenResized Int Int


type Event
    = NoEvent


init :
    Navigation.Key
    -> Url
    -> Maybe Token
    -> { width : Int, height : Int }
    -> Session
init key url authToken screenSize =
    let
        device =
            Element.classifyDevice
                { width = screenSize.width, height = screenSize.height }
    in
    Session <| Rep key url authToken [] screenSize device


reset : Session -> Session
reset (Session session) =
    init session.navKey session.url session.authToken session.screenSize


subscriptions : Session -> Sub Msg
subscriptions session =
    onResize ScreenResized


update : Msg -> Session -> ( Session, Maybe Event )
update msg session =
    case msg of
        ScreenResized width height ->
            let
                size =
                    { width = width, height = height }
            in
            ( (setScreenSize size << setDevice size) session
            , Nothing
            )


getAuthToken (Session session) =
    session.authToken


addAuthToken token (Session session) =
    { session | authToken = Just token }
        |> Session


navBack (Session session) =
    Session (session |> addCmd (Navigation.back session.navKey 1))


clearAuthToken (Session session) =
    Session { session | authToken = Nothing }


addCmd : Cmd Msg -> Rep -> Rep
addCmd cmd session =
    { session | cmdQueue = session.cmdQueue ++ [ cmd ] }


navPush : Destination -> Session -> Session
navPush destination (Session session) =
    session
        |> addCmd (Navigation.pushUrl session.navKey (urlFor destination))
        |> Session


navPushUrl urlString (Session session) =
    session
        |> addCmd (Navigation.pushUrl session.navKey urlString)
        |> Session


navReplace : Destination -> Session -> Session
navReplace destination (Session session) =
    session
        |> addCmd (Navigation.replaceUrl session.navKey (urlFor destination))
        |> Session


navReplaceUrl urlString (Session session) =
    session
        |> addCmd (Navigation.replaceUrl session.navKey urlString)
        |> Session


popCmd (Session session) =
    ( Session { session | cmdQueue = [] }, Cmd.batch session.cmdQueue )


setUrl url (Session session) =
    Session { session | url = url }


getScreenSize : Session -> ScreenSize
getScreenSize (Session session) =
    session.screenSize


setScreenSize : ScreenSize -> Session -> Session
setScreenSize size (Session session) =
    Session { session | screenSize = size }


getDevice : Session -> Device
getDevice (Session session) =
    session.device


setDevice : ScreenSize -> Session -> Session
setDevice size (Session session) =
    Session { session | device = Element.classifyDevice size }
