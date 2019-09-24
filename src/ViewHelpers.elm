module ViewHelpers exposing
    ( appName
    , black
    , button
    , buttonRounded
    , dialogPage
    , gray
    , logoutButton
    , pageTitle
    , white
    , window
    , windowRounded
    )

import Element
    exposing
        ( Element
        , alignRight
        , centerX
        , centerY
        , column
        , el
        , fill
        , padding
        , rgb255
        , row
        , spacing
        , text
        , width
        )
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Route
import Session


appName =
    "Yes, this is an app."


pageTitle pageName =
    appName ++ ": " ++ pageName


dialogPage rest =
    Element.layout [] <|
        window [ centerX, centerY ]
            (column
                [ spacing 10 ]
                [ el [ centerX ] (text appName)
                , el [] rest
                ]
            )


logoutButton msg session =
    if Session.getAuthToken session == Nothing then
        Element.none

    else
        button [] { onPress = Just msg, label = text "Log out" }


window attributes =
    el
        ([ Background.color black
         , Font.color white
         , Border.rounded windowRounded
         , padding 30
         ]
            ++ attributes
        )


button attributes =
    Input.button
        ([ Border.rounded buttonRounded
         , padding 5
         , Border.color white
         , Border.width 2
         ]
            ++ attributes
        )


windowRounded =
    10


buttonRounded =
    10


black =
    rgb255 0 0 0


gray =
    rgb255 128 128 128


white =
    rgb255 255 255 255
