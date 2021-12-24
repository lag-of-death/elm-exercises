module From exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Random exposing (..)


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
    ( initialModel, Random.generate RandomNumber (int 1 100) )


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- UPDATE


type Msg
    = Add
    | Sub
    | RandomNumber Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Add ->
            ( model + 1, Cmd.none )

        Sub ->
            ( model - 1, Cmd.none )

        RandomNumber number ->
            ( number, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Add ] [ text "+" ]
        , text <| toString model
        , button [ onClick Sub ] [ text "-" ]
        ]
