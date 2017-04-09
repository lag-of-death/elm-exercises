module Counter exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Time


-- SUBS


subs : Model -> Sub Msg
subs model =
    Time.every Time.second RandomNumber



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
    = RandomNumber Model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RandomNumber number ->
            ( number, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    text <| toString <| model
