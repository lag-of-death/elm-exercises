module From exposing (main)

import Html exposing (Html, program, input, button, img, text, div)
import Html.Attributes exposing (src)
import Html.Events exposing (onInput, onClick)
import Http
import Task
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Debug


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }



-- TYPES


type alias Photo =
    { id : String
    , url : String
    , title : String
    }


type alias Model =
    { searchPhrase : String, url : String }


type Msg
    = NoOp
    | SetSearchPhrase String
    | Search
    | RunHTTPChain (Result Http.Error (List Photo))


initialModel : Model
initialModel =
    { searchPhrase = "", url = "" }


defaultPhoto : Photo
defaultPhoto =
    { id = "1"
    , url = ""
    , title = ""
    }



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSearchPhrase phrase ->
            ( { model | searchPhrase = phrase }, Cmd.none )

        Search ->
            ( model, getUserAndPhotos model.searchPhrase )

        RunHTTPChain (Ok data) ->
            let
                head =
                    List.head data
            in
                ( { model | url = .url <| Maybe.withDefault defaultPhoto head }
                , Cmd.none
                )

        _ ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput SetSearchPhrase ] []
        , button [ onClick Search ] [ text "search" ]
        , showImg model.url
        ]


showImg : String -> Html msg
showImg url =
    if String.isEmpty url then
        div [] [ text "no photo for empty url" ]
    else
        img [ src url ] []



-- HTTP


getUserAndPhotos : String -> Cmd Msg
getUserAndPhotos username =
    Http.toTask (getUserId username)
        |> Task.andThen (\userId -> Http.toTask <| getPicturesByUID userId)
        |> Task.andThen (\data -> Task.succeed <| Debug.log "data" data)
        |> Task.attempt RunHTTPChain


getUserId : String -> Http.Request String
getUserId username =
    let
        url =
            "https://api.flickr.com/services/rest/"
                ++ "?method=flickr.people.findByUsername"
                ++ "&api_key=<<FLICK_API_KEY_HERE>>"
                ++ "&format=json"
                ++ "&nojsoncallback=1"
                ++ "&username="
                ++ username
    in
        Http.get url userIdDecoder


getPicturesByUID : String -> Http.Request (List Photo)
getPicturesByUID userId =
    Http.get (buildUrl userId) photosDecoder



-- DECODERS


photoDecoder : Decoder Photo
photoDecoder =
    decode Photo
        |> required "id" Decode.string
        |> optional "url_q" Decode.string ""
        |> optional "title" Decode.string ""


photosDecoder : Decoder (List Photo)
photosDecoder =
    Decode.at [ "photos", "photo" ] (Decode.list photoDecoder)


userIdDecoder : Decoder String
userIdDecoder =
    Decode.at [ "user", "id" ] Decode.string



-- HELPERS


buildUrl : String -> String
buildUrl userId =
    "https://api.flickr.com/services/rest/"
        ++ "?method=flickr.people.getPhotos"
        ++ "&api_key=<<FLICK_API_KEY_HERE>>"
        ++ "&user_id="
        ++ userId
        ++ "&format=json"
        ++ "&extras=url_q"
        ++ "&nojsoncallback=1"
