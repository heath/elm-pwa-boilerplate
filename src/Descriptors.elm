module Descriptors exposing
    ( flagFailureDescriptor
    , landingDescriptor
    , loginDescriptor
    , logoutDescriptor
    , notFoundDescriptor
    )

import Browser exposing (Document)
import Page exposing (Descriptor)
import Page.FlagFailure as FlagFailure
import Page.Landing as Landing
import Page.Login as Login
import Page.Logout as Logout
import Page.NotFound as NotFound
import PageMsg exposing (PageMsg(..))
import Session exposing (Session)


loginDescriptor : Descriptor PageMsg Login.Msg Login.Model
loginDescriptor =
    { view = Login.view
    , update = Login.update
    , subscriptions = Nothing
    , wrapSessionEvent = Nothing
    , msgWrapper = LoginMsg
    , msgFilter =
        \main ->
            case main of
                LoginMsg msg ->
                    Just msg

                _ ->
                    Nothing
    }


logoutDescriptor : Descriptor PageMsg Logout.Msg Logout.Model
logoutDescriptor =
    { view = Logout.view
    , update = Logout.update
    , subscriptions = Nothing
    , msgWrapper = LogoutMsg
    , msgFilter =
        \main ->
            case main of
                LogoutMsg msg ->
                    Just msg

                _ ->
                    Nothing
    , wrapSessionEvent = Nothing
    }


notFoundDescriptor : Descriptor PageMsg NotFound.Msg NotFound.Model
notFoundDescriptor =
    { view = NotFound.view
    , update = NotFound.update
    , subscriptions = Nothing
    , msgWrapper = NotFoundMsg
    , msgFilter =
        \main ->
            case main of
                NotFoundMsg msg ->
                    Just msg

                _ ->
                    Nothing
    , wrapSessionEvent = Nothing
    }


landingDescriptor : Descriptor PageMsg Landing.Msg Landing.Model
landingDescriptor =
    { view = Landing.view
    , update = Landing.update
    , subscriptions = Nothing
    , msgWrapper = LandingMsg
    , msgFilter =
        \main ->
            case main of
                LandingMsg msg ->
                    Just msg

                _ ->
                    Nothing
    , wrapSessionEvent = Nothing
    }


flagFailureDescriptor : Descriptor PageMsg FlagFailure.Msg FlagFailure.Model
flagFailureDescriptor =
    { view = FlagFailure.view
    , update = FlagFailure.update
    , subscriptions = Nothing
    , msgWrapper = FlagFailureMsg
    , msgFilter =
        \main ->
            case main of
                FlagFailureMsg msg ->
                    Just msg

                _ ->
                    Nothing
    , wrapSessionEvent = Nothing
    }
