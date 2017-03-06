module From exposing (..)

import Html exposing (..)
import Html.App as App
import Random exposing (float)


main : Program Never
main =
    App.program
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


type alias Model =
    Float


initialModel : Model
initialModel =
    1.1


init : ( Model, Cmd Msg )
init =
    ( initialModel, Random.generate GiveNumber <| float 1.0 100.0 )



-- UPDATE


type Msg
    = GiveNumber Float


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GiveNumber randomFloat ->
            ( randomFloat, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text <| toString <| model
