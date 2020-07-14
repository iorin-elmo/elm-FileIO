module Main exposing (..)

import Browser
import Html exposing (Html, div, text, br, button)
import Html.Events exposing (onClick)
import File exposing (File)
import File.Select as Select
import Task

type alias Model =
  { fileName : String
  , fileText : String
  }

initModel =
  { fileName = ""
  , fileText = ""
  }

type Msg
  = Pressed
  | Open String
  | SelectFile File

isExpected : File -> Bool
isExpected file =
  String.contains "text" (File.mime file)
  

--Update--

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Pressed ->
      ( model
      , Select.file [model.fileName] SelectFile
      )
    Open str ->
      ( { model
        | fileText = str
        }
      , Cmd.none
      )
    SelectFile file ->
      if isExpectedFile file
      then
        ( model
        , Task.perform Open (File.toString file)
        )
      else
        ( { model
          | fileText = "FileOpenError : unexpectedFileType"
          }
        , Cmd.none
        )

--View--

view : Model -> Html Msg
view model =
  div[]
    [ button
      [ onClick Pressed ]
      [ text "Select File" ]
    , br[][]
    , text model.fileText
    ]

--Main--

main : Program () Model Msg
main =
  Browser.element
    { init = \_-> (initModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
