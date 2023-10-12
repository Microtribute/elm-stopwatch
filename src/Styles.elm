module Styles exposing (..)

import Html exposing (Attribute)
import Html.Attributes exposing (..)


type alias Colors =
    { offBlack : String
    , offWhite : String
    , green : String
    , red : String
    , lightGrey : String
    , midGrey : String
    }


{-| asdfasdfasdf
-}
colors : Colors
colors =
    { offBlack = "#333"
    , offWhite = "#F5F5F5"
    , green = "#5CEC3D"
    , red = "#EC483D"
    , lightGrey = "#CCC"
    , midGrey = "#777"
    }


buttonBackground : String -> String
buttonBackground actionName =
    case actionName of
        "Start" ->
            colors.green

        "Stop" ->
            colors.red

        "Lap" ->
            colors.lightGrey

        "Reset" ->
            colors.lightGrey

        _ ->
            ""


styles : List ( String, String ) -> List (Attribute a)
styles =
    List.map (\( name, value ) -> style name value)


actionButton : String -> List (Attribute a)
actionButton actionName =
    styles
        [ ( "flex-grow", "1" )
        , ( "min-width", "50%" )
        , ( "font-size", "1.2rem" )
        , ( "border", "none" )
        , ( "outline", "none" )
        , ( "padding", "0.4rem" )
        , ( "background", buttonBackground actionName )
        ]


buttonRow : List (Attribute a)
buttonRow =
    styles
        [ ( "display", "flex" )
        , ( "flex-direction", "row" )
        ]


header : List (Attribute a)
header =
    styles
        [ ( "text-transform", "uppercase" )
        , ( "background", colors.offBlack )
        , ( "padding", "0.5em 1rem" )
        , ( "font-size", "1.2rem" )
        , ( "color", "#f5f5f5" )
        , ( "letter-spacing", "0.4rem" )
        , ( "text-align", "center" )
        ]


laps : List (Attribute a)
laps =
    styles
        [ ( "padding", "0" )
        , ( "text-align", "center" )
        , ( "background", colors.offWhite )
        ]


lapTimer : List (Attribute a)
lapTimer =
    styles
        [ ( "font-size", "1.2rem" )
        , ( "text-align", "right" )
        , ( "color", colors.midGrey )
        ]


lapEntry : List (Attribute a)
lapEntry =
    styles
        [ ( "list-style", "none" )
        , ( "padding", "0.5rem 0" )
        , ( "border-bottom", "1px solid" ++ colors.lightGrey )
        , ( "font-size", "1.2rem" )
        , ( "display", "flex" )
        , ( "flex-direction", "row" )
        ]


lapNumber : List (Attribute a)
lapNumber =
    styles
        [ ( "width", "2em" )
        , ( "color", colors.midGrey )
        ]


lapTime : List (Attribute a)
lapTime =
    styles
        [ ( "flex", "1" )
        , ( "padding-right", "2em" )
        ]


textBlock : List (Attribute a)
textBlock =
    styles
        [ ( "margin", "1rem" )
        , ( "text-align", "center" )
        ]


timers : List (Attribute a)
timers =
    styles
        [ ( "padding", "1rem 0" )
        , ( "display", "inline-block" )
        ]


totalTimer : List (Attribute a)
totalTimer =
    styles
        [ ( "font-size", "2rem" )
        ]


timersWrapper : List (Attribute a)
timersWrapper =
    styles [ ( "text-align", "center" ) ]
