module Test.Html.Query exposing (Single, Multiple, find, findAll, descendants, count)

import Html exposing (Html)
import Test.Html.Query.Selector.Internal as Selector exposing (Selector)
import Test.Html.Query.Internal as Internal exposing (QueryError(..))
import Html.Inert as Inert
import Expect exposing (Expectation)


type alias Single =
    Internal.Single


type alias Multiple =
    Internal.Multiple



-- STARTERS --


find : List Selector -> Html msg -> Single
find selectors html =
    Internal.Find selectors
        |> Internal.Query (Inert.fromHtml html) []
        |> Internal.Single


findAll : List Selector -> Html msg -> Multiple
findAll selectors html =
    Internal.FindAll selectors
        |> Internal.Query (Inert.fromHtml html) []
        |> Internal.Multiple



-- SELECTORS --


descendants : List Selector -> Single -> Multiple
descendants selectors (Internal.Single query) =
    Internal.Descendants selectors
        |> Internal.prependSelector query
        |> Internal.Multiple



-- EXPECTATIONS --


count : (Int -> Expectation) -> Multiple -> Expectation
count expect ((Internal.Multiple query) as multiple) =
    (List.length >> expect >> failWithQuery "Query.count" query)
        |> Internal.multipleToExpectation multiple


failWithQuery : String -> Internal.Query -> Expectation -> Expectation
failWithQuery queryName query expectation =
    case Expect.getFailure expectation of
        Just { given, message } ->
            (Internal.toLines query ++ [ queryName ])
                |> List.map prefixOutputLine
                |> ((::) (Internal.toHtmlString query))
                |> String.join "\n\n\n"
                |> (\str -> str ++ "\n\n\n" ++ message)
                |> Expect.fail

        Nothing ->
            expectation


prefixOutputLine : String -> String
prefixOutputLine =
    (++) "▼ "
