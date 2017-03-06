module Data.String.Interpolate.Parse where

import           Data.String.Interpolate.Internal.Util

data Node = Literal String | Expression String

parseNodes :: String -> [Node]
parseNodes = go ""
  where
    go :: String -> String -> [Node]
    go acc input = case input of
      ""  -> [(lit . reverse) acc]
      '\\':x:xs -> go (x:'\\':acc) xs
      '$':'{':xs -> case span (/= '}') xs of
        (ys, _:zs) -> (lit . reverse) acc : Expression ys : go "" zs
        (_, "") -> [lit (reverse acc ++ input)]
      x:xs -> go (x:acc) xs

    lit :: String -> Node
    lit = Literal . unescape
