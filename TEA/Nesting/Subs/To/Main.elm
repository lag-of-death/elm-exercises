module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Counter


main : Program Never Model Msg
main =
    program
        { init = init
        , update = update
        , view = view
        , subscriptions = subs
        }



-- SUBS


subs : Model -> Sub Msg
subs model =
    Sub.batch
        [ Sub.none
        , Sub.map CounterMsg (Counter.subs model)
        ]



-- MODEL


type alias Model =
    Counter.Model


init : ( Model, Cmd Msg )
init =
    let
        ( counterModel, counterCmd ) =
            Counter.init
    in
        ( counterModel, Cmd.map CounterMsg counterCmd )



-- UPDATE


type Msg
    = CounterMsg Counter.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CounterMsg msg ->
            let
                ( counterModel, counterCmd ) =
                    Counter.update msg model
            in
                ( counterModel, Cmd.map CounterMsg counterCmd )



-- VIEW


view : Model -> Html Msg
view model =
    text <| toString <| model
