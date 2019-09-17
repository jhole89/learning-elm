module Post exposing (Post, decoder, encode, estimatedReadTime)

import Json.Decode as D
import Json.Encode as E



-- POST


type alias Post =
    { title : String
    , author : String
    , content : String
    }



-- READ TIME


estimatedReadTime : Post -> Float
estimatedReadTime post =
    toFloat (wordCount post) / 220


wordCount : Post -> Int
wordCount post =
    List.length (String.words post.content)



-- JSON


encode : Post -> E.Value
encode post =
    E.object
        [ ( "title", E.string post.title )
        , ( "author", E.string post.author )
        , ( "content", E.string post.content )
        ]


decoder : D.Decoder Post
decoder =
    D.map3 Post
        (D.field "title" D.string)
        (D.field "author" D.string)
        (D.field "content" D.string)
