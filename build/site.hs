--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Data.Monoid (mappend)
import           Hakyll
import           HakyllBibTex
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


    match "auxdata/gallistel.bib" $ do
        compile biblioCompiler

    match "auxdata/apa.csl" $ do
        compile cslCompiler


    match "posts/*" $ do
        route $ setExtension "html"
        compile $ do
          bib <- load "auxdata/gallistel.bib"
          csl <- load "auxdata/apa.csl"
          
          a <- pandocCompiler
          d <-readPandocBiblio defaultHakyllReaderOptions csl bib a
          b <- loadAndApplyTemplate "templates/post.html"    postCtx $ (writePandoc d)
          c <- loadAndApplyTemplate "templates/default.html" postCtx $ b

          relativizeUrls c

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
