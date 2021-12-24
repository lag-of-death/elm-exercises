module From exposing (..)

import Html exposing (..)


main : Program Never Model Msg
main =
    beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    String


initialModel : Model
initialModel =
    "home!"



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


view : Model -> Html a
view model =
    model |> text
