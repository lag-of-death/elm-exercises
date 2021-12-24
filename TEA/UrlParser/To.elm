module To exposing (..)

import Html exposing (..)
import Html.Events exposing (..)
import Navigation as Nav
import UrlParser exposing (..)


main : Program Never Model Msg
main =
    Nav.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \model -> Sub.none
        }



-- MODEL


type alias Model =
    { history : List (Maybe Route)
    }


init : Nav.Location -> ( Model, Cmd Msg )
init location =
    ( { history = [ UrlParser.parsePath routeParser location ] }
    , Cmd.none
    )



-- ROUTES


type Route
    = Home
    | LangId Int
    | LangList (Maybe String)


routeParser : UrlParser.Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map LangId ((UrlParser.s "lang") </> int)
        , UrlParser.map LangList ((UrlParser.s "lang") <?> (stringParam "search"))
        ]



-- UPDATE


type Msg
    = NewUrl String
    | UrlChange Nav.Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model
            , Nav.newUrl url
            )

        UrlChange location ->
            ( { model | history = (UrlParser.parsePath routeParser location) :: model.history }
            , Cmd.none
            )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (NewUrl "/lang/") ] [ text "lang" ]
        , button [ onClick (NewUrl "/lang/1") ] [ text "lang/1" ]
        , button [ onClick (NewUrl "/lang/?search=sth") ] [ text "?search=sth" ]
        , text <| toString <| List.head <| .history <| model
        ]
