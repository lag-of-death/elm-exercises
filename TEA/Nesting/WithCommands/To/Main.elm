module Main exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Counter exposing (..)


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
    Sub.none



-- MODEL


init : ( Model, Cmd Msg )
init =
    let
        ( counterModel, counterCmd ) =
            Counter.init
    in
        ( counterModel, Cmd.map CounterMsg counterCmd )


type alias Model =
    Counter.Model


initialModel : Model
initialModel =
    Counter.initialModel



-- UPDATE


type Msg
    = CounterMsg Counter.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        CounterMsg msg ->
            let
                ( newModel, cmd ) =
                    Counter.update msg model
            in
                ( newModel, Cmd.map CounterMsg cmd )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ Html.map CounterMsg (Counter.view model)
        ]
