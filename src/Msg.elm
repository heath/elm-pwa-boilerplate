module Msg exposing (Msg(..))

import Browser exposing (UrlRequest)
import Browser.Navigation as Navigation exposing (Key)
import Data exposing (ScreenSize, Token)
import PageMsg exposing (PageMsg)
import Session
import Url exposing (Url)


type Msg
    = NoEvent
    | UrlRequested UrlRequest
    | UrlChanged Url
    | Page PageMsg
    | Session Session.Msg
