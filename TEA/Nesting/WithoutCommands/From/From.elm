module From exposing (..)

import Html exposing (..)
import Html.Events exposing (..)


main : Program Never Model Msg
main =
    beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = Add
    | Sub


update : Msg -> Model -> Model
update msg model =
    case msg of
        Add ->
            model + 1

        Sub ->
            model - 1



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Add ] [ text "+" ]
        , text <| toString model
        , button [ onClick Sub ] [ text "-" ]
        ]
