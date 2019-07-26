module PSJ where

import Data.Text (Text)
import qualified Language.PureScript.CST.Lexer as Lexer
import qualified PSJ.Printer as Printer
import qualified PSJ.Types as Types

parse :: Text -> [Types.ParseResult]
parse = map Types.fromLexResult . Lexer.lex

print :: [Types.PSJSourceToken] -> Text
print = Printer.printTokens
