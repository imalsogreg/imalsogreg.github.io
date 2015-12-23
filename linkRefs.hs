module Main where

import qualified Data.Text as T
import Data.Char
import Options.Applicative
import Data.IntMap
import Data.Maybe
import Safe
import qualified Data.Foldable as F

data FixOpts = FixOpts { bodyPath :: FilePath
                       , refsPath :: FilePath
                       }

fixOpts :: Parser FixOpts
fixOpts = FixOpts
          <$> strOption
          ( short 'b'
            <> metavar "BODY"
            <> help "Input BODY file")
          <*> strOption
          ( short 'r'
            <> metavar "REFS"
            <> help "References file")

isName :: T.Text -> Bool
isName w = ( (>1) . T.length ) w && F.all isAlpha (T.unpack w)

year :: T.Text -> Maybe Int
year w = let candidate =
               T.takeWhile (not . isAlpha) . T.dropWhile isAlpha $ w in
  case T.length candidate of
    4 -> readMay . T.unpack $ candidate
    _ -> Nothing

firstAuthor :: T.Text -> Maybe T.Text
firstAuthor l = listToMaybe . dropWhile (not . isName) . T.words $ l

bodyParts :: T.Text -> [T.Text]
bodyParts = T.split (\c -> c == '(' || c == ')')

evensOdds :: [T.Text] -> ([T.Text],[T.Text])
eventsOdds 

recombineBody :: (T.Text -> T.Text) -> [T.Text] -> T.Text
recombineBody f parts = let transParts = map f parts in aux '(' parts ""
  where
    aux _ [] acc = cc

main = undefined