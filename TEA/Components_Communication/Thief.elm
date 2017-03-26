module Thief exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


-- MODEL


type alias Model =
    List String


initialModel : Model
initialModel =
    []



-- UPDATE


type Msg
    = Act
    | Steal String


type MsgForParent
    = StealWallet
    | NoOp


update : Msg -> Model -> ( Model, MsgForParent )
update msg model =
    case msg of
        Steal something ->
            ( List.append model [ something ], NoOp )

        Act ->
            ( model, StealWallet )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Act ] [ text "try to steal a wallet" ]
        , text <| toString <| model
        ]
