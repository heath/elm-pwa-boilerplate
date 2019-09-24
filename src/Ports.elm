port module Ports exposing (reboot)

import Json.Encode as Encode


port reboot : Encode.Value -> Cmd msg
