module Main exposing (..)

import Html exposing (..)
import Counter exposing (..)


main : Program Never Model Msg
main =
    beginnerProgram
        { model = model
        , update = update
        , view = view
        }



-- MODEL


model : Counter.Model
model =
    Counter.initialModel



-- UPDATE


type Msg
    = NoOp
    | Counter Counter.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        NoOp ->
            model

        Counter msg ->
            Counter.update msg model



-- VIEW


view : Model -> Html Msg
view model =
    map Counter (Counter.view model)
