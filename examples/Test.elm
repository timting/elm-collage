module Main exposing (..)

import Collage exposing (..)
import Collage.Events exposing (onClick)
import Collage.Layout exposing (..)
import Collage.Render exposing (svg)
import Collage.Text exposing (fromString)
import Color exposing (..)
import Html exposing (Html)


-- Model -----------------------------------------------------------------------


type alias Model =
    { active : Bool }


init : Model
init =
    { active = False }



-- Update ----------------------------------------------------------------------


type Msg
    = Switch


update : Msg -> Model -> Model
update msg model =
    case msg of
        Switch ->
            { model | active = not model.active }



-- View ------------------------------------------------------------------------
-- Styles --


border : LineStyle
border =
    solid verythin <| uniform black


debug : Collage msg -> Collage msg
debug collage =
    collage
        |> showOrigin
        |> showEnvelope



-- Text --


txt : Collage Msg
txt =
    fromString "Hello collage!"
        |> rendered



-- Shapes --


circ : Model -> Collage Msg
circ model =
    circle 100
        |> styled
            ( uniform <|
                if model.active then
                    lightPurple
                else
                    lightBlue
            , border
            )
        |> onClick Switch


rect : Collage msg
rect =
    square 100
        |> styled ( uniform lightOrange, border )


tria : Collage msg
tria =
    triangle 100
        |> styled ( uniform lightGreen, border )


penta : Collage msg
penta =
    ngon 5 100
        |> styled ( uniform lightCharcoal, border )



-- Alignments --


alignments : Collage msg
alignments =
    horizontal <|
        List.map (showOrigin << align top) [ rect, tria, rect, rect ]



-- Main ------------------------------------------------------------------------


view : Model -> Html Msg
view model =
    vertical
        [ rect
        , horizontal
            [ stack [ showEnvelope txt, circ model ]
            , vertical
                [ tria
                , tria |> rotate pi
                ]
                |> center
            , debug penta
            ]
        ]
        |> debug
        |> svg


main : Program Never Model Msg
main =
    Html.beginnerProgram { model = init, view = view, update = update }