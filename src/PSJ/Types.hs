{-# LANGUAGE DeriveGeneric #-}

module PSJ.Types where

import Data.Void (Void)
import GHC.Generics (Generic)
import qualified Data.Aeson as Aeson
import qualified Language.PureScript.CST.Monad as CST
import qualified Language.PureScript.CST.Types as CST

fromCSTTokenAnn :: CST.TokenAnn -> PSJTokenAnn
fromCSTTokenAnn (CST.TokenAnn _ a b) = PSJTokenAnn a b

fromCSTSourceToken :: CST.SourceToken -> PSJSourceToken
fromCSTSourceToken (CST.SourceToken ta x) = PSJSourceToken (fromCSTTokenAnn ta) x

type ParseResult = Either String PSJSourceToken

fromLexResult :: CST.LexResult -> ParseResult
fromLexResult result = case result of
  Left e -> Left $ show e
  Right x -> Right $ fromCSTSourceToken x

data PSJTokenAnn = PSJTokenAnn
  { leadingComments :: ![CST.Comment CST.LineFeed]
  , trailingComments :: ![CST.Comment Void]
  } deriving (Show, Eq, Ord, Generic)

data PSJSourceToken = PSJSourceToken
  { tokAnn :: !PSJTokenAnn
  , tokValue :: !CST.Token
  } deriving (Show, Eq, Ord, Generic)

instance Aeson.ToJSON PSJTokenAnn
instance Aeson.FromJSON PSJTokenAnn

instance Aeson.ToJSON PSJSourceToken
instance Aeson.FromJSON PSJSourceToken

instance Aeson.ToJSON CST.Token
instance Aeson.FromJSON CST.Token
instance Aeson.ToJSON CST.SourceStyle
instance Aeson.FromJSON CST.SourceStyle
instance Aeson.ToJSON CST.LineFeed
instance Aeson.FromJSON CST.LineFeed
instance (Aeson.ToJSON a) => Aeson.ToJSON (CST.Comment a)
instance (Aeson.FromJSON a) => Aeson.FromJSON (CST.Comment a)
