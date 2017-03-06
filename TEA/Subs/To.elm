module From exposing (..)

import Html exposing (..)
import Html.App as App
import Time


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
    Time.every Time.second NewTime



-- MODEL


type alias Model =
    Float


initialModel : Model
initialModel =
    0


init : ( Model, Cmd Msg )
init =
    ( initialModel, Cmd.none )



-- UPDATE


type Msg
    = NewTime Time.Time


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTime time ->
            ( time, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text <| toString <| model
