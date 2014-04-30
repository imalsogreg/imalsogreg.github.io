--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
--import           HakyllBibTex
import           Text.Pandoc.Definition
import           Debug.Trace

--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do

    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

{-
    names <- preprocess $ do
      bibFile <- parseBibFile <$> readFile "auxdata/gallistel.bib"
      return bibFileEntryNames bibFile

    match "auxdata/gallistel.bib" $ do
      route idRoute
      compile bibFileCompiler

    forM_ names $ \name -> do
      create [fromCapture "papers/*.html" name] $ do
        route idRoute
        compile $ do
          bibFile <- loadBody "auxdata/gallistel.bib"
          let bibEntry = lookupBibEntry name bibFile 
          makeItem bibEntry >>=
            loadAndApplyTemplate "paper.html" bibEntryContext

    match "auxdata/gallistel.bib" $ do
        route idRoute
        compile biblioCompiler


    match "auxdata/apa.csl" $ do
        compile cslCompiler
-}

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/post.html"    postCtx
            >>= loadAndApplyTemplate "templates/default.html" postCtx
            >>= relativizeUrls


    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls



    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext
