module PSJ.Printer where

import Data.Text (Text)
import qualified Data.Text as Text
import qualified Language.PureScript.CST.Print as Print
import qualified Language.PureScript.CST.Types as CST
import qualified PSJ.Types as Types

-- override a few tokens being printed
printToken :: CST.Token -> Text
printToken token = case token of
  CST.TokLayoutStart -> Text.empty
  CST.TokLayoutSep -> Text.empty
  CST.TokLayoutEnd -> Text.empty
  CST.TokEof -> Text.empty
  _ -> Print.printToken token

-- Print.printTokens, but with overridden printToken and PSJ types
printTokens :: [Types.PSJSourceToken] -> Text
printTokens toks = Text.concat (map pp toks)
  where
  pp (Types.PSJSourceToken (Types.PSJTokenAnn leading trailing) tok) =
    Text.concat (map Print.printLeadingComment leading)
      <> printToken tok
      <> Text.concat (map Print.printTrailingComment trailing)
