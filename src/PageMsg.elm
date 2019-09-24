module PageMsg exposing (PageMsg(..))

import Page.FlagFailure as FlagFailure
import Page.Landing as Landing
import Page.Login as Login
import Page.Logout as Logout
import Page.NotFound as NotFound


type PageMsg
    = LandingMsg Landing.Msg
    | LoginMsg Login.Msg
    | LogoutMsg Logout.Msg
    | NotFoundMsg NotFound.Msg
    | FlagFailureMsg FlagFailure.Msg
