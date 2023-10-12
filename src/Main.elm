module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import String
import Styles
import Task
import Time


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view "Stopwatch"
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { startTimestamp : Int
    , laps : List Int
    , isTiming : Bool
    , currentTimestamp : Int
    , durationOnStop : Int
    , lapDurationOnStop : Int
    , lastLapTimestamp : Int
    }


zeroTime : Time.Posix
zeroTime =
    Time.millisToPosix 0


initialModel : Model
initialModel =
    { startTimestamp = 0
    , laps = []
    , isTiming = False
    , currentTimestamp = 0
    , durationOnStop = 0
    , lapDurationOnStop = 0
    , lastLapTimestamp = 0
    }


subscriptions : Model -> Sub Msg
subscriptions { isTiming } =
    if isTiming then
        Time.every 1 TimeChange

    else
        Sub.none


init : () -> ( Model, Cmd Msg )
init _ =
    ( initialModel
    , Cmd.none
    )



-- Update


type Msg
    = ReceiveTimestamp UserAction Time.Posix
    | TimeChange Time.Posix
    | ButtonPress UserAction
    | NoOp


type UserAction
    = Start
    | Stop
    | Lap
    | Reset


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ButtonPress userAction ->
            ( model, Task.perform (ReceiveTimestamp userAction) Time.now )

        ReceiveTimestamp userAction time ->
            let
                ts =
                    Time.posixToMillis time
            in
            case userAction of
                Start ->
                    ( handleStart ts model, Cmd.none )

                Stop ->
                    ( handleStop ts model, Cmd.none )

                Lap ->
                    ( handleLap ts model, Cmd.none )

                Reset ->
                    ( initialModel, Cmd.none )

        TimeChange time ->
            if model.isTiming then
                ( { model | currentTimestamp = Time.posixToMillis time }, Cmd.none )

            else
                ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


handleStart : Int -> Model -> Model
handleStart time model =
    { model
        | isTiming = True
        , startTimestamp = time
        , lastLapTimestamp = time
    }


handleStop : Int -> Model -> Model
handleStop time model =
    let
        duration =
            model.durationOnStop + time - model.startTimestamp
    in
    { model
        | isTiming = False
        , durationOnStop = duration
        , lapDurationOnStop = duration - total model.laps
    }


handleLap : Int -> Model -> Model
handleLap time state =
    { state
        | laps = (state.lapDurationOnStop + time - state.lastLapTimestamp) :: state.laps
        , lastLapTimestamp = time
        , lapDurationOnStop = 0
    }


total : List Int -> Int
total =
    List.foldl (+) 0


millisToString : Int -> String
millisToString millis =
    let
        minutes =
            millis // 60000

        seconds =
            (millis - 60000 * minutes) // 1000

        centiseconds =
            millis - 60000 * minutes - 1000 * seconds

        pad f n =
            String.padLeft f '0' (String.fromInt n)

        _ =
            [ minutes, seconds, centiseconds ]
                |> Debug.log "duration"
    in
    pad 2 minutes ++ ":" ++ pad 2 seconds ++ "." ++ pad 4 centiseconds



-- View


view : String -> Model -> Html Msg
view heading model =
    div []
        [ header heading
        , timers model
        , buttonRow model.isTiming
        , lapsList model.laps
        ]


header : String -> Html Msg
header heading =
    div Styles.header
        [ text heading ]


timers : Model -> Html Msg
timers model =
    let
        timeDiff =
            model.currentTimestamp - model.startTimestamp

        currentDuration =
            if model.isTiming then
                model.durationOnStop + timeDiff

            else
                model.durationOnStop

        lapDuration =
            currentDuration - total model.laps
    in
    div Styles.timersWrapper
        [ div Styles.timers
            [ div Styles.lapTimer [ text (millisToString lapDuration) ]
            , div Styles.totalTimer [ text (millisToString currentDuration) ]
            ]
        ]


buttonRow : Bool -> Html Msg
buttonRow isTiming =
    div Styles.buttonRow <|
        if isTiming then
            [ actionButton Stop
            , actionButton Lap
            ]

        else
            [ actionButton Start
            , actionButton Reset
            ]


lapsList : List Int -> Html Msg
lapsList laps =
    ul Styles.laps
        (laps
            |> List.reverse
            |> List.indexedMap lapEntry
            |> List.reverse
        )


actionToString : UserAction -> String
actionToString action =
    Debug.toString action


actionButton : UserAction -> Html Msg
actionButton action =
    button (onClick (ButtonPress action) :: Styles.actionButton (actionToString action))
        [ text (actionToString action) ]


lapEntry : Int -> Int -> Html Msg
lapEntry index entry =
    let
        lapNumber =
            String.fromInt (index + 1) ++ "."
    in
    li Styles.lapEntry
        [ span Styles.lapNumber [ text lapNumber ]
        , span Styles.lapTime [ entry |> millisToString |> text ]
        ]


viewLine : String -> Html Msg
viewLine lineText =
    div Styles.textBlock
        [ text lineText ]
