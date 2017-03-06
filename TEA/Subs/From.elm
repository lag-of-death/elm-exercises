module From exposing (..)

import Html exposing (..)
import Html.App as App


main : Program Never
main =
    App.beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    Float


initialModel : Model
initialModel =
    1.1



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> Model
update msg model =
    model



-- VIEW


view : Model -> Html a
view model =
    text <| toString <| model
