module Data exposing (ScreenSize, Token, tokenDecoder)

import Json.Decode as D


type alias Token =
    String


tokenDecoder =
    D.string


type alias ScreenSize =
    { width : Int
    , height : Int
    }
