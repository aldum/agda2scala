module Agda.Compiler.Scala.PrintScalaExpr ( printScalaExpr
  , printCaseObject
  , printSealedTrait
  , printPackage
  ) where

import Agda.Compiler.Scala.ScalaExpr ( ScalaName, ScalaExpr(..) )

printScalaExpr :: ScalaExpr -> String
printScalaExpr def = case def of
  (SePackage pName defs) ->
    printPackage pName <> defsSeparator
    <> (
      blankLine -- between package declaration and first definition
      <> combineLines (map printScalaExpr defs)
      )
    <> defsSeparator
  (SeAdt adtName adtCases) ->
    printSealedTrait adtName
    <> defsSeparator
    <> unlines (map (printCaseObject adtName) adtCases)
  (Unhandled name payload) -> "" -- for development comment out this and uncomment below
  -- (Unhandled name payload) -> "TODO " ++ (show name) ++ " " ++ (show payload)
  -- other -> "unsupported printScalaExpr " ++ (show other)

printSealedTrait :: ScalaName -> String
printSealedTrait adtName = "sealed trait" <> exprSeparator <> adtName

printCaseObject :: ScalaName -> ScalaName -> String
printCaseObject superName caseName =
  "case object" <> exprSeparator <> caseName <> exprSeparator <> "extends" <> exprSeparator <> superName

printPackage :: ScalaName -> String
printPackage pName = "package" <> exprSeparator <> pName

bracket :: String -> String
bracket str = "{\n" <> str <> "\n}"

defsSeparator :: String
defsSeparator = "\n"

blankLine :: String
blankLine = "\n"

exprSeparator :: String
exprSeparator = " "

combineLines :: [String] -> String
combineLines xs = unlines (filter (not . null) xs)
