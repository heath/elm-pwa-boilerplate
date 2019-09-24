module Router exposing (route)

import Descriptors exposing (..)
import Model exposing (Model, wrapPage)
import Msg exposing (Msg)
import Page
import Page.FlagFailure as FlagFailure
import Page.Landing as Landing
import Page.Login as Login
import Page.Logout as Logout
import Page.NotFound as NotFound
import PageMsg exposing (..)
import Route exposing (..)
import Session exposing (Session)
import Url exposing (Url)


route : Url -> Session -> ( Session, Page.Model PageMsg, Cmd PageMsg )
route url session =
    let
        nominalDestination =
            Route.parseUrl url

        newSession =
            session |> Session.setUrl url

        byDestination destination =
            case ( destination, newSession |> Session.getAuthToken ) of
                ( Root, Nothing ) ->
                    newSession
                        |> Landing.init
                        |> Page.init landingDescriptor

                ( Root, Just _ ) ->
                    newSession |> Landing.init |> Page.init landingDescriptor

                ( NotFound _, _ ) ->
                    newSession |> NotFound.init (Url.toString url) |> Page.init notFoundDescriptor

                ( Logout, _ ) ->
                    newSession |> Logout.init |> Page.init logoutDescriptor

                ( Login successUrl, Nothing ) ->
                    newSession |> Login.init successUrl |> Page.init loginDescriptor

                ( Login Nothing, Just _ ) ->
                    newSession |> Landing.init |> Page.init landingDescriptor

                ( Login (Just urlString), Just _ ) ->
                    case urlString |> Url.fromString of
                        Just successUrl ->
                            route successUrl newSession

                        Nothing ->
                            newSession |> Landing.init |> Page.init landingDescriptor

                ( FlagFailure (Just originalUrl), _ ) ->
                    newSession |> FlagFailure.init (Just originalUrl) |> Page.init flagFailureDescriptor

                ( FlagFailure Nothing, _ ) ->
                    newSession |> FlagFailure.init Nothing |> Page.init flagFailureDescriptor
    in
    byDestination nominalDestination
