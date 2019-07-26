{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Data.List as List
import Data.Text.Lazy (toStrict)
import Data.Text.Encoding (encodeUtf8)
import System.Environment as Env
import System.Exit as Exit
import qualified Data.Aeson as Aeson
import qualified Data.Aeson.Text as AesonText
import qualified Data.Text as Text
import qualified Data.Text.IO as TextIO
import qualified PSJ as PSJ

main :: IO ()
main = do
  args <- Env.getArgs
  case args of
    ["to", path] -> toJSONLFromPurs path
    ["from", path] -> fromPursToJSONL path
    ["to"] -> Exit.die "to requires a filepath argument to a PureScript source file."
    ["from"] -> Exit.die "from requires a filepath argument to a JSONL source file."
    [] -> Exit.die helpMsg
    _ -> do Exit.die $ "Unknown commands or args: " <> show args

toJSONLFromPurs :: FilePath -> IO ()
toJSONLFromPurs path = do
  input <- TextIO.readFile path

  case sequence $ PSJ.parse input of
    Right xs -> do
      _ <- traverse (TextIO.putStrLn . toStrict . AesonText.encodeToLazyText) xs
      return ()
    Left e -> do
      let errors = List.unlines $ show <$> e
      let msg = List.unlines
            [ "errors from parsing PureScript sources:"
            , errors
            ]
      Exit.die msg

fromPursToJSONL :: FilePath -> IO ()
fromPursToJSONL path = do
  input <- TextIO.readFile path

  case traverse (Aeson.eitherDecodeStrict . encodeUtf8) $ Text.lines input of
    Right sourceTokens -> do
      TextIO.putStr $ PSJ.print sourceTokens
    Left e -> do
      let errors = List.unlines $ show <$> e
      let msg = List.unlines
            [ "errors from parsing PureScript sources:"
            , errors
            ]
      Exit.die msg

helpMsg :: String
helpMsg = List.unlines
  [ "purs-src-json:"
  , "  get PureScript sources concrete syntax tokens as JSONL"
  , "  and convert the CST JSONL into PureScript source."
  , ""
  , "usage:"
  , "  to [filepath.purs]"
  , "  convert the file given at filepath.purs to JSONL."
  , ""
  , "  from [filepath.jsonl]"
  , "    convert the JSONL given at filepath.jsonl"
  , ""
  , "what is JSONL:"
  , "  JSONL is JSON Lines, where no newlines are allowed in the contents,"
  , "  but each line is a valid JSON object."
  , ""
  , "see purs-src-json/src/PSJ/Types.hs"
  ]
