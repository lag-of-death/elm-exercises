module From exposing (main)

import Html exposing (Html, program, input, button, img, text, div)
import Html.Attributes as HA exposing (src, style)
import Html.Events exposing (on, onInput, onClick)
import Http
import Task
import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Pipeline exposing (decode, optional, required)
import Debug
import Animation exposing (px)
import Json.Decode as Json
import Time


main : Program Never Model Msg
main =
    program
        { init = ( initialModel, Cmd.none )
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- SUBS


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate [ model.style ]



-- TYPES


type alias Photo =
    { id : String
    , url : String
    , title : String
    }


type alias Model =
    { searchPhrase : String, url : String, style : Animation.State }


type Msg
    = NoOp
    | SetSearchPhrase String
    | Search
    | ImageLoaded
    | Animate Animation.Msg
    | RunHTTPChain (Result Http.Error (List Photo))


initialModel : Model
initialModel =
    { searchPhrase = "", url = "", style = initialStyle }


defaultPhoto : Photo
defaultPhoto =
    { id = "1"
    , url = ""
    , title = ""
    }


initialStyle : Animation.State
initialStyle =
    Animation.style
        [ Animation.scale 0.3
        , Animation.left (px 410.0)
        , Animation.borderRadius (px 360.0)
        , Animation.opacity 0
        ]



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSearchPhrase phrase ->
            ( { model | searchPhrase = phrase }, Cmd.none )

        ImageLoaded ->
            let
                newStyle =
                    Animation.interrupt
                        [ Animation.toWith
                            (Animation.easing
                                { duration = 2 * Time.second
                                , ease = (\x -> x ^ 2)
                                }
                            )
                            [ Animation.scale 1
                            , Animation.borderRadius (px 0.0)
                            , Animation.left (px 0.0)
                            , Animation.opacity 1
                            ]
                        ]
                        model.style
            in
                ( { model | style = newStyle }, Cmd.none )

        Search ->
            ( { model | style = initialStyle, url = "" }, getUserAndPhotos model.searchPhrase )

        RunHTTPChain (Err err) ->
            ( model
            , let
                x =
                    Debug.log "err" err
              in
                Cmd.none
            )

        RunHTTPChain (Ok data) ->
            let
                head =
                    List.head data
            in
                ( { model
                    | url = .url <| Maybe.withDefault defaultPhoto head
                  }
                , Cmd.none
                )

        Animate msg ->
            ( { model
                | style = Animation.update msg model.style
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ input [ onInput SetSearchPhrase ] []
        , button [ onClick Search ] [ text "search" ]
        , showImg model.url model.style
        ]


showImg : String -> Animation.State -> Html Msg
showImg url style =
    if String.isEmpty url then
        div [] [ text "no photo for empty url" ]
    else
        div
            []
            [ img
                (List.concat
                    [ (Animation.render style)
                    , [ HA.style [ ( "position", "absolute" ) ] ]
                    , [ src url ]
                    , [ onLoad ImageLoaded ]
                    ]
                )
                []
            ]



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
                ++ "&api_key=<<FLICKER_API_KEY_HERE>>"
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
        ++ "&api_key=<<FLICKER_API_KEY_HERE>>"
        ++ "&user_id="
        ++ userId
        ++ "&format=json"
        ++ "&extras=url_q"
        ++ "&nojsoncallback=1"


onLoad : a -> Html.Attribute a
onLoad message =
    on "load" (Json.succeed message)
