module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Navigation


main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { history : List Navigation.Location
    }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( Model [ location ]
    , Cmd.none
    )



-- UPDATE


type Msg
    = UrlChange Navigation.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            ( { model | history = location :: model.history }
            , Cmd.none
            )



-- VIEW


view : Model -> Html msg
view model =
    div [] [ text <| toString <| List.map .hash <| .history <| model ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub msg
subscriptions model =
    Sub.none
