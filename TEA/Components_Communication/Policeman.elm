module Policeman exposing (..)

import Html exposing (..)


-- MODEL


type alias Model =
    String


initialModel : Model
initialModel =
    "nobody"



-- UPDATE


type Msg
    = Chase String


type MsgForParent
    = NoOp


update : Msg -> Model -> ( Model, MsgForParent )
update msg model =
    case msg of
        Chase somebody ->
            ( somebody, NoOp )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ text <| String.append "I am chasing " <| model
        ]
