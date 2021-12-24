module Main exposing (..)

import Html exposing (..)
import Thief exposing (..)
import Policeman exposing (..)


main : Program Never Model Msg
main =
    beginnerProgram
        { model = initialModel
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { thief : Thief.Model, policeman : Policeman.Model }


initialModel : Model
initialModel =
    { thief = Thief.initialModel, policeman = Policeman.initialModel }



-- UPDATE


type Msg
    = ThiefMsg Thief.Msg
    | PolicemanMsg Policeman.Msg


processMsgForParent : Thief.MsgForParent -> Model -> Model
processMsgForParent msgForParent model =
    case msgForParent of
        StealWallet ->
            let
                ( thiefUpdatedModel, _ ) =
                    Thief.update (Thief.Steal "wallet") model.thief

                ( policemanUpdatedModel, _ ) =
                    Policeman.update (Policeman.Chase "a wallet stealer") model.policeman
            in
                ({ model | policeman = policemanUpdatedModel, thief = thiefUpdatedModel })

        _ ->
            model


update : Msg -> Model -> Model
update msg model =
    case msg of
        ThiefMsg thiefMsg ->
            let
                ( _, msgForParent ) =
                    Thief.update thiefMsg model.thief
            in
                processMsgForParent msgForParent model

        PolicemanMsg policemanMsg ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ map ThiefMsg (Thief.view model.thief)
        , map PolicemanMsg (Policeman.view model.policeman)
        ]
