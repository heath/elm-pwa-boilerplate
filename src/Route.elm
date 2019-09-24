module Route exposing (Destination(..), NavState, parseUrl, push, replace, urlFor)

import Browser.Navigation as Navigation
import Url exposing (Url)
import Url.Builder as Builder exposing (absolute)
import Url.Parser exposing (..)
import Url.Parser.Query as Query


type alias NavState =
    { key : Navigation.Key
    , url : Url
    }



-- Destination has a 1:1 mapping with URLs, not pages.


type Destination
    = Root
    | NotFound String
    | Login (Maybe String)
    | Logout
    | FlagFailure (Maybe String)


urlFor destination =
    case destination of
        Root ->
            "/"

        Login (Just successUrl) ->
            absolute [ "/login" ] [ Builder.string "success" successUrl ]

        Login Nothing ->
            "/login"

        Logout ->
            "/logout"

        FlagFailure (Just originalUrl) ->
            absolute [ "/flag-failure" ] [ Builder.string "url" originalUrl ]

        FlagFailure Nothing ->
            "/flag-failure"

        NotFound failedUrl ->
            absolute [ "notfound" ] [ Builder.string "notFoundKey" failedUrl ]


routeParser =
    oneOf
        [ map Root top
        , map Login (s "login" <?> Query.string "success")
        , map Logout (s "logout")
        , map FlagFailure (s "flag-failure" <?> Query.string "url")

        -- NotFound is deliberately omitted
        ]


parseUrl : Url -> Destination
parseUrl url =
    url
        |> parse routeParser
        |> Maybe.withDefault (NotFound <| Url.toString url)


push : Destination -> NavState -> Cmd msg
push destination navState =
    Navigation.pushUrl navState.key (urlFor destination)


replace : Destination -> NavState -> Cmd msg
replace destination navState =
    Navigation.replaceUrl navState.key (urlFor destination)
