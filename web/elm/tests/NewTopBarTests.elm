module NewTopBarTests exposing (..)

import Dict
import Expect
import Html.Attributes as Attributes
import Html.Styled as HS
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as THS exposing (tag, attribute, class, text, containing)
import Test.Html.Event as Event
import NewTopBar
import RemoteData


smallScreen : NewTopBar.Model
smallScreen =
    NewTopBar.init True ""
        |> Tuple.first
        |> updateModel
            (NewTopBar.ScreenResized { width = 300, height = 800 })


queryView : NewTopBar.Model -> Query.Single NewTopBar.Msg
queryView =
    NewTopBar.view
        >> HS.toUnstyled
        >> Query.fromHtml


updateModel : NewTopBar.Msg -> NewTopBar.Model -> NewTopBar.Model
updateModel msg =
    NewTopBar.update msg >> Tuple.first


all : Test
all =
    describe "NewTopBarSearchInput"
        [ describe "on small screens"
            [ test "shows the search icon" <|
                \_ ->
                    smallScreen
                        |> queryView
                        |> Query.findAll [ class "search-btn" ]
                        |> Query.count (Expect.equal 1)
            , test "shows no search bar on high density" <|
                \_ ->
                    NewTopBar.init False ""
                        |> Tuple.first
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 300, height = 800 }
                            )
                        |> queryView
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
            , describe "when logged in"
                [ test "shows the user's name"
                    (\_ ->
                        smallScreen
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> queryView
                            |> Query.has [ text "some-user" ]
                    )
                , test "does not show logout button"
                    (\_ ->
                        smallScreen
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> queryView
                            |> Query.findAll [ text "logout" ]
                            |> Query.count (Expect.equal 0)
                    )
                , test "clicking username sends ToggleUserMenu message"
                    (\_ ->
                        smallScreen
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> queryView
                            |> Query.find [ class "user-id", containing [ text "some-user" ] ]
                            |> Event.simulate Event.click
                            |> Event.expect NewTopBar.ToggleUserMenu
                    )
                , test "ToggleUserMenu message shows logout button"
                    (\_ ->
                        smallScreen
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> updateModel NewTopBar.ToggleUserMenu
                            |> queryView
                            |> Query.findAll [ text "logout" ]
                            |> Query.count (Expect.equal 1)
                    )
                ]
            , test "shows no search input"
                (\_ ->
                    smallScreen
                        |> queryView
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
                )
            , test "shows search input when resizing"
                (\_ ->
                    smallScreen
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 1200, height = 900 }
                            )
                        |> queryView
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 1)
                )
            , test "sends a ShowSearchInput message when the search button is clicked"
                (\_ ->
                    smallScreen
                        |> queryView
                        |> Query.find [ class "search-btn" ]
                        |> Event.simulate Event.click
                        |> Event.expect NewTopBar.ShowSearchInput
                )
            , describe "on ShowSearchInput"
                [ test "hides the search button"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> queryView
                            |> Query.findAll [ class "search-btn" ]
                            |> Query.count (Expect.equal 0)
                    )
                , test "shows the search bar"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> queryView
                            |> Query.findAll [ tag "input" ]
                            |> Query.count (Expect.equal 1)
                    )
                , test "hides the user info/logout button"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> queryView
                            |> Query.findAll [ text "some-user" ]
                            |> Query.count (Expect.equal 0)
                    )
                , test "sends a BlurMsg message when the search input is blurred"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> queryView
                            |> Query.find [ tag "input" ]
                            |> Event.simulate Event.blur
                            |> Event.expect NewTopBar.BlurMsg
                    )
                ]
            , describe "on BlurMsg"
                [ test "hides the search bar when there is no query"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> updateModel NewTopBar.BlurMsg
                            |> queryView
                            |> Query.findAll [ tag "input" ]
                            |> Query.count (Expect.equal 0)
                    )
                , test "hides the autocomplete when there is a query"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> updateModel (NewTopBar.FilterMsg "status:")
                            |> updateModel NewTopBar.BlurMsg
                            |> queryView
                            |> Expect.all
                                [ Query.findAll [ tag "input" ]
                                    >> Query.count (Expect.equal 1)
                                , Query.findAll [ tag "ul" ]
                                    >> Query.count (Expect.equal 0)
                                ]
                    )
                , test "shows the search button"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> updateModel NewTopBar.BlurMsg
                            |> queryView
                            |> Query.findAll [ class "search-btn" ]
                            |> Query.count (Expect.equal 1)
                    )
                , test "shows the user info/logout button"
                    (\_ ->
                        smallScreen
                            |> updateModel NewTopBar.ShowSearchInput
                            |> updateModel NewTopBar.BlurMsg
                            |> updateModel
                                (NewTopBar.UserFetched
                                    (RemoteData.Success
                                        { id = "some-user"
                                        , userName = "some-user"
                                        , name = "some-user"
                                        , email = "some-user"
                                        , teams = Dict.empty
                                        }
                                    )
                                )
                            |> queryView
                            |> Query.has [ text "some-user" ]
                    )
                ]
            , describe "starting with a query"
                [ test "shows the search input on small screens"
                    (\_ ->
                        NewTopBar.init True "some-query"
                            |> Tuple.first
                            |> updateModel
                                (NewTopBar.ScreenResized
                                    { width = 300, height = 800 }
                                )
                            |> queryView
                            |> Query.findAll [ tag "input" ]
                            |> Query.count (Expect.equal 1)
                    )
                ]
            ]
        , describe "on large screens"
            [ test "shows the entire search input on large screens"
                (\_ ->
                    NewTopBar.init True ""
                        |> Tuple.first
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 1200, height = 900 }
                            )
                        |> queryView
                        |> Query.find [ tag "input" ]
                        |> Query.has [ attribute (Attributes.placeholder "search") ]
                )
            , test "hides the search input on changing to a small screen"
                (\_ ->
                    NewTopBar.init True ""
                        |> Tuple.first
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 1200, height = 900 }
                            )
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 300, height = 800 }
                            )
                        |> queryView
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
                )
            , test "shows no search bar on high density" <|
                \_ ->
                    NewTopBar.init False ""
                        |> Tuple.first
                        |> updateModel
                            (NewTopBar.ScreenResized
                                { width = 1200, height = 900 }
                            )
                        |> queryView
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 0)
            ]
        ]
