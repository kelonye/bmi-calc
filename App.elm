import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)


main =
  Html.program { init = init 0 0, view = view, update = update, subscriptions = subscriptions }


-- MODEL

type alias Model = {
  height: Float,
  weight: Float,
  bmi: Float
}


init : Float -> Float -> (Model, Cmd Msg)
init weight height =
  (Model weight height 0, Cmd.none)


-- UPDATE

type Msg = Weight String | Height String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Weight weight ->
      let
        w = Result.withDefault 0 (String.toFloat weight)
        b = bmi w model.height
      in
        ({model|weight = w, bmi = b }, Cmd.none)

    Height height ->
      let
        h = Result.withDefault 0 (String.toFloat height) / 100
        b = bmi model.weight h
      in
        ({model|height = h, bmi = b }, Cmd.none)


bmi : Float -> Float -> Float
bmi weight height =
  let
    b = weight / (height * height)
  in
    if (b < 0 || isInfinite b || isNaN b) then 0 else b


-- VIEW

view : Model -> Html Msg
view model =
  table [] [
    tr [] [
      td [] [ text "Weight (kg):" ],
      td [] [ input [ type_ "number", onInput Weight ] [] ]
    ],
    tr [] [
      td [] [ text "Height (cm):" ],
      td [] [ input [ type_ "number", onInput Height ] [] ]
    ],
    tr [] [
      td [] [ text "BMI:"],
      td [] [ text (toString model.bmi) ]
    ]
  ]


-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
